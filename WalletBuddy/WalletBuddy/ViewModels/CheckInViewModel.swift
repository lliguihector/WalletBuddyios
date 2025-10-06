//
//  CheckInViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 9/23/25.
//
import Foundation
import CoreLocation
import MapKit

@MainActor
class CheckInViewModel: ObservableObject {
    
    //MARK: - Published Properties
    @Published var showSuccessAlert = false
    @Published var showFailureAlert = false
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
   
    
    
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    
    
  

    
    //MARK: - Dependencies
    private let apiService = ApiService.shared
    private let firebaseService = FirebaseAuthManager.shared
    private let locationManager = LocationManager()

    //MARK: - State
    private(set) var lastKnownLocation: CLLocation?
    
    
    
    
    //MARK: - Init
    init() {
        //Listen for location updates
        locationManager.onLocationUpdate = {[weak self] location in
           
            guard let self = self else {return}
            
            //Store last known liocation for manual check-ins
            self.lastKnownLocation = location
            
            //update region to follow user
            Task{ @MainActor in
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
            
            //Auto check-in when location updates (optional)
//            Task{
//                await self.handleLocationUpdate(location)
//            }
        }
    }

    //MARK: - Manual Check-In
    func checkinManually() async {
        guard let location = lastKnownLocation else{
            print("No last known location to check in with.")
            return
        }
        await handleLocationUpdate(location)
    }
    


    //MARK: - Fit Map to User + Organization
    //Update map region to fit multiple coordinates (user + organizations)
    func updateRegionToFit(userLocation: CLLocation?, organizationCoordinates: [CLLocationCoordinate2D]){
        
        var allCoords: [CLLocationCoordinate2D] = organizationCoordinates
        
        if let user = userLocation{
            allCoords.append(user.coordinate)
        }
        
        guard !allCoords.isEmpty else{return}
        
        
        let latitudes = allCoords.map {$0.latitude}
        let longitudes = allCoords.map {$0.longitude}
        
        
        let minLat = latitudes.min()!
        let maxLat = latitudes.max()!
        let minLon = longitudes.min()!
        let maxLon = longitudes.max()!
        
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLon + maxLon)/2)
        
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5)
        
        
        //UI updates always on main thread
        DispatchQueue.main.async{
            self.region = MKCoordinateRegion(center: center, span: span)
        }
        
    }
    
    
    
    
private func handleLocationUpdate(_ location: CLLocation) async{
        isLoading = true
    defer{isLoading = false}//Always hide loading on exit (success or failure)
        do{
            
            guard let idToken = try await firebaseService.getIDToken(forceRefresh: true) else {
                print("❌ Failed to get Firebase token")
                showFailureAlert = true
                errorMessage = "Authentication failed. Please log in again."
                return
            }

            
   let result = await apiService.sendLocationToDB(withToken: idToken,latitude: location.coordinate.latitude,longitude: location.coordinate.longitude)

            
        switch result {
            case .success(let checkIn):
                print("✅ Location check-in successful: \(checkIn)")
            
            
            
                showSuccessAlert = true
                errorMessage = nil //Clear any previous errors
    
            
            
            case .failure(let error):
                print("❌ Error sending location: \(error)")
              showFailureAlert = true
        
            
            //Map error to user-friendly message
            switch error{
            case .invalidURL:
                errorMessage = "Something went wrong with the server URL."
            case .serializationError:
            errorMessage = "Could not prepare location data to send."
            case .decodingError:
                
                errorMessage = "Could not understand the server response"
            case .networkError(let err):
                errorMessage = "Network issue: \(err.localizedDescription)"
            case .serverError( _ , let message):
                //Use backend's actual error message, or a dedault
                errorMessage = message ?? "Server rejected the request."
            }
            }
        } catch {
            print("❌ Unexpected error: \(error)")
            showFailureAlert = true
            errorMessage = "An unexpected error occured. Please try again later."
        }
    }
    

 
}

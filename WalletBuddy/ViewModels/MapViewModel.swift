//
//  CheckInViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 9/23/25.
//
import Foundation
import CoreLocation
import MapKit
import SwiftUI


class MapViewModel: ObservableObject {
    
    //MARK: -- Enviornment Objects
    @EnvironmentObject var userViewModel: UserViewModel
    
    
    //MARK: - Published Properties
    @Published var showSuccessAlert = false
    @Published var showFailureAlert = false
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var shouldFollowUser = true
    @Published var isAuthorized: Bool = false
    //MARK: - State
    private(set) var lastKnownLocation: CLLocation?
    
    
    
    //USER & ORGANIZATION Coordinates
    @Published var userCoordinate: CLLocationCoordinate2D?
    @Published var organizationCoordinate: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion?
    @Published var organizationCamera: MapCameraPosition?
    
    

    
    //MARK: - Dependencies
    private let apiService = ApiService.shared
    private let firebaseService = FirebaseAuthManager.shared
    private let locationManager = LocationManager()



    //MARK: - Init
    init(userViewModel: UserViewModel) {
        
        //Observ userViewModel for organization location
//        if let orgLocation = userViewModel.appUser?.organization?.location.coordinates,
//        orgLocation.count == 2{
//            organizationCoordinate = CLLocationCoordinate2D(latitude: orgLocation[0], longitude: orgLocation[1])
//        }else{
//            //Fallback to default location (can be city center or 0,0)
//            organizationCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//            print("Organization location not found, using default coordinates")
//        }
          
        
        if let coords = userViewModel.appUser?.organization?.location.coordinates,
           coords.count == 2 {
            let orgCoord = CLLocationCoordinate2D(latitude: coords[0], longitude: coords[1])
            organizationCoordinate = orgCoord
            
            organizationCamera = .region(
                .init(
                    center: orgCoord,
                    latitudinalMeters: 100,
                    longitudinalMeters: 100
                )
            )
        }

        
          
          
          
//          //Listen for location updates
//          locationManager.onLocationUpdate = { [weak self] location in
//              guard let self = self else { return }
//              self.lastKnownLocation = location
//              
//              if self.shouldFollowUser {
//                  DispatchQueue.main.async {
//                      self.region = MKCoordinateRegion(
//                          center: location.coordinate,
//                          span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                      )
//                  }
//              }
//          }
        print("\(organizationCoordinate)")

      }

//MARK: - -------------- DATA MANIPULATION FUNCTION ---------
    //MARK: - Manual Check-In User
    func checkinManually() async {
        guard let location = lastKnownLocation else{
            print("No last known location to check in with.")
            return
        }
        await handleLocationUpdate(location)
    }
    


    //MARK: - CHECK IN USER TO backen
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
//Get decie ID
            let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown Device ID"
            
            
            
            
            let result = await apiService.sendLocationToDB(withToken: idToken,latitude: location.coordinate.latitude,longitude: location.coordinate.longitude, deviceID: deviceID)

            
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

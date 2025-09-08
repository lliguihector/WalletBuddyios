//
//  LocationManager.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/30/25.
//
import Foundation
import FirebaseAuth
import CoreLocation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    let apiService = ApiService.shared
    let firebaseService = FirebaseAuthManager.shared
    @Published var showSuccessAlert = false
    
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default SF
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("Latitude: \(latitude), Longitude: \(longitude)")
        
        Task { [weak self] in
            await self?.sendLocationToDB(latitude, longitude)
        }
    }
    
    private func sendLocationToDB(_ latitude: Double, _ longitude: Double) async {
        do {
            guard let idToken = try await firebaseService.getIDToken(forceRefresh: true) else {
                print("Failed to get Firebase ID Token from Location Manager")
                return
            }
            
            //`idToken` + send to backend
        print("ID Token retrieved successfully")
            
            
            //Send data to backend and check success
            let success =  await apiService.sendLocationToDB(withToken: idToken, latitude: latitude, longitude: longitude)
            
            
            if success{
                print("Location sent successfully")
                
                
                showSuccessAlert = true
            }else{
                print("Failed to send location")
            }
        
            
        } catch {
            print("Failed to send location to backend: \(error)")
        }
        
   
    }
}

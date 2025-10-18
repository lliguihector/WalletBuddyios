//
//  LocationManager.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/15/25.
//

import Foundation
import CoreLocation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject, @preconcurrency CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default SF
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    
    //Closure callBack to pass location updates to ViewModel
    var onLocationUpdate: ((CLLocation)-> Void)?
    
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10 //Only update if user moved 10 meters (avoiding spam)
        
        
//        manager.distanceFilter = kCLDistanceFilterNone
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
    }
    
    
    
    //MARK: -- Location Permissions
    func requestWhenInUseAuthorization(){
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            manager.startUpdatingLocation()
        }else{
            print("Location services are disabled.")
        }
    }
    
    //Stop updating location
    func stopUpdatingLocation(){
        manager.startUpdatingLocation()
    }
    
    //MARK: - Delegate Methods
    
    
    //Called whenever user's location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        
        //Update the map region
        self.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        //Emit location to whoever is listening (ViewModel)
        
        onLocationUpdate?(location)
    }
    

    

    
    //Handle permission changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted.")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
        
        
        
    }
 
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
    }

    
    
    
    


}

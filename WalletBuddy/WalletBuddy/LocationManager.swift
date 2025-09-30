//
//  LocationManager.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/30/25.
//
import Foundation
import CoreLocation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
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
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        
        //Update region
        self.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        //Emit location to whoever is listening (ViewModel)
        
        onLocationUpdate?(location)
    }
}

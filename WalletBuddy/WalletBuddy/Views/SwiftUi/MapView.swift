//
//  SettingsView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/21/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    
   @StateObject private var locationManager = LocationManager()
    
    
    
    
    var body: some View {
        VStack(spacing: 0){
            
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
               
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MapView()
}

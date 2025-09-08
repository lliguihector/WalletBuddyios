//
//  HomeTabView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/30/25.
//

import SwiftUI
import MapKit

struct HomeTabView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @StateObject private var locationManager = LocationManager()
    @State private var showAlert = false
    
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // -------------------
                    // Horizontal Profile Card
                    HStack(spacing: 16) {
                        // Profile Image
                        Image("logo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 7)
                        
                        // Texts
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hector Lliguichuzhca")
                                .font(.headline)
                            
                            Text("Software Developer")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(userViewModel.appUser?.email ?? "email@example.com")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // -------------------
                    // Map Card
                    Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    
                    // -------------------
                    // Clock In Button Card
                    Button(action: {
                        print("Clock In tapped")
                        
                        
                //Send location to DB on App Launch 
                        
                        
                        
                        
                        
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("Clock In")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mint.opacity(0.2))
                        .foregroundColor(.mint)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    
                }
                .padding(.vertical)
                .disabled(!networkMonitor.isConnected)
                .opacity(networkMonitor.isConnected ? 1 : 0.5)
            }
            
            // -------------------
            // Offline overlay
            if !networkMonitor.isConnected {
                offlineView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: networkMonitor.isConnected)
        
        //------
        //Success Alert
        .onReceive(locationManager.$showSuccessAlert){ value in
            if value{
                showAlert = true
                locationManager.showSuccessAlert = false
            }
            
        }
        .alert("Success", isPresented: $showAlert){
            Button("OK", role: .cancel){}
        }message:{
            Text("Your location has been sent successfully")
        }
    }
}

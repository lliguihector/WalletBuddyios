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
    
    @State private var showMapView = false
    
    var body: some View {
        ZStack {
            
            
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Greeting Section
                    HStack {
                        Text("\(greatingMessage()), \(userViewModel.appUser?.firstName ?? "User")")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    
                    // MARK: - Last Check-In Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.blue)
                            Text("Last Check-In")
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("Date & Time:")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("Oct 14, 2025 at 2:01 AM") // Replace with dynamic date
                                .foregroundColor(.primary)
                        }
                        Divider()
                        HStack {
                            Text("Location:")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("Room 201") // Replace with dynamic device info
                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    // MARK: - Start Check-In Button
                    Button(action: { showMapView = true }) {
                        HStack {
                            Image(systemName: "clock.badge.checkmark")
                            Text("Start Check-In")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color.blue, Color.cyan], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            
            // MARK: - Map Sheet
            .sheet(isPresented: $showMapView) {
                MapView()
            }
            
            // MARK: - Offline Banner
            if !networkMonitor.isConnected {
                VStack {
                    Text("No Internet Connection")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                    Spacer()
                }
                .transition(.move(edge: .top))
                .zIndex(1)
            }
        }
    }
    
    // MARK: - Greeting Logic
    func greatingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
}

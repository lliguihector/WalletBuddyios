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
    
  
    
    // Toast state
    @State private var toastMessage: String? = nil
    @State private var showToast = false
    @State private var toastIsError = false
    @State private var showMapView = false
    // Organization sheet
    @State private var showOrgSheet = false
    @State private var selectedOrganization: Organization? = nil
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // -------------------
                    // Horizontal Profile Card
                    HStack(spacing: 16) {
                        // Profile Image
                        if let image = userViewModel.profileImage{
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 7)
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 7)
                                .foregroundColor(.gray)
                        }
                        
                        // Texts
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(userViewModel.appUser?.firstName ?? "") \(userViewModel.appUser?.lastName ?? "")")
                                .font(.headline)
                            Text(userViewModel.appUser?.title ?? "No title")
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
                    // After your profile card HStack
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Last Check In")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 16)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Text("Last Login:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("N/A")
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            Divider()
                            
                            HStack {
                                Text("Device Info:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text( "Unknown")
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            Divider()
                        }
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    
                    
                    
                    // -------------------
                    //                    Button("Show APNs Token") {
                    //                        if let token = DeviceManager.shared.currentToken {
                    //                            print("APNs Token: \(token)")
                    //                        } else {
                    //                            print("No token stored")
                    //                        }
                    //                    }
                    
                    // -------------------
                    // Clock In Button
                    Button(action: {
                        Task {
                            //                            await viewModel.checkinManually()
                            //show map after check-in
                            showMapView = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("Start Check In")
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
            
            //Mark: - Sheet for Map Check-In
            .sheet(isPresented: $showMapView){
                MapView()
            }
            
            // -------------------
            if !networkMonitor.isConnected {
                offlineView()
                    .transition(.opacity)
                    .zIndex(1)
            }
            
        }
    }
    

    // MARK: - Organization Annotation
    struct OrganizationAnnotation: Identifiable {
        let id: String
        let coordinate: CLLocationCoordinate2D
    }
    
    func getOrganizationAnnotation() -> [OrganizationAnnotation] {
        guard let org = userViewModel.appUser?.organization,
              org.location.coordinates.count == 2 else { return [] }
        let coord = CLLocationCoordinate2D(
            latitude: org.location.coordinates[0],
            longitude: org.location.coordinates[1]
        )
        return [OrganizationAnnotation(id: org.name, coordinate: coord)]
    }
}

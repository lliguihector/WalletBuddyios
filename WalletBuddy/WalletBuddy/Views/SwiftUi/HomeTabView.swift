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
    
    @StateObject private var viewModel = CheckInViewModel()
    
    
    
    
    @State private var showAlert = false
    
    // For organization annotation sheet
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
                    // Map Card
                    Map(coordinateRegion: $viewModel.region,
                        showsUserLocation: true,
                        annotationItems: getOrganizationAnnotation()) { org in
                        
                        MapAnnotation(coordinate: org.coordinate) {
                            Button(action: {
                                // Show organization sheet
                                selectedOrganization = userViewModel.appUser?.organization
                                showOrgSheet = true
                            }) {
                                VStack(spacing: 4) {
                                    Image("location-pointer")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Text(userViewModel.appUser?.organization?.name ?? "Organization")
                                        .font(.caption2)
                                        .bold()
                                        .fixedSize(horizontal: true, vertical: false)
                                }
                            }
                            .buttonStyle(PlainButtonStyle()) // Prevent default button styling
                        }
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .sheet(isPresented: $showOrgSheet) {
                        if let org = selectedOrganization {
                            
                            OrganizationDetailsView(organization: org)
                        }
                    }
                    
                    // -------------------
                    // Clock In Button Card
                    Button(action: {
                      
                        // Send location to DB on button press if needed
                        Task{
                            await viewModel.checkinManually()
                        }
                       
                    }) {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("Check In")
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
        .onReceive(viewModel.$showSuccessAlert) { value in
            if value {
                showAlert = true
                viewModel.showSuccessAlert = false
            }
        }
        .alert("Check-In Successful", isPresented: $viewModel.showSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your location has been sent successfully")
        }
        .alert("Check-In Failed", isPresented: $viewModel.showFailureAlert){
            Button("OK", role: .cancel){}
        }message:{
            Text(viewModel.errorMessage ?? "An unknown error occured.")
        }
    }
    
    //MARK: - Organization Annotation
    struct OrganizationAnnotation: Identifiable {
        let id: String
        let coordinate: CLLocationCoordinate2D
    }
    
    func getOrganizationAnnotation() -> [OrganizationAnnotation] {
        guard let org = userViewModel.appUser?.organization,
              org.location.coordinates.count == 2 else { return [] }
        
        let coord = CLLocationCoordinate2D(
            latitude: org.location.coordinates[1],
            longitude: org.location.coordinates[0]
        )
        return [OrganizationAnnotation(id: org.name, coordinate: coord)]
    }
}









// MARK: - Organization Detail Sheet

//
//  ProfileView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/21/25.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Profile Header
                    VStack(spacing: 8) {
                        if let logoUrl = userViewModel.appUser?.profileImageUrl,
                           let url = URL(string: logoUrl) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 0.5))
                                   
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.white) // Air Jordan Royal Blue
                                .background(
                                    Circle()
                                        .fill(Color.secondary) // Gray background inside the circle
                                        .frame(width: 110, height: 110) // Slightly bigger than the icon
                                )
//                                .overlay(
//                                    Circle()
//                                        .stroke(Color.sportRoyal, lineWidth: 4) // Border matching the royal blue
//                                )
                             

                        }
                        
                        Text("\(userViewModel.appUser?.firstName ?? "") \(userViewModel.appUser?.lastName ?? "")")
                            .font(.title2)
                            .bold()
                        
                        Text(userViewModel.appUser?.title ?? "No title")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(userViewModel.appUser?.email ?? "email@example.com")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // MARK: - Information Section
                    VStack(spacing: 12) {
                        
                        NavigationLink(destination: UIDView(uid: userViewModel.appUser?.uid ?? "No UID ")){
                            infoRow(label: "UID", value: "View", icon: "number")
                        }
                      
                        
                        
                        
                        infoRow(label: "Organization", value: userViewModel.appUser?.organization?.name ?? "N/A", icon: "building.2")
                        infoRow(label: "Email Verified", value: userViewModel.appUser?.emailVerified ?? false ? "Yes" : "No", icon: "checkmark.seal")
                        infoRow(label: "Sign-In Providers", value: userViewModel.appUser?.providerIds?.joined(separator: ", ") ?? "None", icon: "key")
                        infoRow(label: "Internet", value: networkMonitor.isConnected ? "Online" : "Offline", icon: "wifi")
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Contact Section
                    VStack(spacing: 12) {
                        infoRow(label: "Phone", value: "7185369221", icon: "phone.fill")
                        infoRow(label: "Email", value: userViewModel.appUser?.email ?? "email@example.com", icon: "envelope.fill")
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Logout Button
                    // MARK: - Logout Button
                    Button(action: { appViewModel.logout() }) {
                        HStack {
                            Image(systemName: "arrow.backward.square")
                                .foregroundColor(.primary)
                            Text("Log Out")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.3)) // Card color
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(UIColor.systemBackground), lineWidth: 1)
                        )
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    
                    // MARK: - App Version
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                       let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                        Text("App Version \(version) (\(build))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    
                    Spacer()
                }
                .padding(.vertical)
                .disabled(!networkMonitor.isConnected)
                .opacity(networkMonitor.isConnected ? 1 : 0.5)
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
                .ignoresSafeArea(edges: .top)
                .transition(.move(edge: .top))
                .zIndex(1)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Info Row Component
    @ViewBuilder
    func infoRow(label: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}


extension Color {
    static let sportRoyal = Color(red: 0.0, green: 0.0, blue: 1.0) // Approximation of Sport Royal
}
extension Color {
    static let aj5Gray = Color(red: 210/255, green: 210/255, blue: 210/255) // light-medium gray
}

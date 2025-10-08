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
        NavigationStack{
            ZStack {
                VStack(spacing: 16) {
                    // Top logo and name/email/title
                    VStack(alignment: .center, spacing: 2) {
                        
                        
                        if let logoUrl = userViewModel.appUser?.organization?.logoUrl, let url = URL(string: logoUrl) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 7)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            }
                        } else {
                            Image(systemName: "building.2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 7)
                        }
                        
                        
                        
//                        Image("logo")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 80, height: 80)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                            .shadow(radius: 7)
                        
                        Text("\(userViewModel.appUser?.firstName ?? "") \(userViewModel.appUser?.lastName ?? "")")
                            .font(.headline)
                        Text(userViewModel.appUser?.title ?? "No title")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(userViewModel.appUser?.email ?? "email@example.com")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 16)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(4)
                    
                    // Table/List
                    List {
                        Section(header: Text("Information").font(.headline)){
                            // Clickable row
                            NavigationLink(destination: UIDView(uid: userViewModel.appUser?.uid ?? "No UID")) {
                                TableRow(label: "UID", value: "")
                            }
                            
                            TableRow(label: "Organization", value: "\(userViewModel.appUser?.organization?.name ?? "No Organization")")
                            TableRow(label: "Email Verified", value: "\(userViewModel.appUser?.emailVerified ?? true)")
                        
                            TableRow(label: "Sign In Providers", value: "\(userViewModel.appUser?.providerIds?.joined(separator: ", ") ?? "None")")
                            TableRow(label: "Internet Connectivity", value: "\(networkMonitor.isConnected ? "Online" : "Offline")")
                            
                            
                        }
                        Section(header: Text("Contact Info").font(.headline)){
                            TableRow(label: "Phone", value: "7185369221")
                            TableRow(label: "Email", value: userViewModel.appUser?.email ?? "email@example.com")
                            
                            
                        }
                    }
                    .listStyle(.plain)
                    
                    Spacer()
                    
                    Button("Logout") {
                        //Call AppViewModel Log out
                        appViewModel.logout()
                    }
                    .foregroundColor(.mint)
                    
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                       let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                        Text("Version \(version) (\(build))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .disabled(!networkMonitor.isConnected)
                .opacity(networkMonitor.isConnected ? 1 : 0.5)
                
                if !networkMonitor.isConnected {
                    offlineView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .animation(.easeInOut, value: networkMonitor.isConnected)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
// Helper for row with edge-to-edge alignment
struct TableRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(UIColor.systemBackground))
        .listRowInsets(EdgeInsets())
    }
}

#Preview {
    ProfileView()
}

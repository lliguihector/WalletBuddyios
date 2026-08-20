//
//  ProfileView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/21/25.
//
import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor

    

    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack(spacing: 24) {
                    
                    // MARK: - Profile Header
                    VStack(spacing: 8) {
                        if let logoUrl = appViewModel.userSession.user?.profileImageUrl,
                           let url = URL(string: logoUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 0.5)
                                    )
                            }placeholder: {
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

                             

                        }
                        
                        Text("\(appViewModel.userSession.user?.firstName ?? "") \(appViewModel.userSession.user?.lastName ?? "")")
                            .font(.title2)
                            .bold()
                        
                        Text(appViewModel.userSession.user?.title ?? "No title")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                
                        
                        if let role = appViewModel.userSession.user?.role {
                            Text(role.displayName)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.amazingBlue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Color.amazingBlue.opacity(0.10)
                                )
                                .clipShape(Capsule())
                        }
                        
                        
                        
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                    .cornerRadius(16)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                Color(.separator).opacity(0.18),
                                lineWidth: 1
                            )
                    }

                    .padding(.horizontal)
                    
                    // MARK: - Information Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Account")
                            .font(.headline)
                            .padding(.leading, 4)
                        
                        
                    
                        NavigationLink(destination: OrganizationDetailsView()){
                            infoRow(label: "Organization", value: appViewModel.userSession.user?.organization?.name ?? "N/A", icon: "building.2.fill",  showChevron: true)
                        }
                        .buttonStyle(.plain)
                        
                        
                        if let employeeId = appViewModel.userSession.user?.employeeId,
                           !employeeId.isEmpty {
                            
                            infoRow(
                                label: "Employee ID",
                                value: employeeId,
                                icon: "person.text.rectangle.fill",
                                showChevron: false
                            )
                        }else{
                            //TODO: Remove dummy data once backend supports employeeId
                            infoRow(
                                label: "Employee ID",
                                value: "77368",
                                icon: "person.text.rectangle.fill",
                                showChevron: false
                            )
                        }

                        NavigationLink(destination: UIDView(uid: appViewModel.userSession.user?.uid ?? "No UID ")){
                            infoRow(label: "Account ID", value: "View ID", icon: "number.circle.fill", showChevron: true)
                        }
                        .buttonStyle(.plain)
                       
                
                        
                        
                        
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Contact Section
               
                    
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Contact Information")
                            .font(.headline)
                            .padding(.leading,4)
                        infoRow(label: "Phone", value: "7185369221", icon: "phone.fill", showChevron: false)
                        infoRow(label: "Email", value: appViewModel.userSession.user?.email ?? "email@example.com", icon: "envelope.fill",showChevron: false)
                    }
                    .padding(.horizontal)
                    
//MARK: - Security Section
                    
                    VStack(alignment: .leading, spacing: 12){
                        
                        Text("Security")
                            .font(.headline)
                            .padding(.leading,4)
                        
                        infoRow(label: "Email Verified", value: appViewModel.userSession.user?.emailVerified ?? false ? "Yes" : "No", icon: "checkmark.seal.fill",  showChevron: false)
                        
                    }
                    .padding(.horizontal)
                    
                    //MARK: - Legal Section
                    
                    // MARK: - Legal Section
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Text("Legal")
                            .font(.headline)
                            .padding(.leading, 4)
                        
                        NavigationLink {
                            //PrivacyPolicyView()
                        } label: {
                            infoRow(
                                label: "Privacy Policy",
                                value: "",
                                icon: "hand.raised.fill",
                                showChevron: true
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                           // TermsOfServiceView()
                        } label: {
                            infoRow(
                                label: "Terms of Service",
                                value: "",
                                icon: "doc.text.fill",
                                showChevron: true
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    
                    
                    
                    // MARK: - Logout Button
                    Button {
                        appViewModel.logout()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                 
                            
                            Text("Log Out")
                
                                .fontWeight(.semibold)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.red.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
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
            .background(Color(.systemGroupedBackground)) //Background view color
            
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
    func infoRow(label: String, value: String, icon: String, showChevron: Bool = false) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.amazingBlue)
                .frame(width: 24)
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
            
            if showChevron {
                       Image(systemName: "chevron.right")
                           .font(.caption)
                           .fontWeight(.semibold)
                           .foregroundColor(.secondary)
                   }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color(.separator).opacity(0.18),
                    lineWidth: 1
                )
        }
//        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}


extension Color {
    static let amazingBlue = Color(red: 23/155, green: 108/255, blue: 174/255) // Citi app Blue Color 
}
extension Color {
    static let aj5Gray = Color(red: 210/255, green: 210/255, blue: 210/255) // light-medium gray
}

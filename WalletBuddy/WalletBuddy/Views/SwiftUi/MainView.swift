//
//  MainView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {

    let user: AppUser
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 4)
                    )
                    .shadow(radius: 7)
                Text("your email is: \(user.email)")
                Text("your user uid is: \(user.id)")
                Text("Internet Connectivity: \(networkMonitor.isConnected)")
                Button("Logout") {
                    appViewModel.logout()
                  
                }
                
                Spacer()
            }
            .padding()
            .disabled(!networkMonitor.isConnected) // Disable interaction when offline
            .opacity(networkMonitor.isConnected ? 1 : 0.5) // Optional visual cue
            
            if !networkMonitor.isConnected {
                offlineView()
                    .transition(.opacity)
                    .zIndex(1)  // Ensure offline view is on top
            }
        }
        .animation(.easeInOut, value: networkMonitor.isConnected)
    }
}

#Preview {
    MainView(user: AppUser(id: "12345", email: "test@example.com"))
        .environmentObject(AppViewModel.shared)
        .environmentObject(NavigationRouter.shared)
        .environmentObject(NetworkMonitor.shared)
}

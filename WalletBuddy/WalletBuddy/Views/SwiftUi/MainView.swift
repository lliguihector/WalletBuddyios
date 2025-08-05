//
//  MainView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    //Global Access
    @EnvironmentObject var userViewModel: UserViewModel
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

                Text("Welcome!").bold()
                Text("\(userViewModel.appUser?.firstName ?? "nil")  \(userViewModel.appUser?.lastName ?? "nil")")
                Text("Email: ").bold() + Text("\(userViewModel.appUser?.email ?? "No Email")")
                Text("UID: ").bold() + Text("\(userViewModel.appUser?.uid ?? "No UID")")
                Text("Profile Complete: ").bold() + Text("\(userViewModel.appUser!.profileCompleted)")
                Text("Internet Connectivity: ").bold() + Text("\(networkMonitor.isConnected)")
                Button("Logout") {
                    
                    appViewModel.logout()
//                    NavigationRouter.shared.popToRoot() MOVED TO AppViewModel
                  
                }
                
                Spacer()
            }
            .padding()
            .disabled(!networkMonitor.isConnected) // Disable interaction when offline
            .opacity(networkMonitor.isConnected ? 1 : 0.5) // Optional visual cue
            
            
            //Disables View when internet isnt connected
            if !networkMonitor.isConnected {
                offlineView()
                    .transition(.opacity)
                    .zIndex(1)  // Ensure offline view is on top
            }
        }
        .animation(.easeInOut, value: networkMonitor.isConnected)
    }
}

//#Preview {
//    MainView()
//        .environmentObject(UserViewModel.shared)
//        .environmentObject(AppViewModel.shared)
//        .environmentObject(NavigationRouter.shared)
//        .environmentObject(NetworkMonitor.shared)
//}

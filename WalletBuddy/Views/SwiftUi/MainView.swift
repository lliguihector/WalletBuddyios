//
//  MainView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//

import SwiftUI

struct MainView: View {
    
    //Global Access
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        
        TabView{
           HomeTabView()
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }
            
            WelcomeView()
                .tabItem{
                    Label("Board", systemImage: "bubble.left.fill")
                }
            
            
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person.fill")
                }
            
            
            
        }
        
    }
}

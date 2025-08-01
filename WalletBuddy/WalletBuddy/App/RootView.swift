//
//  RootView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//
import SwiftUI

struct RootView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    
    var body: some View {

        switch appViewModel.state {
        case .loggedOut:
            LoginOptionsView()
        case .loadingSkeleton:
            SkeletonView()
        case .loggedIn(let user):
            MainView(user: user)
        case.onboarding:
        //Display Onboarding ui
            OnboardingView()
            
        }
    }
      

}

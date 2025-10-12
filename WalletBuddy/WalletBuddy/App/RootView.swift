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
        
        ZStack{
            NavigationStack(path: $navigationRouter.path)
            {
                Group{
                    
                    switch appViewModel.state {
                    case .loggedOut:
                        LoginOptionsView()
                    case .loadingSkeleton:
                        SkeletonView()
                    case .loggedIn:
                        MainView()
                    case.onboarding:
                        OnboardingView()
                    case .loggingIn:
                        LogInVCWrapper()
                        
                        
                    }
                }
                .navigationDestination(for: AppRoute.self){ route in
                    route.view
                    
                }
            }
            //Show Loading spinner when isLoading is true
            if appViewModel.isLoading {
                LoadingSpinnerView()
                    .transition(.opacity)
                    .zIndex(1)
            }
            
        }
        
        .animation(.easeInOut, value: appViewModel.isLoading)
    }
}

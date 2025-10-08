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
//        .task{
//            
//            
//            if isFirstLaunch(){
//                appViewModel.initializeSession()
//                print("initialiing Session ... ")
//            }
//           
//        }
    }
    
    
    
    //MARK: - Helper
    func isFirstLaunch() -> Bool {
        let key = "hasLaunchedBefore"
        let launchedBefore = UserDefaults.standard.bool(forKey: key)
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: key)
            return true
        }
        return false
    }
}

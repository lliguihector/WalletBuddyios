//
//  RootView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//
import SwiftUI
import UIKit

struct RootView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    
    var body: some View {
        
        ZStack{
            NavigationStack(path: $navigationRouter.path){
                
                Group{
                    
                    switch appViewModel.state {
                        
                    case .loggedOut:
                        LoginOptionsView()
                    case .loadingSkeleton:
                        SkeletonView()
                        
                        //Login As Employee
                    case .loggedIn:
                        MainView()
                        
                        //login As Admin
                    case.onboarding:
                        OnboardingView()
                        
                        //If onboarding isnt complete
                    case .onboardingAdmin:
                        ResumeOnboardingView()
                        
                    }
                    }
                    //Router sdestination lives within NavigationStack
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
        .onAppear(){
            print("Root Router:", ObjectIdentifier(navigationRouter))
            print("Root Path Count:", navigationRouter.path.count)
            print("===== ROOT VIEW APPEARED =====")
            print("ROOT VIEW APPEARED")
        }
        .onDisappear(){
            print("===== ROOT VIEW DISAPPEARED =====")
            print("ROOT VIEW DISAPPEARED")
        }
        .onChange(of: appViewModel.state) { old, new in
            print("STATE:", old, "→", new)
            print("PATH COUNT:", navigationRouter.path.count)
        }
    }
}

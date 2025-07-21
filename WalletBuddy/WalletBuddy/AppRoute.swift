//
//  AppRoute.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/21/25.
//
import SwiftUI
enum AppRoute: Hashable{
    
    case onboarding
    case profile
    case settings
    case loginEmail
    
    
@ViewBuilder
    var view: some View{
        switch self{
        case .loginEmail:
            LogInVCWrapper()
        case .onboarding:
            OnboardingView()
        case .profile:
            ProfileView()
        case .settings:
            SettingsView()
        }
    }
    
    
}

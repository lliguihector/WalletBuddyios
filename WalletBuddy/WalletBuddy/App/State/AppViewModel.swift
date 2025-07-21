//
//  AppViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//

import SwiftUI
import FirebaseAuth


@MainActor
class AppViewModel: ObservableObject {
    
    //Shared singleton useful in UIKit/SwiftUI hybrid setups
    static let shared = AppViewModel()
    
    
    
    @Published var state: AppState = .loggedOut
    
    func handleLoginSuccess(user: AppUser) {
        state = .loadingSkeleton
        
        Task {
            
            //Simulate network / data fetch delay
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            //TODO: Fetch additional user profile data here
            
            //Once done, update state to loggedIn 
            state = .loggedIn(user)
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            state = .loggedOut
            NavigationRouter.shared.popToRoot()
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}

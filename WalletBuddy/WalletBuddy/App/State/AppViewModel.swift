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
    
    static let shared = AppViewModel()
    
    //@Publish automaticly emits a change notification
    @Published var state: AppState = .loggedOut

    
   private let authService: AuthenticationService 

    init(authService: AuthenticationService = FirebaseAuthManager.shared){
        self.authService = authService
    }

//Call this on app launch to check for an existing user session
    func initializeSession(){
        if let user = authService.getCurrentUser(){
            handleLoginSuccess(user: user)
        }else{
            state = .loggedOut
        }
    }
    
    
    func handleLoginSuccess(user: AppUser) {
        state = .loadingSkeleton
        
        Task {
            
            //Simulate network / data fetch delay
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            //TODO: Fetch additional user profile data here
            
            //Once done, update state to loggedIn
            
            print("Setting state to logIn")
            state = .loggedIn(user)
        }
    }
    
    func logout() {
        do {
            try authService.logout()
            print("Setting state to logOut")
            state = .loggedOut
            NavigationRouter.shared.popToRoot()
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}

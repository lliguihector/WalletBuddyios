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
    
    static let shared = AppViewModel(authService: FirebaseAuthManager.shared, userRepository: UserRepository.shared)
    
    //@Publish automaticly emits a change notification
    @Published var state: AppState = .loggedOut

    
    
    
    
   private let userRepository: UserRepository
   private let authService: AuthenticationService

    init(authService: AuthenticationService , userRepository: UserRepository){
        self.authService = authService
        self.userRepository = userRepository
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
            
            //Save user to Core Data here
//            userRepository.createUser(from: user)
            
            
            //TODO: Fetch additional user profile data here
            
            //Once done, update state to loggedIn
            
            print("App State: loged In")
            state = .loggedIn(user)
        }
    }
    
    func logout() {
        
        Task{
            SpinnerManager.shared.show()
            
            do {
                try authService.logout()
                await performLogoutCleanup()
                
                print("App State: logedOut")
                state = .loggedOut
              
            } catch {
                print("Logout failed: \(error.localizedDescription)")
            }
            SpinnerManager.shared.hide()
        }
    }
    
    private func performLogoutCleanup() async {
        // 📝 Sync data to backend
        // 🗑️ Clear cached user data
        // 📦 Save any offline changes
        // 📊 Log analytics event like "UserLoggedOut"

        print("🔄 Performing logout cleanup...")

        // Simulate time delay if needed
        try? await Task.sleep(nanoseconds: 500_000_000)

        print("✅ Cleanup complete")
    }

}

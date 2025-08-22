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

    static let shared = AppViewModel(authService: FirebaseAuthManager.shared, apiService:ApiService.shared, userRepository: UserRepository.shared, userViewModel: .shared)
    
    //@Publish automaticly emits a change notification
    @Published var state: AppState = .loggedOut

    
    
    
    
   private let userRepository: UserRepository
   private let authService: AuthenticationService
   private let apiService: ApiService
  private let userViewModel: UserViewModel

    init(authService: AuthenticationService , apiService: ApiService,userRepository: UserRepository, userViewModel: UserViewModel){
        self.authService = authService
        self.userRepository = userRepository
        self.apiService = apiService
        self.userViewModel = userViewModel
    }
    
    

//Call this on app launch to check for an existing user session
    func initializeSession(){


        if authService.isUaserLoggedIn(){
            
            //Fetch local user model to check if profile is complete

            
//            print("Initializing Function Called")
//            let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedProfile")
//            
//           if !hasCompletedOnboarding{
//                state = .onboarding
//               print("\(String(describing: userViewModel.appUser)) ?? did not load")
//               
//            }else{
//                handleLoginSuccess()
//                
//
//            }
// 
            handleLoginSuccess()
        }else{
            state = .loggedOut
        }
        
        print("Initializing App Session")
    }
    
    
    func handleLoginSuccess() {
        state = .loadingSkeleton
        
        Task {
            
            //Simulate network / data fetch delay
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
            //1. Get Firebase ID token
            guard let idToken = try await authService.getIDToken(forceRefresh: false)else{
                print("❌ Faild to get Firebase ID Token")
               logout()
                return
            }
            //2. send token to my backend
            
            
            if let user = await apiService.verifyUser(withToken: idToken){
                //3. set my model via userViewModel
                userViewModel.appUser = user
                
                switch user.onboardingStep {
                case .enterName:
                    state = .onboarding
                case .complete:
                    state = .loggedIn
                    
                }
                
            }else{
             logout()
            }


            //TODO: Fetch additional user profile data here graphq
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
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    NavigationRouter.shared.popToRoot()
                }
                
                
              
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

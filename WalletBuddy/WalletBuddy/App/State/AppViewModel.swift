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
    
    //SYNC With Backend Method
    func syncAppUser(forceRefresh: Bool = false) async{
        
        do{
            guard let idToken = try await authService.getIDToken(forceRefresh: forceRefresh) else{
                print("❌ Faild to get Firebase ID Token")
            logout()
                return
            }
            
            if let user = await apiService.verifyUser(withToken: idToken){

                userViewModel.appUser = user // <--- sets AppUser Globally
                print("✅ Synced latest AppUser from backend")
            }else{
                print("❌ Failed to fetch user from backend")
                logout()
            }
        }catch{
            print("❌ syncAppUser error: \(error.localizedDescription)")
        }
    }
    

//Call this on app launch to check for an existing user session
    func initializeSession(){


        if authService.isUaserLoggedIn(){
            
            Task{
               await handleLoginSuccess()
            }
           
        }else{
            state = .loggedOut
        }
        
        print("Initializing App Session")
    }
    
    
    func handleLoginSuccess() async{

        state = .loadingSkeleton
 
            try? await Task.sleep(nanoseconds: 1_000_000_000)  //Simulate network data fetch delay
            
                await syncAppUser(forceRefresh: true)
             
                switch userViewModel.appUser?.onboardingStep {
                case .enterName:
                    state = .onboarding
                case .complete:
                    state = .loggedIn
                default:
                    state = .loggedOut
                }
                
            //TODO: Fetch additional user profile data here graphq
    
    }
    
    func logout() {
        SpinnerManager.shared.show()
        Task{
      
            
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

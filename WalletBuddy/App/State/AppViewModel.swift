//
//  AppViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//

import SwiftUI
import FirebaseAuth

struct AppAlert: Identifiable{
    let id = UUID()
    let message: String
}
@MainActor
class AppViewModel: ObservableObject {

    static let shared = AppViewModel(authService: FirebaseAuthManager.shared, apiService:ApiService.shared, userRepository: UserRepository.shared, deviceManager: DeviceManager.shared, navigationRouter: NavigationRouter.shared )
    
    //@Publish automaticly emits a change notification
    @Published var state: AppState = .loggedOut
    @Published var activeAlert: AppAlert? = nil
    @Published var isLoading: Bool = false

    
    let userSession = UserSession()
    //MARK: -- Dependencies
   private let userRepository: UserRepository
   private let authService: AuthenticationService
   private let apiService: ApiService
   private let deviceManager: DeviceManager
    private let navigationRouter: NavigationRouter

    init(authService: AuthenticationService , apiService: ApiService,userRepository: UserRepository, deviceManager: DeviceManager, navigationRouter: NavigationRouter){
        self.authService = authService
        self.userRepository = userRepository
        self.apiService = apiService
        self.deviceManager = deviceManager
        self.navigationRouter = navigationRouter
    }
    
    //SYNC With Backend Method
    func syncAppUser(forceRefresh: Bool = false) async{
 
        
        //Simulate netork delay
//        try? await Task.sleep(nanoseconds: 1500_000_000)
        guard UIApplication.shared.applicationState == .active else {
            
            print("App in not active - skipping sync")
            
            return
        }
        
        
        do{
            guard let idToken = try await authService.getIDToken(forceRefresh: forceRefresh) else{
                print("❌ Faild to get Firebase ID Token")
            logout()
                return
            }
            
            if let user = await apiService.verifyUser(withToken: idToken){

                
                
                userSession.setUser(user)
     
                print("✅ Synced latest AppUser from backend")
            }else{
                print("❌ Failed to fetch user from backend")
                activeAlert = AppAlert(message: "We couldn’t complete your sign-in. Please try again.")
    
                logout()
            }
        }catch{
            print("❌ syncAppUser error: \(error.localizedDescription)")
            activeAlert = AppAlert(message: "Something went wrong. Please check your connection and try again.")
        }
    }
    

//Call this on app launch to check for an existing user session
    func initializeSession()async{

      print("initializing Session started")
        
        isLoading = true
        try? await Task.sleep(nanoseconds: 300_000_000)
        isLoading = false
        
        
        
        print("Firebase logged in:", authService.isUserLoggedIn())
        
        if authService.isUserLoggedIn(){
            
            
            print("➡️ Existing user found")
            
            //Show skeleton immediately while we verify user
//            state = .loadingSkeleton
 
            
          
              await handleLoginSuccess()
          

           
        }else{
            print("➡️ No user")
            state = .loggedOut
        }
        
        print("Initializing App Session user not loged in yet")
    }
    
    
    
    
    
    
    

    func handleLoginSuccess(forceRefresh: Bool = false) async{

                await syncAppUser(forceRefresh: forceRefresh)
      
        
        //Small delay for smoother transition
          
                switch userSession.user?.onboardingStep {
                case .enterName:
                    state = .onboarding
                case .complete:
                    
                  
                    state = .loggedIn
                    
                    
                    //Clears the Navigation stack Stack
    
                    navigationRouter.path = NavigationPath()
                    
                    
                    DeviceManager.shared.requestNotificationPermissionAndRegister()
               
                default:
                    state = .loggedOut
                }
                
            //TODO: Fetch additional user profile data here graphq
    
    }
    
    func logout() {
        SpinnerManager.shared.show()
        Task{
            defer{
                SpinnerManager.shared.hide()
            }
            
            do {
                try authService.logout()
                await performLogoutCleanup()
                
               
              
                
                navigationRouter.path = NavigationPath()
            
                userSession.clear()

                
                state = .loggedOut

                print("App State: logedOut")
            } catch {
                print("Logout failed: \(error.localizedDescription)")
                activeAlert = AppAlert(message: "Failed to log out. Please try again.")
            }
 
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

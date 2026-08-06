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
    @Published var state: AppState = .launching
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
    
    //MARK: - SYNC
    func syncAppUser(forceRefresh: Bool = false) async{
//        guard UIApplication.shared.applicationState == .active else {
//            print("App in not active - skipping sync")
//            return
//        }
        
        do{
            guard let idToken = try await authService.getIDToken(forceRefresh: forceRefresh) else{
                print("❌ Faild to get Firebase ID Token")
            logout()
                return
            }
            if let user = await apiService.verifyUser(withToken: idToken){
                userSession.setUser(user)
                print("User was synced")
            }else{
     
                activeAlert = AppAlert(message: "We couldn’t complete your sign-in. Please try again.")
                logout()
                return
            }
        }catch{
            activeAlert = AppAlert(message: "Something went wrong. Please check your connection and try again.")
        }
    }
    

//MARK: - On App launch check for user session
    func initializeSession()async{

     
        // Keep splash visible for 1 second
          try? await Task.sleep(for: .seconds(1))
        if authService.isUserLoggedIn(){
            
              await handleLoginSuccess()

        }else{
      
            state = .loggedOut
        }
    
        print("Final State:", state)
    }
    
    
    
    //MARK: - Navigate user based on onboardingState
    func handleLoginSuccess(forceRefresh: Bool = false) async {
        await syncAppUser(forceRefresh: forceRefresh)

        guard let user = userSession.user else {
            state = .loggedOut
            return
        }


        switch user.onboardingStatus {
        case .completed:
            state = .loggedIn

        default:

            state = .onboarding
        }
    }
    
    
    // MARK: - Handle User Login
    func userDidLogin(forceRefresh: Bool = true) async {
        
        print("🔐 User login detected. Syncing app user...")
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        await handleLoginSuccess(forceRefresh: forceRefresh)
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

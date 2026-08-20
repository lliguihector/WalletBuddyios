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

        
        do{
            guard let idToken = try await authService.getIDToken(forceRefresh: forceRefresh) else{
                print("❌ Faild to get Firebase ID Token")
            logout()
                return
            }
            
            
            print("Authenticating user...\(idToken)")
            let result = await apiService.verifyUser(withToken: idToken)
   
            
            switch result {

                    // MARK: - Success

                    case .success(let user):

                        userSession.setUser(user)

                        print("✅ User was synced")


                    // MARK: - Failure

                    case .failure(let error):

                        switch error {

                        // Actual authentication failure
                        case .unauthorized:

                            print(
                                "❌ Session is no longer authorized"
                            )

                            activeAlert = AppAlert(
                                message:
                                    "Your session has expired. Please sign in again."
                            )

                            logout()


                        // Network problem
                        case .networkError(let error):

                            print(
                                "⚠️ Network error - keeping user logged in:",
                                error.localizedDescription
                            )

                            activeAlert = AppAlert(
                                message:
                                    "You're offline. Some information may not be up to date."
                            )

                            // IMPORTANT:
                            // Do NOT call logout()


                        // Server is having problems
                        case .serverError(
                            let statusCode,
                            let message
                        ):

                            print(
                                "⚠️ Server error:",
                                statusCode,
                                message ?? ""
                            )

                            activeAlert = AppAlert(
                                message:
                                    "We couldn't refresh your account right now. Please try again later."
                            )

                            // Do NOT logout()


                        case .decodingError:

                            print(
                                "❌ Failed to decode user"
                            )

                            activeAlert = AppAlert(
                                message:
                                    "We couldn't load your account information."
                            )

                            // Don't logout because this
                            // doesn't mean authentication expired.


                        case .invalidURL,
                             .encodingError:

                            print(
                                "❌ Internal API configuration error"
                            )
                        }
                    }


        } catch {
            
            print(
                "❌ Firebase token error:",
                error
            )
            
            
            
            activeAlert = AppAlert(message: "We couldn't refresh your session. Please tcheck your connection.")
        }
    }
    

//MARK: - On App launch check for user session
    func initializeSession()async{

     
        // Keep splash visible for 1 second
//          try? await Task.sleep(for: .seconds(1))
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

//
//  DependencyContainer.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/23/25.
//

final class DependencyContainer{
    let authService: AuthenticationService
    let userRepository: UserRepository
   
    
    
    init(){
       
        
        //Use your shared or new instances here
        self.authService = FirebaseAuthManager.shared
        self.userRepository = UserRepository()
    }
    
  
    
    
    @MainActor
    func makeLoginViewModel() -> LoginViewModel{
     return LoginViewModel(authService: authService, userRepository: userRepository)
    }
    
    
    
    
}

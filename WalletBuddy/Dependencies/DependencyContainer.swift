//
//  DependencyContainer.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/23/25.
//

final class DependencyContainer{
    let authService: AuthenticationService

   
    
    
    init(){
       
        
        //Use your shared or new instances here
        self.authService = FirebaseAuthManager.shared
 
    }
    
  
    
    
    @MainActor
    func makeLoginViewModel() -> LoginViewModel{
     return LoginViewModel(authService: authService)
    }
    
    
    
    
}

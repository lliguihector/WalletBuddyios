//
//  LoginViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/15/25.
//

import Foundation
import FirebaseAuth

//@MainActor runs the code in the main thread no need for DispatchQue.main.async
@MainActor
final class LoginViewModel {
    
    private let authService: AuthenticationService

    //Inject auth service
    init(authService: AuthenticationService = FirebaseAuthManager.shared){
        self.authService = authService
    }
    
    func login(email: String?, password: String?) async -> LoginResult{
        

        switch LoginValidator.validate(email: email, password: password){
        
    case .failure(let message):
        return .failure(message)
        
    case .success:
        do{
            
            try await authService.login(email: email!, password: password!)
            
            
            AppViewModel.shared.handleLoginSuccess()
            
            
            
            return .success
        }catch{
            return .failure(error.localizedDescription)
        }
  
    }
     
}
}
enum LoginResult{
    case success
    case failure(String)
}

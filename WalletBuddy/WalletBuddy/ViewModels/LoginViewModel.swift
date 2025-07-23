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
    private let userRepository: UserRepository
    //Inject auth service
    init(authService: AuthenticationService, userRepository: UserRepository){
        self.authService = authService
        self.userRepository = userRepository
    }
    
    
    
    func login(email: String?, password: String?) async -> LoginResult{
        
        switch LoginValidator.validate(email: email, password: password){
        
    case .failure(let message):
        return .failure(message)
        
    case .success:
        do{
            
            let user = try await authService.login(email: email!, password: password!)
            
            //Save to Core Data
          userRepository.createUser(from: user)
            
            return .success(user)
        }catch{
            return .failure(error.localizedDescription)
        }
  
    }
     
}
}
enum LoginResult{
    case success(AppUser)
    case failure(String)
}

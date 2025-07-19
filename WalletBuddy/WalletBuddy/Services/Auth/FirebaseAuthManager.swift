//
//  FirebaseAuthManager.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/19/25.
//
import FirebaseAuth


final class FirebaseAuthManager: AuthenticationService{
    
    
    func login(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        
        return result.user.uid
        
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func getUserId() -> String? {
        return Auth.auth().currentUser?.uid
        
    }
    
    func getIDToken(forceRefresh: Bool) async throws -> String? {
        return try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: forceRefresh).token
    }
    
    
    
    
    
}

//
//  FirebaseAuthManager.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/19/25.
//
import FirebaseAuth

final class FirebaseAuthManager: AuthenticationService{
    
    
    static let shared = FirebaseAuthManager()
    
    private init(){}
    
    
    func login(email: String, password: String) async throws  {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func isUaserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
 
    
    func getIDToken(forceRefresh: Bool) async throws -> String? {
        return try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: forceRefresh).token
    }
    
    
 
    
    
    
}

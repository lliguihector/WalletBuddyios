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
    
    
    func login(email: String, password: String) async throws -> AppUser {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        
        let userID = result.user.uid
        let email = result.user.email ?? ""

        return AppUser(id: userID, email: email)    
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
 
    func getCurrentUser() -> AppUser?{

        guard let user = Auth.auth().currentUser
        else{
            return nil
        }

        return AppUser(id: user.uid, email: user.email ?? "")
    }
    
    func getIDToken(forceRefresh: Bool) async throws -> String? {
        return try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: forceRefresh).token
    }
    
    
 
    
    
    
}

//
//  FireBaseService.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/15/25.
//

import FirebaseAuth

class AuthManager {
    
    //Makes AuthManager a singleton class 
    static let shared = AuthManager()
    private init() {}

    func login(email: String, password: String) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = result?.user {
                    continuation.resume(returning: user)
                }
            }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
    }

    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    func getCurrentUserID() -> String? {
        return Auth.auth().currentUser?.uid
    }

    func getIDToken(forceRefresh: Bool = false) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().currentUser?.getIDTokenForcingRefresh(forceRefresh) { token, error in
                if let token = token {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "TokenError", code: -1))
                }
            }
        }
    }
}

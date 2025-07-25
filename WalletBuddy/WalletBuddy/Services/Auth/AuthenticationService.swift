//
//  AuthenticationService.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/19/25.
//
import Foundation

protocol AuthenticationService {
    
    func login(email: String, password: String)async throws -> AppUser
    
    
    func logout() throws
    
    // func isUserLoggedIn() -> Bool
    // func getUserId() -> String?
    
    func getCurrentUser() -> AppUser?
    
    func getIDToken(forceRefresh: Bool)async throws -> String?
    
 
    
}

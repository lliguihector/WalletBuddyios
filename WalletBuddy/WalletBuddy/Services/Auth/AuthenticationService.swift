//
//  AuthenticationService.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/19/25.
//
import Foundation

protocol AuthenticationService {
    
    func login(email: String, password: String)async throws
    
    
    func logout() throws

    func isUaserLoggedIn() -> Bool
    
    func getIDToken(forceRefresh: Bool)async throws -> String?
    
 
    
}

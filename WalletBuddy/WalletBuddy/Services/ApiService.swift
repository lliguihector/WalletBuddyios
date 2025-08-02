//
//  APIService.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/28/25.
//
import Foundation

final class ApiService {
            
    static let shared = ApiService()
    
    private init() {}
    
    
    
    func verifyUser(withToken token: String) async -> Bool {
        print("this is the firebase Token: \(token)")
        
        guard let url = URL(string: "http://localhost:3000/user/check-or-create") else {
            print("Invalid URL")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Server error or unexpected response")
                return false
            }
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let isNewUser = json?["isNewUser"] as? Bool ?? false
            
            return isNewUser
            
        } catch {
            print("Error verifying user: \(error)")
            return false
        }
    }

    
    
    func updateUserData(token: String,userData: AppUser)
    {
        
        
        
    }
    
}

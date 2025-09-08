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
    
    
    
    func verifyUser(withToken token: String) async -> AppUser? {

        print("Firebase Token: -> \(token)")
        
        guard let url = URL(string: "http://localhost:3000/user/check-or-create") else {
            print("❌ Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                return nil
            }
            
            switch httpResponse.statusCode {
            case 200:
                do {
                    
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON -> \(json) ")
                    let user = try JSONDecoder().decode(AppUser.self, from: data)
                    return user
                } catch {
                    print("❌ Failed to decode AppUser: \(error)")
                    return nil
                }
            case 401:
                print("⚠️ Unauthorized: Invalid or expired token")
            case 500...599:
                print("❌ Server error: \(httpResponse.statusCode)")
            default:
                // Optional: Try to print server error message
                if let errorMessage = String(data: data, encoding: .utf8) {
                    print("⚠️ Server responded with status \(httpResponse.statusCode): \(errorMessage)")
                } else {
                    print("⚠️ Unexpected status code: \(httpResponse.statusCode)")
                }
            }
            
        } catch {
            print("❌ Network or decoding error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    
    
    func sendLocationToDB(withToken token: String, latitude: Double, longitude: Double) async ->Bool{
        
        
        
      return true
    
    }
    
    
  //Onboarding function
    //Veryfy user with token 
    //Send onboarding step data
    //FirstName and LastName
    //updateOnboarding step to Complete
    
    
    //Wherever called on Success call apppViewModel logginSuccess() to SYNC model and UI
    
}

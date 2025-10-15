//
//  APIService.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/28/25.
//
import Foundation
import UIKit

//Decode backend error response 
struct ErrorResponse: Decodable{
    let error: String
}
//Enumeration for checkin
enum LocationUpdateError: Error{
    case invalidURL
    case serializationError
    case decodingError
    case networkError(Error)
    case serverError(statusCode: Int, message: String?)
}



final class ApiService {
    
    static let shared = ApiService()
    
    private init() {}
    
    
    
    func verifyUser(withToken token: String) async -> AppUser? {

        
        //New parameters neeeded DeviceID
        
        
        
        print("Firebase Token: -> \(token)")
        
        guard let url = URL(string: "https://determitapi-709b9bad1b56.herokuapp.com/user/check-or-create") else {
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
    
    
    //Sends the users current location to check in user
    func sendLocationToDB(withToken token: String, latitude: Double, longitude: Double, deviceID: String) async -> Result<CheckIn, LocationUpdateError>{
        
        guard let url = URL(string: "https://determitapi-709b9bad1b56.herokuapp.com/checkin/checkin")else{
            return .failure(.invalidURL)
        }
        //http://localhost:3000/checkin/checkin
        //"https://determitapi-709b9bad1b56.herokuapp.com/checkin/checkin"
        let body: [String: Any] = [
            "lat": latitude,
            "lng": longitude,
            "deviceID": deviceID
        ]
        
           print("From Application location: \(latitude) \(longitude)")
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else{
            return .failure(.serializationError)
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody
      
        do{
            let(data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else{
                return .failure(.serverError(statusCode: -1, message: "Invalid response"))
            }
            
            guard (200...299).contains(httpResponse.statusCode)else{
                
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self,from: data){
                    return .failure(.serverError(statusCode: httpResponse.statusCode, message: errorResponse.error))
                }else{
                    let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                    return .failure(.serverError(statusCode: httpResponse.statusCode, message: message))
                }
              
            }
            
            
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .base64
            let decodedResponse = try decoder.decode(CheckInResponse.self, from: data)
            return .success(decodedResponse.checkIn)
            
            
            
        }catch let decodingError as DecodingError{
            
            print("Decoding error: \(decodingError)")
            return .failure(.decodingError)
        }catch{
            print("Network error: \(error)")
            return .failure(.networkError(error))
        }
  
    }
    
    
    //MARK: -- Register Device with backend
   
    
    
    
    
    func sendDeviceInfoToAPI(device: Device, completion: @escaping (Result<Void, Error>) -> Void) {
        
        print("Data sent to API...")
    }
    
    
    
  //Onboarding function
    //Veryfy user with token
    //Send onboarding step data
    //FirstName and LastName
    //updateOnboarding step to Complete
    
    
    //Wherever called on Success call apppViewModel logginSuccess() to SYNC model and UI
    
}

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
enum APIError: Error{
    case invalidURL
    case serializationError
    case decodingError
    case networkError(Error)
    case serverError(statusCode: Int, message: String?)
}

enum CheckoutError: Error {
    case invalidURL
    case networkError(Error)
    case alreadyCheckedOut
    case noCheckinFound
    case serverError(message: String?)
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
    func sendLocationToDB(withToken token: String, latitude: Double, longitude: Double, deviceID: String) async -> Result<CheckInResponse, APIError>{
        
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
            return .success(decodedResponse)
            
            
            
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
    
    
    
    //MARK: - Fetch last checkin
    func fetchLastCheckin(token: String) async -> Result<CheckIn, APIError> {
        
        // 1️⃣ URL
        guard let url = URL(string: "https://determitapi-709b9bad1b56.herokuapp.com/checkin/lastCheckin") else {
            print("❌ Invalid URL")
            return .failure(.invalidURL)
        }
        
        print("➡️ Fetching last check-in from URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("📝 Request headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            // 2️⃣ Perform network request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // 3️⃣ Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response object")
                return .failure(.serverError(statusCode: -1, message: "Invalid response"))
            }
            
            print("📶 HTTP status code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ Server returned error status: \(httpResponse.statusCode)")
                
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    print("❌ Server error message: \(errorResponse.error)")
                    return .failure(.serverError(statusCode: httpResponse.statusCode, message: errorResponse.error))
                } else {
                    let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                    print("❌ Server returned: \(message)")
                    return .failure(.serverError(statusCode: httpResponse.statusCode, message: message))
                }
            }
            
            // 4️⃣ Decode JSON into CheckIn
            let decoder = JSONDecoder()
            
            // Custom DateFormatter to handle milliseconds and 'Z'
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            do {
                let checkin = try decoder.decode(CheckIn.self, from: data)
                print("✅ Decoded CheckIn: \(checkin)")
                return .success(checkin)
            } catch {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("❌ Decoding error. Raw JSON: \(jsonString)")
                }
                print("❌ Decoding error: \(error.localizedDescription)")
                return .failure(.decodingError)
            }
            
        } catch {
            print("❌ Network error: \(error.localizedDescription)")
            return .failure(.networkError(error))
        }
    }
    
    
    
    //CHECKOUT
    func checkout(firebaseIDToken: String) async -> Result<String, APIError> {
        guard let url = URL(string: "https://determitapi-709b9bad1b56.herokuapp.com/checkin/checkout") else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(firebaseIDToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.serverError(statusCode: 0, message: "Invalid response from server."))
            }

            // Try to parse server message from response
            var message: String? = nil
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                message = json["message"] as? String
            }

            switch httpResponse.statusCode {
            case 200:
                return .success(message ?? "Successfully checked out")
            case 400, 404:
                return .failure(.serverError(statusCode: httpResponse.statusCode, message: message))
            default:
                return .failure(.serverError(statusCode: httpResponse.statusCode, message: message))
            }

        } catch {
            return .failure(.networkError(error))
        }
    }
    
    //MARK: - GET CURRENT USERS CHECKED IN BELONGING WITHIN USER ORGANIZATION
    func fetchCheckedInUsers(token: String) async -> Result<[CheckedInUser], APIError> {
        
        // 1️⃣ URL
        guard let url = URL(string: "https://determitapi-709b9bad1b56.herokuapp.com/checkin/checkedin") else {
            print("❌ Invalid URL")
            return .failure(.invalidURL)
        }
        
        print("➡️ Fetching checked-in users from URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("📝 Request headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            // 2️⃣ Perform network request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // 3️⃣ Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response object")
                return .failure(.serverError(statusCode: -1, message: "Invalid response"))
            }
            
            print("📶 HTTP status code: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("❌ Server returned error status: \(httpResponse.statusCode)")
                
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    print("❌ Server error message: \(errorResponse.error)")
                    return .failure(.serverError(statusCode: httpResponse.statusCode, message: errorResponse.error))
                } else {
                    let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                    print("❌ Server returned: \(message)")
                    return .failure(.serverError(statusCode: httpResponse.statusCode, message: message))
                }
            }
            
            // 4️⃣ Decode JSON into [CheckedInUser]
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode([CheckedInUser].self, from: data)
                print("✅ Decoded CheckedInUsers: \(users)")
                return .success(users)
            } catch {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("❌ Decoding error. Raw JSON: \(jsonString)")
                }
                print("❌ Decoding error: \(error.localizedDescription)")
                return .failure(.decodingError)
            }
            
        } catch {
            print("❌ Network error: \(error.localizedDescription)")
            return .failure(.networkError(error))
        }
    }

 




}

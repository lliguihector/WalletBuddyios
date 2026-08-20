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
    case encodingError
    case decodingError
    case networkError(Error)
    case unauthorized
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
    
    //MARK: LOGIN/LOGOUT/STATE
    func verifyUser(withToken token: String) async -> Result<AppUser, APIError> {

        
        
        //URL
        guard let url = URL(string: Constants.checkInOrCreateEndPoint) else {
            print("❌ Invalid URL")
            return .failure(.invalidURL)
        }


        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")

        request.setValue( "Bearer \(token)",forHTTPHeaderField: "Authorization")


        do {

            let (data, response) = try await URLSession.shared.data(
                for: request
            )


            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                return .failure(.serverError(statusCode: -1,message: "Invalid server response."))
            }


            switch httpResponse.statusCode {

            // MARK: - Success

            case 200...299:

                do {

                    let json = try JSONSerialization.jsonObject(
                        with: data,
                        options: []
                    )

                    print("JSON -> \(json)")


                    let user = try JSONDecoder().decode(
                        AppUser.self,
                        from: data
                    )

                    return .success(user)

                } catch {

                    print(
                        "❌ Failed to decode AppUser:",
                        error
                    )

                    return .failure(.decodingError)
                }


            // MARK: - Unauthorized

            case 401:

                print(
                    "⚠️ Unauthorized: Invalid or expired token"
                )

                return .failure(.unauthorized)


            // MARK: - Server Error

            case 500...599:

                let message = String(
                    data: data,
                    encoding: .utf8
                )

                print(
                    "❌ Server error:",
                    httpResponse.statusCode
                )

                return .failure(
                    .serverError(
                        statusCode: httpResponse.statusCode,
                        message: message
                    )
                )


            // MARK: - Other Status Codes

            default:

                let message = String(
                    data: data,
                    encoding: .utf8
                )

                print(
                    "⚠️ Server responded with status:",
                    httpResponse.statusCode
                )

                return .failure(
                    .serverError(
                        statusCode: httpResponse.statusCode,
                        message: message
                    )
                )
            }


        } catch {

            print(
                "❌ Network error:",
                error.localizedDescription
            )

            return .failure(
                .networkError(error)
            )
        }
    }
    
    //Admin registration + email verification email sent NOTE: move to AuthService.swift
    func registerAdmin(firstName: String,lastName: String,email: String,password: String) async -> Result<RegisterAdminResponse, APIError> {

        // URL
        guard let url = URL(string: Constants.registerAdmin) else {
            return .failure(.invalidURL)
        }

        // Request body
        let body = RegisterAdminRequest(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password
        )

        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Encode JSON
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return .failure(.encodingError)
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.serverError(statusCode: -1, message: "Invalid response"))
            }

            switch httpResponse.statusCode {

            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(
                        RegisterAdminResponse.self,
                        from: data
                    )
                    return .success(decodedResponse)
                } catch {
                    return .failure(.decodingError)
                }

            default:
                let errorResponse = try? JSONDecoder().decode(
                    RegisterAdminResponse.self,
                    from: data
                )

                return .failure(
                    .serverError(
                        statusCode: httpResponse.statusCode,
                        message: errorResponse?.message
                    )
                )
            }

        } catch {
            return .failure(.networkError(error))
        }
    }
           
 
    // Email Verification Check
    func checkEmailVerification(withToken token: String) async -> Result<EmailVerificationResponse, APIError> {

        guard let url = URL(string: Constants.verifyEmailEndPoint) else {
            print("❌ Invalid URL: \(Constants.verifyEmailEndPoint)")
            return .failure(.invalidURL)
        }

        print("🌐 API Request URL: \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


        print("📤 Sending Request:")
        print("Method: \(request.httpMethod ?? "")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Token length: \(token.count)")


        do {
            let (data, response) = try await URLSession.shared.data(for: request)


            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP Response")
                return .failure(.serverError(statusCode: -1, message: "Invalid response"))
            }


            print("📥 Response Status Code: \(httpResponse.statusCode)")


            // Print raw server response
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Raw Response:")
                print(responseString)
            } else {
                print("⚠️ Could not convert response data to string")
            }


            guard (200...299).contains(httpResponse.statusCode) else {

                print("❌ Server returned error status code: \(httpResponse.statusCode)")


                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {

                    print("🔥 Server Error Message: \(errorResponse.error)")

                    return .failure(
                        .serverError(
                            statusCode: httpResponse.statusCode,
                            message: errorResponse.error
                        )
                    )

                } else {

                    let message = String(data: data, encoding: .utf8) ?? "Unknown error"

                    print("🔥 Unknown Server Error:")
                    print(message)

                    return .failure(
                        .serverError(
                            statusCode: httpResponse.statusCode,
                            message: message
                        )
                    )
                }
            }


            do {
                let decodedResponse = try JSONDecoder().decode(
                    EmailVerificationResponse.self,
                    from: data
                )

                print("✅ Email verification response decoded successfully:")
                print(decodedResponse)

                return .success(decodedResponse)

            } catch {

                print("❌ JSON Decoding Failed")
                print("Error: \(error)")

                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response that failed decoding:")
                    print(responseString)
                }

                return .failure(.decodingError)
            }


        } catch {

            print("❌ Network Request Failed")
            print("Error: \(error.localizedDescription)")

            return .failure(.networkError(error))
        }
    }
        
    //Resend email Verification Link
    func resendEmailVerification(token: String) async -> Result<APIResponse, APIError>{
        
        guard let url = URL(string: Constants.resendEmailVerificationEndPoint) else {
              return .failure(.invalidURL)
          }

          var request = URLRequest(url: url)
          request.httpMethod = "POST"

          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

          do {

              let (data, response) = try await URLSession.shared.data(for: request)

              guard let httpResponse = response as? HTTPURLResponse else {
                  return .failure(
                      .serverError(
                          statusCode: -1,
                          message: "Invalid server response."
                      )
                  )
              }

              let decoder = JSONDecoder()

              switch httpResponse.statusCode {

              case 200...299:

                  let apiResponse = try decoder.decode(APIResponse.self, from: data)
                  return .success(apiResponse)

              default:

                  let errorResponse = try? decoder.decode(APIResponse.self, from: data)

                  return .failure(
                      .serverError(
                          statusCode: httpResponse.statusCode,
                          message: errorResponse?.message
                      )
                  )
              }

          } catch let decodingError as DecodingError {

              print("Decoding Error:", decodingError)
              return .failure(.decodingError)

          } catch {

              print("Network Error:", error.localizedDescription)
              return .failure(.networkError(error))
          }
        
        
    }
    
    // MARK: - Create Organization
    func createOrganization(
        token: String,
        name: String,
        industry: String,
        email: String,
        phone: String?,
        website: String?
    ) async -> Result<CreateOrganizationResponse, APIError> {

        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("🏢 CREATE ORGANIZATION REQUEST STARTED")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

        // MARK: - URL
        guard let url = URL(
            string: Constants.createOrganizationEndPoint
        ) else {

            print("❌ Invalid create organization URL")
            print("❌ URL String:", Constants.createOrganizationEndPoint)

            return .failure(.invalidURL)
        }

        print("🌐 URL:", url.absoluteString)


        // MARK: - Request
        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        print("📡 HTTP Method: POST")
        print("🔐 Authorization header added")
        // IMPORTANT: Do NOT print the actual token.


        // MARK: - Request Body
        let body = CreateOrganizationRequest(
            name: name,
            industry: industry,
            email: email,
            phone: phone,
            website: website
        )

        print("📦 Organization Request:")
        print("   Name:", name)
        print("   Industry:", industry)
        print("   Email:", email)
        print("   Phone:", phone ?? "nil")
        print("   Website:", website ?? "nil")


        // MARK: - Encode Body
        do {

            request.httpBody = try JSONEncoder().encode(body)

            print("✅ Request body encoded successfully")

            // Print actual JSON being sent
            if let httpBody = request.httpBody,
               let jsonString = String(data: httpBody, encoding: .utf8) {

                print("📤 JSON SENT TO SERVER:")
                print(jsonString)
            }

        } catch {

            print("❌ ORGANIZATION ENCODING ERROR")
            print("❌ Error:", error)
            print("❌ Description:", error.localizedDescription)

            return .failure(.encodingError)
        }


        // MARK: - API Request
        do {

            print("🚀 Sending create organization request...")

            let (data, response) = try await URLSession.shared.data(
                for: request
            )

            print("📥 Server response received")


            // MARK: - Validate HTTP Response
            guard let httpResponse = response as? HTTPURLResponse else {

                print("❌ INVALID HTTP RESPONSE")
                print("❌ Response:", response)

                return .failure(
                    .serverError(
                        statusCode: -1,
                        message: "Invalid server response."
                    )
                )
            }


            // MARK: - Debug HTTP Response

            print("📶 HTTP STATUS CODE:", httpResponse.statusCode)

            // Print response body
            if let rawResponse = String(data: data, encoding: .utf8) {

                print("📥 RAW SERVER RESPONSE:")
                print(rawResponse)

            } else {

                print("⚠️ Could not convert response data to String")
                print("📦 Response data size:", data.count, "bytes")
            }


            let decoder = JSONDecoder()


            // MARK: - Status Codes
            switch httpResponse.statusCode {

            // MARK: Success
            case 200...299:

                print("✅ CREATE ORGANIZATION REQUEST SUCCESSFUL")

                do {

                    let decodedResponse = try decoder.decode(
                        CreateOrganizationResponse.self,
                        from: data
                    )

                    print("✅ CreateOrganizationResponse decoded successfully")
                    print("🏢 Organization response:", decodedResponse)

                    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
                    print("🏁 CREATE ORGANIZATION COMPLETED")
                    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

                    return .success(decodedResponse)

                } catch {

                    print("❌ ORGANIZATION DECODING ERROR")
                    print("❌ Error:", error)
                    print("❌ Description:", error.localizedDescription)

                    if let decodingError = error as? DecodingError {

                        switch decodingError {

                        case .keyNotFound(let key, let context):
                            print("❌ Missing key:", key.stringValue)
                            print("❌ Context:", context.debugDescription)

                        case .typeMismatch(let type, let context):
                            print("❌ Type mismatch:", type)
                            print("❌ Context:", context.debugDescription)

                        case .valueNotFound(let type, let context):
                            print("❌ Value not found:", type)
                            print("❌ Context:", context.debugDescription)

                        case .dataCorrupted(let context):
                            print("❌ Data corrupted")
                            print("❌ Context:", context.debugDescription)

                        @unknown default:
                            print("❌ Unknown decoding error")
                        }
                    }

                    return .failure(.decodingError)
                }


            // MARK: Unauthorized
            case 401:

                print("🔐 UNAUTHORIZED")
                print("❌ Server returned HTTP 401")
                print("❌ Firebase token may be invalid or expired")

                return .failure(.unauthorized)


            // MARK: Backend Errors
            default:

                print("❌ SERVER ERROR")
                print("❌ Status Code:", httpResponse.statusCode)

                let errorResponse = try? decoder.decode(
                    APIErrorResponse.self,
                    from: data
                )

                if let errorResponse {

                    print("❌ Backend error message:", errorResponse.message)

                } else {

                    print("⚠️ Could not decode APIErrorResponse")

                    if let rawResponse = String(data: data, encoding: .utf8) {
                        print("❌ Raw backend response:", rawResponse)
                    }
                }

                return .failure(
                    .serverError(
                        statusCode: httpResponse.statusCode,
                        message: errorResponse?.message
                    )
                )
            }

        } catch {

            print("❌ NETWORK ERROR")
            print("❌ Error:", error)
            print("❌ Description:", error.localizedDescription)

            return .failure(
                .networkError(error)
            )
        }
    }
    //MARK: -- ADMIN
    //MARK: -- EMPLOYEE
    //CHECKIN
    func sendLocationToDB(withToken token: String, latitude: Double, longitude: Double, device: DeviceCheckInInfo) async -> Result<CheckInResponse, APIError>{
        
        guard let url = URL(string:Constants.checkInEndPoint)else{
            return .failure(.invalidURL)
        }

        let body = CheckInRequest(
            lat: latitude,
            lng: longitude,
            device: device
        )
        
        let httpBody: Data
        
        do{
            httpBody = try JSONEncoder().encode(body)
        }catch{
            return .failure(.encodingError)
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
            
            //handle unauthorized
     
            if httpResponse.statusCode == 401{
                return .failure(.unauthorized)
            }
            
            //Handle other server errors 
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
    //MARK: - CHECKOUT
    // MARK: - CHECKOUT

    func checkout(firebaseIDToken: String,latitude: Double,longitude: Double,device: DeviceCheckInInfo) async -> Result<APIResponse, APIError> {

        guard let url = URL(string: Constants.checkOutEndPoint) else {
            return .failure(.invalidURL)
        }

        let body = CheckInRequest(
            lat: latitude,
            lng: longitude,
            device: device
        )

        let httpBody: Data

        do {
            httpBody = try JSONEncoder().encode(body)
        } catch {
            return .failure(.encodingError)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            "Bearer \(firebaseIDToken)",
            forHTTPHeaderField: "Authorization"
        )
        request.httpBody = httpBody

        do {
            let (data, response) = try await URLSession.shared.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(
                    .serverError(
                        statusCode: 0,
                        message: "Invalid response from server."
                    )
                )
            }

            if httpResponse.statusCode == 401 {
                return .failure(.unauthorized)
            }

            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let apiResponse = try JSONDecoder().decode(
                        APIResponse.self,
                        from: data
                    )

                    return .success(apiResponse)
                } catch {
                    print("Checkout decoding error:", error)
                    print(
                        "Server response:",
                        String(data: data, encoding: .utf8) ?? "Invalid data"
                    )

                    return .failure(.decodingError)
                }

            default:
                let errorResponse = try? JSONDecoder().decode(
                    APIResponse.self,
                    from: data
                )

                return .failure(
                    .serverError(
                        statusCode: httpResponse.statusCode,
                        message: errorResponse?.message
                    )
                )
            }
        } catch {
            return .failure(.networkError(error))
        }
    }
    //GET EMPLOYEE RECENT CHECKIN
    func fetchLastCheckin(token: String) async -> Result<CheckIn, APIError> {

        // 1️⃣ Create URL
        guard let url = URL(string: Constants.getRecentCheckInEndPoint) else {
            print("❌ Invalid URL")
            return .failure(.invalidURL)
        }

        // 2️⃣ Create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        do {

            // 3️⃣ Perform request
            let (data, response) = try await URLSession.shared.data(for: request)

            // 4️⃣ Validate HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {

                return .failure(
                    .serverError(
                        statusCode: -1,
                        message: "Invalid response"
                    )
                )
            }

            print("📶 HTTP status code: \(httpResponse.statusCode)")

            // 5️⃣ Handle HTTP status codes
            switch httpResponse.statusCode {

            case 200...299:
                break

            case 401:

                print("❌ Unauthorized")

                return .failure(.unauthorized)

            default:

                if let errorResponse =
                    try? JSONDecoder().decode(ErrorResponse.self, from: data) {

                    print("❌ Server error message: \(errorResponse.error)")

                    return .failure(
                        .serverError(
                            statusCode: httpResponse.statusCode,
                            message: errorResponse.error
                        )
                    )

                } else {

                    let message =
                        String(data: data, encoding: .utf8)
                        ?? "Unknown error"

                    print("❌ Server returned: \(message)")

                    return .failure(
                        .serverError(
                            statusCode: httpResponse.statusCode,
                            message: message
                        )
                    )
                }
            }

            // 6️⃣ Decode successful response
            let decoder = JSONDecoder()

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")

            decoder.dateDecodingStrategy = .formatted(formatter)

            do {

                let checkin = try decoder.decode(CheckIn.self, from: data)

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

    //GET ALL Employees ON SITE
     func fetchCheckedInUsers(token: String) async -> Result<[CheckedInUser], APIError> {
         
         // 1️⃣ URL
         guard let url = URL(string: Constants.getAllEmployeesOnSiteEndPoint) else {
         
             return .failure(.invalidURL)
         }
         

         
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         
 
         
         do {
             // 2️⃣ Perform network request
             let (data, response) = try await URLSession.shared.data(for: request)
             
             // 3️⃣ Validate HTTP response
             guard let httpResponse = response as? HTTPURLResponse else {
          
                 return .failure(.serverError(statusCode: -1, message: "Invalid response"))
             }
             
             // MARK: - Handle Unauthorized
                 if httpResponse.statusCode == 401 {
                     print("❌ Unauthorized - token may be invalid or expired")
                     return .failure(.unauthorized)
                 }
             
             guard (200...299).contains(httpResponse.statusCode) else {
              
                 
                 if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
          
                     return .failure(.serverError(statusCode: httpResponse.statusCode, message: errorResponse.error))
                 } else {
                     let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                 
                     return .failure(.serverError(statusCode: httpResponse.statusCode, message: message))
                 }
             }
             
             // 4️⃣ Decode JSON into [CheckedInUser]
             let decoder = JSONDecoder()
             do {
                 let users = try decoder.decode([CheckedInUser].self, from: data)
       
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
    
    
    
//MARK: OTHER
    //Register Device with backend
    func sendDeviceInfoToAPI(device: Device, completion: @escaping (Result<Void, Error>) -> Void) {
        print("Data sent to API...")
    }

 
}

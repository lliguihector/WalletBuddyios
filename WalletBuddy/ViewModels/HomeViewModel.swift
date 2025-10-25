//
//  HomeViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/18/25.
//
import Foundation


@MainActor
class HomeViewModel: ObservableObject{
    //MARK: - Properties
    @Published var isLoading: Bool = false
    @Published var showFailureAlert: Bool = false
    @Published var errorMessage: String? = nil
    @Published var lastCheckin: CheckIn?
    @Published var successMessage: String? = nil
    @Published var showSuccessAlert = false
    
    
    
//MARK: -  SATATUS UPDATE
//    @Published var status: String = "Loading..."
//    @Published var statusColor: Color = .gray
//    @Published var statusIcon: String = "questionmark.circle"
//    @Published var timeSinceEvent: String = "..."

    
    //MARK: - DEPENDENCIES
    private var apiService = ApiService.shared
    private var firebaseService = FirebaseAuthManager.shared
    
    func fetchLastCheckin() async{
        
    isLoading = true
        defer {isLoading = false}
        
        // Simulate delay for skeleton view
//             try? await Task.sleep(nanoseconds:10_000_000_000) // 2 seconds
        
        do{
            //Get Firebase ID token
            guard let idToken = try await firebaseService.getIDToken(forceRefresh: true)else{
                showFailureAlert = true
                errorMessage = "Authentication failed. Please log in again."
                return
            }
            //Call API
            let result = await apiService.fetchLastCheckin(token: idToken)
            
            
            //Handle result
            switch result{
            case .success(let checkIn):
                self.lastCheckin = checkIn
                self.showFailureAlert = false
                self.errorMessage = nil
                
                
            case .failure(let error):
                self.showFailureAlert = true
                switch error{
                case .invalidURL:
                    errorMessage = "Invalid server URL."
                case .serializationError:
                    errorMessage = "Failed to process server response"
                case .decodingError:
                    errorMessage = "Failed to decode data."
                case .networkError(let err):
                    errorMessage = "Network error: \(err.localizedDescription)"
                case .serverError( _ , let message):
                    //Use backend's actual error message, or a dedault
                    errorMessage = message ?? "Server rejected the request."
                }
            }
        }catch{
            showFailureAlert = true
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
    }
    
    
    //CHECK OUT USER
    // CHECK OUT USER
    func checkoutUser() async {
        isLoading = true
        defer { isLoading = false }

        do {
            guard let idToken = try await firebaseService.getIDToken(forceRefresh: true) else {
                showFailureAlert = true
                errorMessage = "Failed to get ID token."
                return
            }

            // Call API
            let result = await apiService.checkout(firebaseIDToken: idToken)

            // Handle Result
            switch result {
            case .success(let message):
                showFailureAlert = false
                errorMessage = nil
                successMessage = message
               showSuccessAlert = true

            case .failure(let error):
                showFailureAlert = true
                switch error {
                case .serverError(_, let message):
                    errorMessage = message ?? "Server error occurred."
                    print("CheckOut Server Error: \(message ?? "Server Error")")
                case .networkError(let err):
                    errorMessage = "Network error: \(err.localizedDescription)"
                    print("CheckOut networkError: \(err.localizedDescription)")
                case .invalidURL:
                    errorMessage = "Invalid URL."
                    print("CheckOut invalidURL: \(error)")
                default:
                    errorMessage = "An unknown error occurred."
                    print("Check Out default: \(error)")
                }
            }

        } catch {
            showFailureAlert = true
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }

    
    
    
    
}

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
    
    
    
    
    
    
    
    
    
    
}

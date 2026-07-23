//
//  AdminOnboardingViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/20/26.
//
import SwiftUI



@MainActor
class AdminOnboardingViewModel: ObservableObject{
    
    //MARK: - DEPENDENCIES
    private var apiService = ApiService.shared
    
    
    //UI Error messages
    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    @Published var confirmPasswordError: String? = nil
    @Published var errorMessage: String? = nil
    
    
    //UI Onboarding view step
    @Published var currentStep = 1
    let  totalSteps = 6
    
    //Loading Spinner
    @Published var isLoading: Bool = false
    
    
    //Account info
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    
    //Organization info
    
    func createFireBaseUser() async{
       
        guard validateUserInput() else{
            return
        }
        
     //Loading Spinner Start
        isLoading = true
        defer {isLoading = false}
        
        do {
            print("⏳ Loading started...")

            // Simulate API delay (5 seconds)
            try await Task.sleep(nanoseconds: 1_000_000_000)

            // Simulate success
            print("✅ Finished loading successfully")

        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }
        
    }
    
    func validateUserInput() -> Bool {
        
        
        //Clear previous error
        firstNameError = nil
        lastNameError  = nil
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        
        let firstNameResult = AuthValidator.validateFirstName(firstName)
        switch firstNameResult {
            
        case .failure(let message):
            firstNameError = message
            
            return false
            
        case .success:
            break
        }
        
        let lastNameResult = AuthValidator.validateLastName(lastName)
        switch lastNameResult {
            
        case .failure(let message):
            lastNameError = message
            
            return false
            
        case .success:
            break
        }
        //Validate User Input
        let emailResult = AuthValidator.validateEmail(email)
        switch emailResult {
            
        case .failure(let message):
            emailError = message
            
            return false
            
        case .success:
            break
        }
        
        let passwordResult = AuthValidator.validatePassword(password)
        switch passwordResult {
            
        case .failure(let message):
            passwordError = message
            
            return false
            
        case .success:
            break
        }
        
        let matchResult = AuthValidator.validatePasswordMatch(password:password, confirmPassword: confirmPassword)
        
        switch matchResult {
            
        case .failure(let message):
            confirmPasswordError = message
            return false
        
    case .success:
        break
    }
    
    
        
        return true
    }
    
    
    func completeOnboarding(){
        
        //Call API
        //Uodate backend onboardingStatus = Complete
    }
    
    
    
}

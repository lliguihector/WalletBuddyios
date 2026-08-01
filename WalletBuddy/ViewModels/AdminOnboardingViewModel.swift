//
//  AdminOnboardingViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/20/26.
//
import SwiftUI



@MainActor
class AdminOnboardingViewModel: ObservableObject{
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    //MARK: - DEPENDENCIES
    private var apiService = ApiService.shared
    private var firebaseAuthService = FirebaseAuthManager.shared
    
    
    
    //MARK: - UI Error messages
    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    @Published var confirmPasswordError: String? = nil
    
    //MARK: - UI Error messages Organization View
    @Published var organizationNameError: String? = nil
    @Published var organizationEmailError: String? = nil
    @Published var organizationPhoneNumberError: String? = nil
    @Published var organizationWebsiteUrlError: String? = nil
    
    //MARK: - Alerts
    @Published var alertTitle = "Error"
    @Published var showAlert = false
    @Published var errorMessage: String? = nil

   
    //MARK: - Onboarding
    @Published var currentStep = 1
    let  totalSteps = 6
    
    //MARK: - Loading
    @Published var isLoading: Bool = false
    
    
    //MARK: - Account Infromation
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    
    //MARK: - Organization Inforomation
    @Published var organizationName = ""
    @Published var industry: String = ""
    @Published var organizationEmail = ""
    @Published var organizationPhoneNumber  = ""
    @Published var organizationWebsiteUrl = "" 
    
    
    @Published var industryError: String?
    //CAT errase this from api and here V
    @Published var registerResponse: RegisterAdminResponse?
    
    //MARK: - Firebase / Verification
    @Published var firebaseUID: String?
    @Published var emailVerified = false
    
    
    //MARK: - Create FireBase Admin User
    func createFireBaseUser() async -> Bool{
        
        //1. Validate user Input
        guard validateUserInput() else{
            return false
        }
        
        //Loading Spinner Start
        isLoading = true
        errorMessage = nil
        defer {isLoading = false}
        
        
        let result = await apiService.registerAdmin(firstName: firstName, lastName: lastName, email: email, password: password)
        
        
        
        switch result {
        case .success(let response):
            
            //Save Firebase UID
            firebaseUID = response.firebaseUID
            
            //Login newly created firebsse user
            switch await loginUserwithFirebase(){
                case .success:
                //Register + Firebase login successful
                return true
                case .failure(let message):
                alertTitle = "Firebase Login Failed"
                errorMessage = message
                showAlert = true
               
                return false
        }
            
    case .failure(let error):
        handleAPIError(error)
        return false
        
    }
    }
    
    //MARK: - Login User to fireBase
    func loginUserwithFirebase() async -> LoginResult{
        
        do{
            
            try await firebaseAuthService.login(email: email, password: password)

//            await appViewModel.userDidLogin() CAT poli
            return .success
        }catch{
            return .failure(error.localizedDescription)
        }
        
    }
    
    
    
    //MARK: Helper Fucntions
    //Validate user client side input
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
    //Api Error Handling
    private func handleAPIError(_ error: APIError){
        alertTitle = "Registration Failed"
        
        switch error{
            
        case .invalidURL:
            errorMessage = "Invalid URL."

        case .encodingError:
            errorMessage = "Unable to send your request."

        case .decodingError:
            errorMessage = "Unable to process server response."

        case .networkError:
            errorMessage = "Please check your internet connection."

        case .serverError(_, let message):
            errorMessage = message ?? "An unexpected error occurred."
        }
        
        showAlert = true
    }
    
    //MARK: - Verify Email

    func verifyEmail()async{
        
        
        isLoading = true
        defer {isLoading = false}
        
        
        do{
            //Get Firebase ID token
            guard let idToken = try await firebaseAuthService.getIDToken(forceRefresh: true)else{
                errorMessage = "Authentication failed. Please log in again."
                showAlert = true
           
                return
            }
            
            let result = await apiService.checkEmailVerification(withToken: idToken)

            
            switch result {

            case .success(let response):

                if response.emailVerified {

                    // Email verified successfully
                    emailVerified = true
                    
                    
                    
                    // Move to next onboarding step
                    // navigationRouter.push(.organizationSetup)
                    
              

                } else {

                    // Email not verified yet
            
                    alertTitle = "Verification Required"
                    errorMessage = response.message ?? "Please verify your email to continue."
                    showAlert = true
                }


            case .failure(let error):

                handleAPIError(error)
            }


         
            
            
            
        }catch{
         
            alertTitle = "Error"
            errorMessage = "Unexpected error: \(error.localizedDescription)"
            showAlert = true
        }
        
        
    }
}
    //Call API
    //Uodate backend onboardingStatus = Complete

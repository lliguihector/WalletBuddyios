//
//  AuthValidator.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/23/26.
//
import Foundation
struct AuthValidator{
    
    
    //MARK: FIRST NAME
    static func validateFirstName(_ firstName: String) -> ValidationResult{
        
        let trimmedName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
    
        
        guard !trimmedName.isEmpty else{
            return .failure("Please enter your first name.")
        }
        
        guard trimmedName.count >= 2 else{
            return .failure("First name must be at least 2 characters.")
        }
        
        return .success
    }
    //MARK: LAST NAME
    static func validateLastName(_ lastName: String) -> ValidationResult{
        let trimLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard !trimLastName.isEmpty else{
            return .failure("Please enter your last name.")
        }
        
        guard trimLastName.count >= 2 else{
            return .failure("Last name must be at least 2 characters.")
        }
        
        
        return .success
    }
    
    
    //MARK: EMAIL
    static func validateEmail(_ email: String) -> ValidationResult{
        
        let trimedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimedEmail.isEmpty else{
            return .failure("Please enter your email.")
        }
        
        guard isValidEmail(trimedEmail)else{
            return .failure("Please enter a valid email address.")
        }

        return .success
    }
    
    
    
    private static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    //MARK: PASSWORD
    
    static func validatePassword(_ password: String) -> ValidationResult{
        guard !password.isEmpty else{
            return .failure("Please enter your password")
        }
        guard password.count >= 8 else{
            return .failure("Password must be at least 6 characters.")
        }
        return .success
    }
    //MARK: PASSWORD MATCH
    static func validatePasswordMatch(password: String, confirmPassword: String) -> ValidationResult{
        
        guard password == confirmPassword else{
            return .failure("Passwords do not match.")
        }
        return .success
    }
    
    
    
    
 
}

//
//  OrganizationValidator.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/9/26.
//

import Foundation

struct OrganizationValidator {
        
    //MARK:  name
    static func validateName(_ name: String) -> ValidationResult {
        
        
        let trimOrganizationName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard !trimOrganizationName.isEmpty else{
            return .failure("Please enter your Organization name.")
        }
        
        guard trimOrganizationName.count >= 2 else{
            return .failure("Organization name must be at least 2 characters long.")
        }
        
        return .success
 
    }
    
    //MARK: Email
    static func validateEmail(_ email: String) -> ValidationResult {
        
        
        let trimEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard !trimEmail.isEmpty else{
            return .failure("Please enter your work email.")
        }
        
        guard isValidEmail(trimEmail)else{
            return .failure("Please enter valid email address.")
        }
        
        
        return .success
        
    }
    
    private static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    //MARK: phone number
    static func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult {
        let digits = phoneNumber.filter(\.isNumber)
        
        
        guard !digits.isEmpty else{
            return .failure("Please enter your organization phone number.")
        }
        
        
        guard digits.count == 10 else{
            return .failure("Phone number must contain 10 digits.")
        }
        return .success

    }
    
    //MARK:  Industry
    static func validateIndustry(_ industry: String) -> ValidationResult {

          let trimmedIndustry = industry
              .trimmingCharacters(in: .whitespacesAndNewlines)

          guard !trimmedIndustry.isEmpty else {
              return .failure("Please select an industry.")
          }

          return .success
      }

    // MARK: - Website URL
     static func validateWebsiteURL(_ websiteURL: String)  -> ValidationResult {

         let trimmedURL = websiteURL
             .trimmingCharacters(in: .whitespacesAndNewlines)

         // Website is optional
         guard !trimmedURL.isEmpty else {
             return .success
         }

         let normalizedURL: String

         if trimmedURL.lowercased().hasPrefix("http://") ||
             trimmedURL.lowercased().hasPrefix("https://") {

             normalizedURL = trimmedURL

         } else {
             normalizedURL = "https://\(trimmedURL)"
         }

         guard let components = URLComponents(
             string: normalizedURL
         ),
         let scheme = components.scheme,
         let host = components.host,
         ["http", "https"].contains(scheme.lowercased()),
         host.contains(".") else {

             return .failure(
                 "Please enter a valid website, such as example.com."
             )
         }

         return .success
     }
    
    
}

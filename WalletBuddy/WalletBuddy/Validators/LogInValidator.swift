//
//  LogInValidator.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/14/25.
//
import Foundation

struct LoginValidator {

    static func validate(email: String?, password: String?) -> ValidationResult {
        guard let email = email, !email.isEmpty else {
            return .failure("Please enter your email.")
        }

        guard let password = password, !password.isEmpty else {
            return .failure("Please enter your password.")
        }

        if !isValidEmail(email) {
            return .failure("Please enter a valid email address.")
        }

        if password.count < 6 {
            return .failure("Password must be at least 6 characters.")
        }

        return .success
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
}

enum ValidationResult {
    case success
    case failure(String)
}


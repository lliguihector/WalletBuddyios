//
//  AppUser.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/19/25.
//
import Foundation


struct AppUser: Codable{

    
    let uid: String    //Firebase UID
    let email: String
    let emailVerified: Bool
    let onboardingStep: OnboardingStep
    let firstName: String
    let lastName: String
    let providerIds: [String]?

}

enum OnboardingStep: Int, Codable {
    case enterName = 0
    case complete = 1
    // Add more steps as needed
}

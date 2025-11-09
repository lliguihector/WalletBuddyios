//
//  AppUser.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/19/25.
//
import Foundation


struct AppUser: Codable, Identifiable{

    let id: String
    let uid: String    //Firebase UID
    let email: String
    let emailVerified: Bool
    let onboardingStep: OnboardingStep
    let firstName: String
    let lastName: String
    let providerIds: [String]?
    let profileImageUrl: String? //Can be nill 
    let title: String
    let organization: Organization?
    let devices: [Device]?
    
    var fullName: String {"\(firstName) \(lastName)"}
    
    
    enum CodingKeys: String, CodingKey{
        case id = "_id"
        case uid
        case email
        case emailVerified
        case onboardingStep
        case firstName
        case lastName
        case providerIds
        case profileImageUrl
        case title
        case organization
        case devices
        
    }

}

enum OnboardingStep: Int, Codable {
    case enterName = 0
    case complete = 1
    // Add more steps as needed
}

//Mark: - Organization model
struct Organization: Codable{
    let name: String
    let type: String
    let email: String
    let phone: String
    let website: String
    let logoUrl: String?
    let address: Address
    let location: Location
}


struct Address: Codable{
    let street: String
    let city: String
    let state: String
    let postalCode: String
    let country: String
}

struct Location: Codable{
    let type: String
    let coordinates: [Double]//[longitude, latitude]
}


struct Device: Codable{
    let deviceId: String
    let apnsToken: String
    let platform: String
    let model: String
    let systemVersion: String
    let appVersion: String
    let lastUsedAt: Date
}

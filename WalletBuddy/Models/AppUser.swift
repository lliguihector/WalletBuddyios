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
    let employeeId: String?
    let email: String
    let emailVerified: Bool
    let firstName: String
    let lastName: String
    let providerIds: [String]?
    let profileImageUrl: String? //Can be nill 
    let title: String
    let role: UserRole
    let organization: Organization?
    let onboardingStatus: OnboardingStatus?
    let devices: [Device]?
    //let beacon: String - can be null 
    
    var fullName: String {"\(firstName) \(lastName)"}
    
    
    enum CodingKeys: String, CodingKey{
        case id = "_id"
        case uid
        case employeeId
        case email
        case emailVerified
        case firstName
        case lastName
        case providerIds
        case profileImageUrl
        case title
        case role
        case organization
        case onboardingStatus
        case devices
        
    }

}


//Mark: - Organization model
struct Organization: Codable, Identifiable{
    
    
    let id: String
    let name: String
    let industry: Industry
    let email: String
    let phone: String?
    let website: String?
    let logoKey: String?
    let indoorPositioning: IndoorPositioning?
    
    
    let address: Address?
    let location: Location?

    
    //Coding keys -- Used to map backend JSON keys to Swift property names when they differ
    enum CodingKeys: String, CodingKey{
        
        case id = "_id"
        case name
        case industry
        case email
        case phone
        case website
        case logoKey
        case indoorPositioning
        
        case address
        case location
 
    }
    
}

struct IndoorPositioning: Codable{
    let enabled: Bool
}
struct Address: Codable{
    let street: String?
    let city: String?
    let state: String?
    let postalCode: String?
    let country: String?
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

enum UserRole: String, Codable{
    case organizationAdmin = "organization_admin"
    case manager = "manager"
    case supervisor = "supervisor"
    case employee = "employee"
    
    
    var displayName: String{
        switch self{
            
            
        case .organizationAdmin:
            return "Organization Admin"
            
            
        case .manager:
            return "Manager"
            
        case .supervisor:
            return "Supervisor"
            
        case .employee:
            return "Employee"
            
        }
    }
 
}
enum OnboardingStatus: String, Codable{
    case invite = "invited"
    case emailVerificationRequired = "email_verification_required"
    case organizationSetupRequired = "organization_setup_required"
    case organizationLocationRequired = "organization_location_required"
    case passwordResetRequired = "password_reset_required"
    case profileSetupRequired = "profile_setup_required"
    case completed = "completed"
}

enum Industry: String, Codable,CaseIterable{
    case retail = "Retail"
    case SoftwareAndTechnology = "Software & Technology"
    case healthCare = "Healthcare"
    case technology = "Technology"
    case finance = "Finance"
    case contruction = "Contruction"
    case hospetaloty = "Hospitality"
    case education = "Education"
    case transportation = "Transportation"
    case manufacturing = "Manufacturing"
    case professionalServices = "Professional Services"
    case other = "Other"
}

//
//  CreateOrganizationRequest.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/12/26.
//

struct APIErrorResponse: Codable {
    let success: Bool
    let message: String?
}
struct CreateOrganizationResponse: Codable{
    let success: Bool
    let organization: CreatedOrganization
    
}

struct CreateOrganizationRequest: Codable{
    let name: String
    let industry: String
    let email: String
    let phone: String?
    let website: String?
}


struct CreatedOrganization: Codable, Identifiable {

    let id: String
    let name: String
    let industry: String
    let email: String
    let phone: String
    let website: String?
    let logoKey: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case industry
        case email
        case phone
        case website
        case logoKey
    }
}

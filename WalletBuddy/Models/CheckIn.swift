//
//  CheckIn.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/15/25.
//
import Foundation

struct CheckInResponse: Codable{
    let success: Bool
    let message: String

}



struct CheckIn: Codable{
    let _id: String
    let user: String
    let organization: String
    let location: Location
    let distanceFromOrg: Int
    let checkedOut: Bool
    let checkInTime: Date
    let checkedOutTime: Date?
    let method: String
    let deviceID: String

    }

import Foundation

// MARK: - Single Checked-In User
struct CheckedInUser: Codable, Identifiable {
    let id: String       // map from "userId"
    let uid: String
    let name: String
    let title: String?
    let email: String?
    let profileImageUrl: String?

    // Coding keys to match JSON keys
    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case uid 
        case name
        case title
        case email
        case profileImageUrl
    }
}


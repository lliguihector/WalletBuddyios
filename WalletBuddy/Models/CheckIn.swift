//
//  CheckIn.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/15/25.
//
import Foundation


enum CheckinStatus: String,Codable{
case active
case completed
    
}


struct CheckInResponse: Codable{
    let success: Bool
    let message: String

}

//to store device information 
struct DeviceCheckInInfo: Codable{
    let id: String
    let platform: String
    let osVersion: String
    let model: String
    let appVersion: String?
}

//To request model for API
struct CheckInRequest: Codable{
    let lat: Double
    let lng: Double
    let device: DeviceCheckInInfo
}

struct CheckIn: Codable{
    let _id: String
    let user: String
    let organization: String
    let location: Location
    let distanceFromOrg: Int
    let status: CheckinStatus
    let checkInTime: Date
    let checkedOutTime: Date?
    let method: String
//    let device: DeviceCheckInInfo

    }

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


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
    let id: String?
    let platform: String?
    let osVersion: String?
    let model: String?
    let appVersion: String?
}

//To request model for API
struct CheckInRequest: Codable{
    let lat: Double
    let lng: Double
    let device: DeviceCheckInInfo
}



struct CheckIn: Codable, Identifiable {
    let id: String

    // Relationships
    let user: String
    let organization: String

    // Clock-in information
    let clockInIp: String?
    let location: GeoPoint
    let distanceFromOrg: Int
    let device: DeviceCheckInInfo

    // Clock-out information
    let clockOutIp: String?
    let clockOutDevice: DeviceCheckInInfo?
    let clockOutLocation: GeoPoint?
    let clockOutDistanceFromOrg: Int?
    let checkOutTime: Date?
    let workDurationMinutes: Int?

    // Attendance information
    let status: CheckinStatus
    let checkInTime: Date
    let shiftDate: Date
    let timeZone: String
    let method: CheckInMethod
    let beaconId: String?
    let notes: String

    // Mongoose timestamps
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case organization

        case clockInIp
        case location
        case distanceFromOrg
        case device

        case clockOutIp
        case clockOutDevice
        case clockOutLocation
        case clockOutDistanceFromOrg
        case checkOutTime
        case workDurationMinutes

        case status
        case checkInTime
        case shiftDate
        case timeZone
        case method
        case beaconId
        case notes

        case createdAt
        case updatedAt
    }
}


struct GeoPoint: Codable {
    let type: String
    let coordinates: [Double]

    var longitude: Double? {
        guard coordinates.count >= 2 else { return nil }
        return coordinates[0]
    }

    var latitude: Double? {
        guard coordinates.count >= 2 else { return nil }
        return coordinates[1]
    }
}

enum CheckInMethod: String, Codable {
    case gps
    case gpsAndBeacon = "gps+beacon"
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


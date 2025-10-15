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
    let checkIn: CheckIn
    let distance: Double
    
    
    enum CodingKeys: String, CodingKey
    {
        case success
        case message
        case checkIn = "checkIn"
        case distance
        
    }

}



struct CheckIn: Codable{
    let _id: String
    let user: String
    let organization: String
    let location: Location?
    let distanceFromOrg: Double?
    let checkInTime: String
    let method: String
    let deviceID: String
    }



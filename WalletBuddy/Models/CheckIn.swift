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



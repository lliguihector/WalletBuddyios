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
    let profileCompleted: Bool
    let firstName: String
    let lastName: String
    let providerIds: [String]?

}


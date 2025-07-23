//
//  AppUser.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/19/25.
//
import Foundation
import FirebaseAuth

struct AppUser: Identifiable,Codable{
    let id: String    //Firebase UID
    let email: String
}


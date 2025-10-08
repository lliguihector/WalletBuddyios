//
//  PendingDevice.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/6/25.
//
import UIKit
import Foundation

struct PendingDevice: Codable{
    
    let deviceId: String
    let apnsToken: String
    let platform: String
    let model: String
    let systemVersion: String
    let appVersion: String
    let lastUsedAt: Date
}

//
//  Untitled.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/26/26.
//

struct EmailVerificationResponse: Decodable{
    let success: Bool
    let emailVerified: Bool
    let message: String?
}

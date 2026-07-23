//
//  RegisterAdminResponse.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/22/26.
//

struct RegisterAdminResponse: Decodable {
    let success: Bool
    let message: String
    let firebaseUID: String?
}


struct RegisterAdminRequest: Encodable{
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

//
//  Message.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 11/12/25.
//

import Foundation

struct Message: Identifiable{
    let id = UUID()//uniquely identify objects
    let text:String
    let senderId: String
}

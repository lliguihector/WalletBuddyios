//
//  Message.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 11/12/25.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()         // can be server _id or local UUID
    let text: String
    let senderId: String
    var delivered: Bool = false
    var read: Bool = false

//    init(id: String? = nil, text: String, senderId: String, delivered: Bool = false, read: Bool = false) {
//        self.id = id ?? UUID().uuidString  // use server ID if available, otherwise generate UUID
//        self.text = text
//        self.senderId = senderId
//        self.delivered = delivered
//        self.read = read
//    }
}

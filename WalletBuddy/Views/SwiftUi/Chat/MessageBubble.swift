//
//  MessageBubble.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 11/17/25.
//
import SwiftUI

struct MessageBubble: View {
    let text: String
    let isMe: Bool

    var body: some View {
        HStack {
            if isMe {
                Spacer()
                Text(text)
                    .padding(10)
                    .background(Color.blue) // solid blue
                    .foregroundColor(.white) // text color white for contrast
                    .cornerRadius(12)
            } else {
                Text(text)
                    .padding(10)
                    .background(Color.gray.opacity(0.3)) // slightly darker gray
                    .foregroundColor(.black)
                    .cornerRadius(12)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}



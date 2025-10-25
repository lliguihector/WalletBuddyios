//
//  WBToast.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 9/30/25.
//
import SwiftUI
    
struct WBToast: View {
    
    let message: String
    let isError: Bool
    
    
    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.vertical, 10)
            .padding(.horizontal,16)
            .background(isError ? Color.red.opacity(0.9) : Color.green.opacity(0.9))
            .cornerRadius(10)
            .padding(.top, 50)
            .shadow(radius: 5)
    }
}

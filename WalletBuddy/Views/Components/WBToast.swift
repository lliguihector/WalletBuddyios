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
        
        HStack(spacing: 10){
            
            Image(systemName: isError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .foregroundColor(.white)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            
        }
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal,16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isError ? Color.red.opacity(0.9) : Color.green.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 10))
             .shadow(color: .black.opacity(0.2), radius: 5, y: 2)
             .padding(.horizontal, 16)
             .padding(.top, 50)
             .accessibilityElement(children: .combine)
        
    
        }
      
}

#Preview{
    WBToast(message: "Completed", isError: false)
}

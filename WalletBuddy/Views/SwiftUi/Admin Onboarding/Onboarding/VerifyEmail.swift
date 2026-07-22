//
//  Verify Email.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/15/26.
//
import SwiftUI

struct VerifyEmail: View {
    
    @State private var email: String = "Lliguichuzcah@gmail.com"
    
    var body: some View {
        
        VStack(spacing: 28) {
            
            // MARK: Progress Bar
            ProgressView(value: Double(1), total: Double(6))
                .progressViewStyle(.linear)
                .tint(.blue)
            
            
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "envelope")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue)
            }
            
            Text("Verify Your Email")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Description
            VStack(spacing: 12) {
                
                Text("We've sent a verification link to")
                    .foregroundStyle(.secondary)
                
                Text(email)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Text("Please check your inbox and click the link to verify your email address.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    VerifyEmail()
}




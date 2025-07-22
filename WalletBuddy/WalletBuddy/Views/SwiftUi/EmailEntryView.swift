//
//  EmailEntryView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/22/25.
//

import SwiftUI

struct EmailEntryView: View {
    
    @State private var email = ""
    
    var body: some View {
        VStack(spacing:20){
            Text("Enter your email")
                .font(.title)
                .bold()
            
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            
        }
    }
}

#Preview {
    EmailEntryView()
}

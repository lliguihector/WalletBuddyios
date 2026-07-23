
import SwiftUI

struct CustomTextField: View {

    let title: String

    @Binding var text: String

    var keyboard: UIKeyboardType = .default

    var systemImage: String

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: systemImage)
                .foregroundColor(.secondary )

            TextField(title, text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .tint(.blue)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.7), lineWidth: 1)
            
        )
    }
}//
//  CustomTextField.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/14/26.
//


//
//  PasswordField.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/14/26.
//
import SwiftUI
struct PasswordField: View {

    let title: String

    @Binding var text: String

    @Binding var isVisible: Bool

    var body: some View {

        HStack {

            Image(systemName: "lock")
                .foregroundColor(.secondary)

            if isVisible {

                TextField(title, text: $text)
                    .tint(.blue)

            } else {

                SecureField(title, text: $text)
                    .tint(.blue)
            }

            Button {

                isVisible.toggle()

            } label: {

                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }

        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.7), lineWidth: 1)
            
        )
    }
}

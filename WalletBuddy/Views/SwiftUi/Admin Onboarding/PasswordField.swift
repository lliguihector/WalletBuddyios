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
                .foregroundColor(.gray)

            if isVisible {

                TextField(title, text: $text)

            } else {

                SecureField(title, text: $text)
            }

            Button {

                isVisible.toggle()

            } label: {

                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }

        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

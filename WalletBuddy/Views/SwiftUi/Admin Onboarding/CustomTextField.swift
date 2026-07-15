
import SwiftUI

struct CustomTextField: View {

    let title: String

    @Binding var text: String

    var keyboard: UIKeyboardType = .default

    var systemImage: String

    var body: some View {

        HStack(spacing: 14) {

            Image(systemName: systemImage)
                .foregroundColor(.gray)

            TextField(title, text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}//
//  CustomTextField.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/14/26.
//


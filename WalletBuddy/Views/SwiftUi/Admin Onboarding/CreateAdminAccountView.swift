//
//  Untitled.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/14/26.
//

import SwiftUI

struct CreateAdminAccountView: View {

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""

    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var showPassword = false
    @State private var showConfirmPassword = false

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 28) {

                // MARK: Progress

                VStack(alignment: .leading, spacing: 12) {

                    StepProgressView(currentStep: 1)
                }

                // MARK: Header

                VStack(alignment: .leading, spacing: 8) {

                    Text("Create your administrator account")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Let's get your organization started.")
                        .foregroundStyle(.secondary)
                }

                // MARK: Form

                VStack(spacing: 18) {

                    CustomTextField(
                        title: "First Name",
                        text: $firstName,
                        systemImage: "person"
                    )

                    CustomTextField(
                        title: "Last Name",
                        text: $lastName,
                        systemImage: "person"
                    )

                    CustomTextField(
                        title: "Work Email",
                        text: $email,
                        keyboard: .emailAddress,
                        systemImage: "envelope"
                    )

                    PasswordField(
                        title: "Password",
                        text: $password,
                        isVisible: $showPassword
                    )

                    PasswordField(
                        title: "Confirm Password",
                        text: $confirmPassword,
                        isVisible: $showConfirmPassword
                    )
                }

                Button {

                    // TODO:
                    // Validate
                    // Call API
                    // Navigate to Verify Email

                } label: {

                    Text("Continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.top)

            }
            .padding(24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CreateAdminAccountView()
    }
}

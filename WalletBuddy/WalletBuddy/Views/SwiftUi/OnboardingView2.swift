//
//  OnboardingView2.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/5/25.
//

import SwiftUI

struct OnboardingView2: View {
    @State private var lastName: String = ""

    var body: some View {
        VStack {
            // Progress bar at top
            ProgressView(value: 0.66)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()

            Spacer().frame(height: 100) // Add smaller top spacer to push content upward

            VStack(spacing: 16) {
                Text("What is your last name?")
                    .font(.headline)

                TextField("Enter Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                NavigationLink(destination: OnboardingView2()){
                    Text("Next")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }

            Spacer() // Remaining space below
        }
        .navigationTitle("Welcome! 😄")

    }
}

#Preview {
    OnboardingView2()
}

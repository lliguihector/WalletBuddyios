//
//  OnboardingView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/21/25.
//


import SwiftUI

struct OnboardingView: View {
    
    
    
    @State private var firstName: String = ""
    
    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        VStack {
            // Progress bar at top
            ProgressView(value: 0.33)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()

            Spacer().frame(height: 100) // Add smaller top spacer to push content upward

            VStack(spacing: 16) {
                Text("What is your first name?")
                    .font(.headline)

                TextField("Enter First Name", text: $firstName)
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
    OnboardingView()
}

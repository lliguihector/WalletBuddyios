//
//  LoginOptionsView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/15/25.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct LoginOptionsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    @State private var showSubtitle = false
    
    var body: some View {
        ZStack {
            // MARK: - Background Gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.2), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                
                // MARK: - Logo + Welcome
                VStack(spacing: 12) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .shadow(radius: 4)
                    
                    Text("Welcome to groupWorks!")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    if showSubtitle {
                        Text("Get started with your account")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .animation(.easeInOut(duration: 0.6), value: showSubtitle)
                    }
                }
                .padding(.top, 60)
                .onAppear {
                    withAnimation(.easeInOut.delay(0.4)) {
                        showSubtitle = true
                    }
                }
                
                Spacer()
                
                // MARK: - Sign In Buttons
                VStack(spacing: 16) {
                    
                    GoogleSignInButton {
                        print("Google Sign In pressed")
                    }
                    .frame(height: 50)
                    .cornerRadius(12)
                    
                    Button(action: {
                        AppViewModel.shared.state = .loggingIn
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "envelope")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            
                            Text("Continue with Email")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    // Optional: Apple Sign-In
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            // Configure request if needed
                        },
                        onCompletion: { result in
                            // Handle completion
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // MARK: - Terms & Privacy
                Text("By continuing, you agree to our Terms & Privacy Policy")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
            }
        }
        // Show alert if AppViewModel sets activeAlert
        .alert(item: $appViewModel.activeAlert) { alert in
            Alert(
                title: Text("Connection Error"),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    LoginOptionsView()
        .environmentObject(AppViewModel.shared)
        .environmentObject(NavigationRouter.shared)
}

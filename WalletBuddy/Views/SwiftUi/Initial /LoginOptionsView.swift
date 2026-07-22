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
                VStack(alignment: .leading, spacing: 20) {
                    
                    HStack(spacing: 12){
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .shadow(radius: 4)
                        
                        Text("Welcome!")
                            .font(.system(size: 28, weight: .bold))
                            
                    }
                    .padding(.bottom, 15)
            
                    Text("Know who's on site in real time.")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(Color(red: 0.05, green: 0.15, blue: 0.35))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 320,alignment: .leading)
                 
                    if showSubtitle {
                        Text("Keep your team connected, accountable, and safe")
                            .font(.system(size: 17))
                                                    .foregroundColor(.gray)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: 300, alignment: .leading)
                                                    .transition(
                                                        .opacity
                                                        .combined(with: .move(edge: .bottom))
                                                    )
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)
                .animation(
                                .easeInOut(duration: 0.6),
                                value: showSubtitle
                            )
                .onAppear {
                    withAnimation(.easeInOut.delay(0.4)) {
                        showSubtitle = true
                    }
                }
                
                Spacer()
                
                // MARK: - Sign In Buttons
                VStack(spacing: 16) {

                    
//                    Button(action: {
//                        print("LOGIN BUTTON TAPPED")
//                        print("PATH BEFORE", navigationRouter.path.count)
//                        navigationRouter.push(.loginEmail)
//                        print("PATH AFTER", navigationRouter.path.count)
//                    })
                    
                    NavigationLink(destination: LogInVCWrapper())
                    {
                        HStack(spacing: 12) {
                            Image(systemName: "envelope")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            
                            Text("Sign In with Email")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    
                    
                    // OR Divider
                    HStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(height: 1)
                        
                        Text("OR")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 10)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(height: 1)
                    }

                    
                    
                    
                    
                    //MARK: -- Register Button
                    NavigationLink(destination: AdminOnboardingContainerView())
                          {
                           HStack(spacing: 12) {
                               
                               Text("Register your Organization")
                                   .font(.headline)
                                   .fontWeight(.semibold)
                                   .foregroundColor(.white)
                                   .frame(maxWidth: .infinity, minHeight: 50)
                                   .cornerRadius(12)
                                   .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)

                           }
                           .foregroundColor(.white)
                           .frame(maxWidth: .infinity, minHeight: 50)
                           .background(Color.black)
                           .cornerRadius(12)
                           .shadow(
                               color: Color.black.opacity(0.15),
                               radius: 4,
                               x: 0,
                               y: 2
                           )
                       }
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
        .onAppear(){
            print("LoginOptions Router:", ObjectIdentifier(navigationRouter))
            print("LoginOptions Path Count:", navigationRouter.path.count)
        }
        
        //MARK: --  Navigation Bar Modifi
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.black)
    }
}

#Preview {
    LoginOptionsView()
        .environmentObject(AppViewModel.shared)
        .environmentObject(NavigationRouter.shared)
}

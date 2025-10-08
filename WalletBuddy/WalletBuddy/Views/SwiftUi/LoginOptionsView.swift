//
//  LoginOptionsView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/15/25.
//

import SwiftUI
import GoogleSignInSwift

struct LoginOptionsView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    
    var body: some View {
        VStack(spacing: 8) {
        
            HStack{
             
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .padding(.trailing,8)
                Spacer()
            }
            
            HStack{
                Text("Welcome to SafetyWorks!")
                    .font(.title2)
                    .bold()
                    .padding(.top, 4)
                    .padding(.trailing, 8)
                
                Spacer()
            }
            Spacer().frame(height: 80)
            
            GoogleSignInButton{
                print("Google Sing In button pressed")
            }
        
            
            //--- LOGIN VIEW EMAIL PASSWORD Firebase ----
            Button(action: {
                AppViewModel.shared.state = .loggingIn
                //optionally push if you want to track it
//                NavigationRouter.shared.push(.loginEmail)
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
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(Color.mint)
                .cornerRadius(4)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal, 0)
            }

            Spacer()
        }
        .padding()
      //This will trigger an alert if AppViewModel sets activeAlert
        .alert(item: $appViewModel.activeAlert){ alert in
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

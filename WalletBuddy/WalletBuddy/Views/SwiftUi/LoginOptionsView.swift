//
//  LoginOptionsView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/15/25.
//

import SwiftUI

struct LoginOptionsView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Welcome")
                .font(.largeTitle)
                .bold()
            Button(action: {
                //TODO
            }) {
                HStack {
                    Image(systemName: "globe")
                    Text("Continue with Google")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            
            Button(action: {
                navigationRouter.push(.loginEmail)
            }) {
                HStack {
                    Image(systemName: "envelope")
                    Text("Continue with Email")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        // Put modifiers here, **inside** the body scope:
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}


#Preview {
    LoginOptionsView()
}

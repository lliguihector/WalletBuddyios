//
//  MainView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
  
    let user: AppUser
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        VStack(spacing: 16)
        {
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 4)
                )
                .shadow(radius: 7)
            Text("your email is: \(user.email)")
            Text("your user uid is: \(user.id)")
            Button("Logout"){
                appViewModel.logout()
//                navigationRouter.popToRoot()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MainView(user: AppUser(id: "12345", email: "test@example.com"))
}

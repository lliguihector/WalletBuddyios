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

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text("Welcome!")
        Text("your email is: \(user.email)")
        Text("your user uid is: \(user.id)")
    }
}

#Preview {
    MainView(user: AppUser(id: "12345", email: "test@example.com"))
}

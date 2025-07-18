//
//  MainView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    let email: String

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text("Welcome! \(email)")
    }
}

#Preview {
    MainView(email: "mock@example.com")
}

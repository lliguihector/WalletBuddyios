//
//  UIDView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/30/25.
//
import SwiftUI

struct UIDView: View {
    let uid: String  // property to hold the UID

    var body: some View {
        VStack {
            Text("User UID:")
                .font(.headline)
            Text(uid)
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .padding()
        .navigationTitle("UID Details")
    }
}


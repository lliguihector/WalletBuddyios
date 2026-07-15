//
//  offlineView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/25/25.
//

import SwiftUI

struct offlineView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .padding(.bottom, 10)
            
            Text("No Internet Connection")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Please check your network settings.")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
        .ignoresSafeArea()
    }
}

#Preview {
    offlineView()
}

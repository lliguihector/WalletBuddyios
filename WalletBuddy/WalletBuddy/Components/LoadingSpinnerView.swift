//
//  LoadingSpinnerView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/16/25.
//

import SwiftUI

struct LoadingSpinnerView: View {
    var body: some View {
        ZStack{
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .scaleEffect(2)
        }
    }
}

#Preview {
    LoadingSpinnerView()
}

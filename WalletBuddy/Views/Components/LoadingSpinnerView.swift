//
//  LoadingSpinnerView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/16/25.
//

import SwiftUI

struct LoadingSpinnerView: View {
    var body: some View {
        ZStack {
            // Optional full screen dimmed background
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            
            // Square background for the spinner
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.8)) // black with opacity
                .frame(width: 120, height: 110) // square size
            
            // White spinner
            
            
            VStack(spacing: 14){
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Loading...")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
            }
         
        }
    }
}

#Preview {
    LoadingSpinnerView()
}


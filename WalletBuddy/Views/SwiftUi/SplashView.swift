//
//  SplashView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/5/26.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {// Dark Mode == OFF WHITE , White = White
            Color(colorScheme == .dark ? Color(red: 0.97, green: 0.97, blue: 0.96) : Color.white)
                .ignoresSafeArea()
            
            content
        }
    }
    
    // MARK: - Main Content
    
    private var content: some View {
        VStack(spacing: 0) {
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 96)
                .accessibilityHidden(true)
            
            Text("Determit")
                .font(.system(size: 36, weight: .bold, design: .default))
                .foregroundStyle(.black)
                .padding(.top, 8)
            
            //MARK: Loading Spinner
            LoadingSpinner()
                .padding(.top, 44)
                .accessibilityLabel("Loading")
                .accessibilityAddTraits(.updatesFrequently)
            
            
            Spacer()
                .frame(height: 150)
        }
        .padding(.horizontal, 24)
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    SplashView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    SplashView()
        .preferredColorScheme(.dark)
}

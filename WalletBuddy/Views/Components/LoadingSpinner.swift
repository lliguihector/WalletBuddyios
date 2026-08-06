//
//  LoadingSpinner.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/5/26.
//

import SwiftUI

struct LoadingSpinner: View {

    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // Optional faint background track
            Circle()
                .stroke(
                    Color.blue.opacity(0.15),
                    lineWidth: 4
                )

            // Rotating section
            Circle()
                .trim(from: 0.12, to: 0.78)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(rotation))
        }
        .frame(width: 38, height: 38)
        .onAppear {
            rotation = 0

            withAnimation(
                .linear(duration: 0.9)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
        .onDisappear {
            rotation = 0
        }
    }
}

#Preview {
    LoadingSpinner()
}

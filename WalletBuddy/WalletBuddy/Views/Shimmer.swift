//
//  Shimmer.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/16/25.
//

import SwiftUI

import SwiftUI

struct Shimmer: ViewModifier {
    @State private var offset: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let width = geometry.size.width
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white.opacity(0.4), .clear]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: width * 1.5, height: geometry.size.height)
                    .rotationEffect(.degrees(20))
                    .offset(x: width * offset)
                    .blendMode(.screen)
                }
                .clipped()
            )
            .onAppear {
                offset = -1 // reset before animating
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    offset = 1.2
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(Shimmer())
    }
}


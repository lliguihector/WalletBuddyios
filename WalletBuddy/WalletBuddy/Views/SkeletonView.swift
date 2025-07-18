//
//  SkeletonView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/16/25.
//

import SwiftUI

struct SkeletonView: View {
        var body: some View {
            VStack(spacing: 16) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .shimmering()
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .padding(.horizontal)
                    .shimmering()
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .padding(.horizontal)
                    .shimmering()
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 44)
                    .padding(.horizontal)
                    .shimmering()
                Spacer()
            }
            .padding()
            .redacted(reason: .placeholder)
        }
    }

#Preview {
    SkeletonView()
  
}

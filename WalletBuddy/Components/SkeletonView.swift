//
//  SkeletonView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/16/25.
//

import SwiftUI

struct SkeletonView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // -------------------
                // Profile Card Placeholder
                HStack(spacing: 16) {
                    // Circular placeholder for profile image
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .shimmering()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 20)
                            .shimmering()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 16)
                            .shimmering()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 14)
                            .shimmering()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // -------------------
                // Map Placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 250)
                    .shimmering()
                    .padding(.horizontal)
                
                // -------------------
                // Clock In Button Placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 50)
                    .shimmering()
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .redacted(reason: .placeholder)
    }
}


#Preview {
    SkeletonView()
  
}

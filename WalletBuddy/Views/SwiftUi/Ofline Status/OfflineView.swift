//
//  OfflineView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/25/25.
//

import SwiftUI

struct OfflineView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Navigation Header
            HStack {
                Spacer()
                
                HStack(spacing: 8) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    Text("Determit")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    
                }
                
                Spacer()
            }
            .frame(height: 56)
            .padding(.horizontal)
            .background(Color.white)
            .overlay(alignment: .bottom) {
                Divider()
            }
            
            // MARK: - Offline Content
            VStack(spacing: 12) {
                Spacer()
                
                Image(systemName: "icloud.slash")
                    .font(.system(size: 55))
                    .foregroundStyle(.blue)
                
                Text("You're Offline")
                    .font(.title2.bold())
                    .foregroundStyle(.black)
                
                Text(
                    """
                    Some information may not be up to date.
                    We'll reconnect automatically.
                    """
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
                
                Spacer()
            }
            .padding(30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color(red: 0.97, green: 0.96, blue: 0.94)
            )
            
            // MARK: - Footer
                     VStack(spacing: 5) {
                         HStack(spacing: 6) {
                             Circle()
                                 .fill(Color.orange)
                                 .frame(width: 7, height: 7)
                             
                             Text("Waiting for connection")
                                 .font(.caption)
                                 .foregroundStyle(.black)
                         }
                         
                         Text("© 2026 Determit")
                             .font(.caption2)
                             .foregroundStyle(.black)
                     }
                     .frame(maxWidth: .infinity)
                     .padding(.vertical, 14)
                     .background(Color.white)
                     .overlay(alignment: .top) {
                         Divider()
                     }
            
            
            
            
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    OfflineView()
}

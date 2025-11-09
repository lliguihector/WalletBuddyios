//
//  UserCardView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/28/25.
//
import SwiftUI

struct UserCardView: View {
    var imageURL: String?
    var name: String
    var subtitle: String
    var isOnline: Bool
    var userId: String?         // The user ID of this card
    var currentUserId: String?  // The logged-in user's ID
    var onMessageTap: (() -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // MARK: - Card Background + Content
            HStack(alignment: .center, spacing: 16) {
                
            
                // Profile Image
                if let imageURL = imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white) // White icon
                                .background(
                                    Circle()
                                        .fill(Color.secondary) // Gray background
                                        .frame(width: 110, height: 110)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 4) // ✅ Border color and thickness
                                        .frame(width: 110, height: 110)
                                )
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(radius: 1)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(Color.secondary)
                                .frame(width: 110, height: 110)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 4) // ✅ Border for fallback
                                .frame(width: 110, height: 110)
                        )
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .shadow(radius: 1)
                }


                
                // User Info
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // Online Badge
                        Circle()
                            .fill(isOnline ? Color.green : Color.gray)
                            .frame(width: 10, height: 10)
                    }
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            
            // MARK: - Conditional "YOU" or Message Button
            if userId == currentUserId {
                Text("YOU")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary) // subtle system gray that adapts to light/dark mode
                    .offset(x: -10, y: -10)



            } else {
                Button(action: {
                    onMessageTap?()
                }) {
                    Image(systemName: "ellipsis.message")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .padding(10)
                }
                .buttonStyle(PlainButtonStyle())
                .offset(x: -10, y: -10)
            }
        }
    }
}

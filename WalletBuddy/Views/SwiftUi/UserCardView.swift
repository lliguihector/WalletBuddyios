//
//  UserCardView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/28/25.
//
import SwiftUI

    struct UserCardView: View {
        var imageURL: String?
        var uid: String
        var name: String
        var subtitle: String
        var isOnline: Bool
        var userId: String         // The user ID of this card
        var currentUserId: String?  // The logged-in user's ID
        var onMessageTap: (() -> Void)? = nil
        @State private var showChat = false

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
                                fallbackImage
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .shadow(radius: 1)
                    } else {
                        fallbackImage
                    }

                    // User Info
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(name)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            
                            Spacer()
                            
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
                
                // Conditional "YOU" or Message Button
                if userId == currentUserId {
                    Text("YOU")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .offset(x: -10, y: -10)
                } else {
                    Button(action: {
                        showChat = true
                    }) {
                        Image(systemName: "ellipsis.message.fill")
                            .font(.title3)
                            .foregroundColor(.primary)
                            .padding(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .offset(x: -10, y: -10)
                }
            }
            .fullScreenCover(isPresented: $showChat) {
                ChatView(userId: uid, userName: name,imageURL: imageURL, isPresented: $showChat)
            }
        }
        
        // MARK: - Fallback Profile Image
        private var fallbackImage: some View {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit() // keeps the icon fully visible
                .padding(12) // space inside the circle
                .frame(width: 60, height: 60)
                .foregroundColor(.white) // icon color
                .background(
                    Circle()
                        .fill(.tertiary) // gray background
                )
                .clipShape(Circle()) // ensures circular shape
                .shadow(radius: 1)
        }


    }


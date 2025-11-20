//
//  ChatView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 11/9/25.
//
import SwiftUI
import FirebaseAuth
struct ChatView: View {
    let userId: String // User selected id
    let userName: String
    let imageURL: String?
    @Binding var isPresented: Bool

    @StateObject private var socketService = SocketIOService.shared
    @State private var currentMessage = ""

    var body: some View {
        NavigationStack {
            VStack {
                
                // 📩 Messages list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        
                        
                        
                        
                        ForEach(socketService.messages[userId] ?? []) { msg in
                            MessageBubble(
                                text: msg.text,
                                isMe: msg.senderId == Auth.auth().currentUser?.uid
                            )
                        }

                    }
                    .padding(.top, 10)
                }


                // ✏️ Input bar
                HStack {
                    TextField("Message...", text: $currentMessage)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .padding(10)
                    }
                    .disabled(currentMessage.isEmpty)
                }
                .padding()
            }
            .onAppear { socketService.connect() }
            .onDisappear { socketService.disconnect() }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 10) {
                        Button(action: { isPresented = false }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }

                        // Profile image
                        if let imageURL, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable().scaledToFill()
                                } else if phase.error != nil {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        }

                        Text(userName)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }

    private func sendMessage() {
        guard !currentMessage.isEmpty else { return }
        socketService.sendMessage(currentMessage, to: userId)
        currentMessage = ""
    }
}

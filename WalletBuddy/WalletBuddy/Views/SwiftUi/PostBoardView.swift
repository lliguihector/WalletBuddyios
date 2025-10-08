//
//  SettingsView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/21/25.
//

import SwiftUI

struct Message: Identifiable, Equatable {
    let id = UUID()
    let author: String
    let content: String
    let isUser: Bool
    let profileImageURL: String?
    let timestamp: Date
}

@MainActor
class PostBoardViewModel: ObservableObject {
    @Published var messages: [Message] = [
        Message(author: "Alice", content: "Welcome to the group chat!", isUser: false, profileImageURL: nil, timestamp: Date()),
        Message(author: "You", content: "Hey everyone 👋", isUser: true, profileImageURL: "https://i.pravatar.cc/100?img=5", timestamp: Date())
    ]
    
    func addMessage(author: String, content: String, isUser: Bool, profileImageURL: String? = nil) {
        messages.append(Message(author: author, content: content, isUser: isUser, profileImageURL: profileImageURL, timestamp: Date()))
    }
}

struct PostBoardView: View {
    @StateObject private var viewModel = PostBoardViewModel()
    @State private var newMessage = ""
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            HStack(alignment: .bottom, spacing: 8) {
                                if !message.isUser {
                                    ProfileImageView(name: message.author, imageURL: message.profileImageURL)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    if !message.isUser {
                                        Text(message.author)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text(message.content)
                                        .padding(10)
                                        .background(
                                            message.isUser
                                            ? (colorScheme == .dark ? Color.blue.opacity(0.7) : Color.blue)
                                            : (colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2))
                                        )
                                        .foregroundColor(.primary)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    // Timestamp
                                    Text(formatDate(message.timestamp))
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .padding(message.isUser ? .trailing : .leading, 10)
                                }
                                
                                if message.isUser {
                                    ProfileImageView(name: message.author, imageURL: message.profileImageURL)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .onChange(of: viewModel.messages) { _ in
                    withAnimation {
                        if let last = viewModel.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Divider().background(Color.gray)
            
            HStack {
                TextField("Message...", text: $newMessage)
                    .padding(10)
                    .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .focused($isTextFieldFocused)
                    .submitLabel(.send)
                    .onSubmit(sendMessage)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 5)
                .disabled(newMessage.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
            .background(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white)
        }
        .background(colorScheme == .dark ? Color.black : Color(UIColor.systemGroupedBackground))
        .onTapGesture { hideKeyboard() }
        .navigationTitle("Group Chat")
    }
    
    func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.addMessage(author: "You", content: newMessage, isUser: true, profileImageURL: "https://i.pravatar.cc/100?img=5")
        newMessage = ""
        hideKeyboard()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - Profile Image View
struct ProfileImageView: View {
    let name: String
    let imageURL: String?
    
    var body: some View {
        if let urlString = imageURL, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 36, height: 36)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                case .failure:
                    fallbackInitials
                @unknown default:
                    fallbackInitials
                }
            }
        } else {
            fallbackInitials
        }
    }
    
    private var fallbackInitials: some View {
        let initials = name.split(separator: " ").compactMap { $0.first }.prefix(2)
        return Text(initials.map(String.init).joined())
            .font(.caption)
            .fontWeight(.bold)
            .frame(width: 36, height: 36)
            .background(Color.blue.opacity(0.8))
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

// MARK: - Hide Keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

#Preview {
    NavigationView {
        PostBoardView()
            .preferredColorScheme(.light)
    }
}

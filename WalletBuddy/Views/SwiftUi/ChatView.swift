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
    
    //Append with API One on on chat History
    @State private var historyMessages: [Message] = [
        Message(
            text: "Hey, what’s up?",
            senderId: "7zilYhdvgPhAGZheBeRRh2sltVD3",
            delivered: true,
            read: true
        ),
        Message(
            text: "Chilling, you?",
            senderId: "me_001",
            delivered: true,
            read: false
        ),
        Message(
            text: "On my way home right now.",
            senderId: "7zilYhdvgPhAGZheBeRRh2sltVD3",
            delivered: true,
            read: false
        ),
        Message(
            text: "Bet, let me know when you get here.",
            senderId: "me_001",
            delivered: true,
            read: true
        ),
        Message(
            text: "I’m outside.",
            senderId: "7zilYhdvgPhAGZheBeRRh2sltVD3",
            delivered: false,
            read: false
        )
    ]


    var body: some View {
        NavigationStack {
            VStack {
                
                // 📩 Messages list
                
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {

                            ForEach(historyMessages + socketService.newMessage) { msg in
                                MessageBubble(
                                    text: msg.text,
                                    isMe: msg.senderId == Auth.auth().currentUser?.uid
                                )
                                .id(msg.id) // 👈 IMPORTANT
                            }

                        }
                        .padding(.top, 10)
                    }
                    .onChange(of: historyMessages.count) { _ in
                        scrollToBottom(proxy)
                    }
                    .onChange(of: socketService.newMessage.count) { _ in
                        scrollToBottom(proxy)
                    }
                    .onAppear {
                        scrollToBottom(proxy)
                    }
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
            .onTapGesture {
                UIApplication.shared.endEditing()//Close keyboard
            }
            .onAppear { socketService.connect()
            //fetchDMChatHistory()
            }
            .onDisappear { socketService.disconnect()
                socketService.clearMessage()}
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
    
    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            if let last = (historyMessages + socketService.newMessage).last {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }



}


extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}

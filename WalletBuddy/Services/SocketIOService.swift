//
//  Untitled.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 11/12/25.
//
//
//  SocketService.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 11/13/25.
//
import Foundation
import SocketIO
import FirebaseAuth

class SocketIOService: ObservableObject {
    
    static let shared = SocketIOService()
    
    private let currentUserId: String
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    // Store messages per chat (key = other userId or groupId)
    @Published var messages: [String: [Message]] = [:]
    
    private init() {
        self.currentUserId = Auth.auth().currentUser?.uid ?? "unknown"
        
        manager = SocketManager(
            socketURL: URL(string: "https://determitapi-709b9bad1b56.herokuapp.com")!,
            config: [
                .log(true),
                .compress,
                .connectParams(["userId": currentUserId])
            ]
        )
        
        socket = manager.defaultSocket
        setupListeners()
    }
    
    private func setupListeners() {
        // Socket connected
        socket.on(clientEvent: .connect) { _, _ in
            print("✅ Socket Connected")
        }
        
        // Listen for incoming chat messages
        socket.on("chat message") { [weak self] data, _ in
            guard let self = self else { return }
            
            if let dict = data.first as? [String: Any],
               let text = dict["text"] as? String,
               let senderId = dict["senderId"] as? String,
               let receiverId = dict["to"] as? String {
                
                print("📩 Received message from \(senderId): \(text)")
                
                DispatchQueue.main.async {
                    let chatKey = senderId == self.currentUserId ? receiverId : senderId
                    
                    let newMessage = Message(
                        text: text,
                        senderId: senderId,
                        delivered: true,
                        read: senderId != self.currentUserId
                    )
                    
                    // Append to correct chat array
                    self.messages[chatKey, default: []].append(newMessage)
                }
            }
        }
    }
    
    // MARK: - Connection
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    // MARK: - Send message
    func sendMessage(_ text: String, to receiverId: String) {
        guard !text.isEmpty else { return }
        
        let msg = Message(text: text, senderId: currentUserId, delivered: false, read: false)
        
        // Append to correct chat
//        messages[receiverId, default: []].append(msg)
        
        // Emit to server
        let payload: [String: Any] = [
            "text": text,
            "senderId": currentUserId,
            "to": receiverId
        ]
        
        socket.emitWithAck("chat message", payload).timingOut(after: 5) { [weak self] _ in
            guard let self = self else { return }
            
            // Mark delivered
            if let index = self.messages[receiverId]?.firstIndex(where: { $0.id == msg.id }) {
                self.messages[receiverId]?[index].delivered = true
            }
        }
        
        print("✉️ Sending message to \(receiverId): \(text)")
    }
    
    // MARK: - Read receipt
    func markMessageAsRead(_ message: Message, chatKey: String) {
        let payload: [String: Any] = ["messageId": message.id.uuidString]
        socket.emit("message read", payload)
        
        if let index = messages[chatKey]?.firstIndex(where: { $0.id == message.id }) {
            messages[chatKey]?[index].read = true
        }
    }
}

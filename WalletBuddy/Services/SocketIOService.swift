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
//    @Published var messages: [String: [Message]] = [:]
    @Published var newMessage: [Message] = []//Only for messages recieved wile chat is open
    
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
                
             
                
                DispatchQueue.main.async {

                    
                    self.newMessage.append(Message(text: text, senderId: senderId))
                    print("📩 Received message from \(senderId): \(text)")
                    
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
        
        // Create the message locally
        let msg = Message(text: text, senderId: currentUserId, delivered: false, read: false)
        
        // Append locally
//        newMessage.append(msg)
        
        // Payload to send to server
        let payload: [String: Any] = [
            "text": text,
            "senderId": currentUserId,
            "to": receiverId
        ]
        
        // Emit with acknowledgment
        socket.emitWithAck("chat message", payload).timingOut(after: 5) { [weak self] _ in
            guard let self = self else { return }
            
            // Mark delivered once server ACKs
            if let index = self.newMessage.firstIndex(where: { $0.id == msg.id }) {
                self.newMessage[index].delivered = true
                print("✅ Message delivered to \(receiverId): \(text)")
            }
        }
        
        print("✉️ Sending message to \(receiverId): \(text)")
    }

    //Clear in-memory message when leaving chat
    func clearMessage(){
        newMessage.removeAll()
    }
    
    
    
}

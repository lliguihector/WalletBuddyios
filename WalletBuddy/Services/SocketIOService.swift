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

import SocketIO
import FirebaseAuth
import SocketIO
import FirebaseAuth

class SocketIOService: ObservableObject {
    
    static let shared = SocketIOService()
    
    public var manager: SocketManager!
    public var socket: SocketIOClient!
    
    @Published var messages: [Message] = []
    
    private var currentUserId: String
    
    private init() {
        self.currentUserId = Auth.auth().currentUser?.uid ?? "unknown"
        
        // Connect to Node server
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
            print("Socket Connected")
        }
        
        // Listen for chat messages
        socket.on("chat message") { [weak self] data, _ in
            guard let self = self else { return }
            
            if let dict = data.first as? [String: Any],
               let text = dict["text"] as? String,
               let senderId = dict["senderId"] as? String {
                
                DispatchQueue.main.async {
                    // Only append if not already in the messages
                    // This prevents double bubbles
                    if senderId != self.currentUserId {
                        self.messages.append(Message(text: text, senderId: senderId))
                    }
                }
            }
        }
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func sendMessage(_ text: String) {
        guard !text.isEmpty else { return }
        
        let msg = Message(text: text, senderId: currentUserId)
        
        // Append immediately to show locally
        messages.append(msg)
        
        // Send to server
        let payload: [String: Any] = [
            "text": text,
            "senderId": currentUserId
        ]
        socket.emit("chat message", payload)
    }
}

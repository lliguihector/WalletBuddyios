//
//  NetworkMonitor.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/25/25.
//
import Network
import Combine


@MainActor
class NetworkMonitor: ObservableObject {
            
    static let shared = NetworkMonitor()
    
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    @Published private(set) var isConnected: Bool = true
    
    private init() {
        
        monitor.pathUpdateHandler = {[weak self] path in
            
            DispatchQueue.main.async{
                self?.isConnected = path.status == .satisfied
            }
            
        }
        
        monitor.start(queue: queue)
    
    }
    
    
    
    
    
}

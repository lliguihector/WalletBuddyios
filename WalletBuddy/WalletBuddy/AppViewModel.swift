//
//  AppViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//

import SwiftUI
import FirebaseAuth

enum AppSate{
    
    case loggedOut
    case loadingSkeleton
    case loggedIn
    
}

@MainActor
class AppViewModel: ObservableObject {
    
    
    @Published var state: AppSate = .loggedOut
    
    
    func handleLoginSuccess(user: User){
        
        state = .loadingSkeleton
        
        Task{
            try? await Task.sleep(for: .seconds(2))
            
            state = .loggedIn
        }

    }
    
    
    func logout(){
        
        
    }
    
    
    
}

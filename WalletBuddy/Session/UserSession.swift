//
//  UserViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/2/25.
//
import Foundation
import SwiftUI
import UIKit   // Needed for UIImage

@MainActor
class UserSession: ObservableObject {
    @Published private(set) var user: AppUser?
    @Published var profileImage: UIImage?   // Cached image
    
    
    
    
    
    init(){}
    
    //Stores currently logged in user information inside UserSession and loads their profile image
    func setUser(_ user: AppUser) {
        self.user = user
        Task { await loadProfileImage() }
    }
    
    
//Removes stored user information and carched profile image from memory
    func clear() {
        self.user = nil
        profileImage = nil
    }
    
    private func loadProfileImage() async {
        guard let urlString = self.user?.profileImageUrl,
              let url = URL(string: urlString) else {
            profileImage = nil
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                profileImage = image
            } else {
                profileImage = nil
            }
        } catch {
            print("❌ Failed to load profile image:", error)
            profileImage = nil
        }
    }
}

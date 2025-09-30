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
class UserViewModel: ObservableObject {
    @Published var appUser: AppUser?
    @Published var profileImage: UIImage?   // Cached image
    
    static let shared = UserViewModel()
    private init(){}
    
    func updateUser(_ user: AppUser) {
        appUser = user
        Task { await loadProfileImage() }
    }
    
    func clearUser() {
        appUser = nil
        profileImage = nil
    }
    
    private func loadProfileImage() async {
        guard let urlString = appUser?.profileImageUrl,
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

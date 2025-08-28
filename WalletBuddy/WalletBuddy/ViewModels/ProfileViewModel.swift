//
//  Profile.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/20/25.
//
import SwiftUI


@MainActor
class ProfileViewModel: ObservableObject {
    @Published var data: ProfileData
    
    
    init(appUser: AppUser) {
        self.data = ProfileData(appUser: appUser)
    }
    
    
    
    //Saves data to back end 
    func completeOnboarding(token: String)async {
        
        do{
          
//            try await ApiService.shared.updateUserProfile(firstName: data.firstName, lastName: data.lastName, profileCompleted: true, token: token)
            print("User profile updated")
        }catch{
            print("Failed to update profile: \(error)")
        }
            
    }
    
    
    
    
}

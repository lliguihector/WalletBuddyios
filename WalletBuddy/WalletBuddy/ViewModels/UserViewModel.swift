//
//  UserViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/2/25.
//
import Foundation
import SwiftUI
@MainActor
class UserViewModel:ObservableObject {
    @Published var appUser:AppUser?
    
    
    static let shared = UserViewModel()
    
    private init(){}
    
    
    //Set the user
    func updateUser(_ user: AppUser){
        appUser = user
    }
 
    func clearUser(){
        appUser = nil
    }

    
}

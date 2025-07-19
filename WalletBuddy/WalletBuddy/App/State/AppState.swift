//
//  AppState.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/19/25.
//
import FirebaseAuth


enum AppState {
    case loggedOut
    case loadingSkeleton
    case loggedIn(AppUser)
}


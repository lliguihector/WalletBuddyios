//
//  RootView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//
import SwiftUI

struct RootView: View {
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        switch appViewModel.state {
        case .loggedOut:
            Text("Logged Out")
        case .loadingSkeleton:
            SkeletonView()
        case .loggedIn(let user):
            MainView(user: user)
            
        }
    }
}

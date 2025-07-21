//
//  MyApp.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/20/25.
//

import SwiftUI
import Firebase

@main
struct MyApp: App {

    @StateObject private var appViewModel = AppViewModel.shared
    @StateObject private var navigationRouter = NavigationRouter.shared

    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
            WindowGroup{
                NavigationStack(path: $navigationRouter.path){
                    RootView()
                        .environmentObject(appViewModel)
                        .environmentObject(navigationRouter)
                        .navigationDestination(for: AppRoute.self){ route in
                            route.view
                        }
                }
            }
    }
}

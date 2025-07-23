//
//  MyApp.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/20/25.
//

import SwiftUI
import Firebase
//App Entry Point
@main
struct MyApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel.shared
    @StateObject private var navigationRouter = NavigationRouter.shared


    
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

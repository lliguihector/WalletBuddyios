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

    
    
    //Inject Managed Object Context into SwiftUI
    
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel.shared
    @StateObject private var navigationRouter = NavigationRouter.shared


    
    var body: some Scene {
            WindowGroup{
                NavigationStack(path: $navigationRouter.path){
                    RootView()
                        .environment(\.managedObjectContext,persistenceController.container.viewContext)
                        .environmentObject(appViewModel)
                        .environmentObject(navigationRouter)
                        .navigationDestination(for: AppRoute.self){ route in
                            route.view
                        }
                }
            }
    }
}

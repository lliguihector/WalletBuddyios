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
    
    //@ObserevedObject hears the change notification of @Publish
    @StateObject private var appViewModel = AppViewModel.shared
    @StateObject private var navigationRouter = NavigationRouter.shared
    @StateObject private var networkMonitor = NetworkMonitor.shared


    
    var body: some Scene {
            WindowGroup{
                NavigationStack(path: $navigationRouter.path){
                    RootView()//Entry Point View
                        .environment(\.managedObjectContext,persistenceController.container.viewContext)
                        .environmentObject(appViewModel)
                        .environmentObject(navigationRouter)
                        .environmentObject(networkMonitor)
                        .navigationDestination(for: AppRoute.self){ route in
                            route.view
                        }
                        .task{
                            appViewModel.initializeSession()
                        }
                }
            }
    }
}

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
    @ObservedObject private var appViewModel = AppViewModel.shared
    @ObservedObject private var navigationRouter = NavigationRouter.shared


    
    var body: some Scene {
            WindowGroup{
                NavigationStack(path: $navigationRouter.path){
                    RootView()//Entry Point View
                        .environment(\.managedObjectContext,persistenceController.container.viewContext)
                        .environmentObject(appViewModel)
                        .environmentObject(navigationRouter)
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

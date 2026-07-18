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
   

//MARK: -- Init Firebase
  
    
    var body: some Scene {
            WindowGroup{
                    RootView()//Entry Point View
                        .environment(\.managedObjectContext,persistenceController.container.viewContext)
                        .environmentObject(appViewModel)
                        .environmentObject(navigationRouter)
                        .environmentObject(networkMonitor)
                    
                        .task{
//                            Initializing Firebase (if needed)
//                            Checking whether a user is signed in
//                            Refreshing the Firebase ID token
//                            Loading the user from your API
//                            Deciding whether to show onboarding, login, or the main app
                            await appViewModel.initializeSession()
                        }

            }
    }
    
    
    


}

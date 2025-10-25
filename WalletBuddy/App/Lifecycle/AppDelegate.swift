//
//  AppDelegate.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 6/7/25.
//

import UIKit
import Firebase
import GoogleSignIn


class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Initializes and configures Firebase services for the app.
        FirebaseApp.configure()
        

        
    
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    
    // Handles URL callbacks from Google Sign-In to complete the authentication flow.
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
//        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
        print("Terminating Application ... ")
    }

    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map {String(format:"%02.2hhx", $0)}
        let tokenString = tokenParts.joined()
        
        let savedToken = DeviceManager.shared.currentToken
        
        //Only upload if token changed
        if savedToken !=  tokenString{
            print("APNs token changed or new - uploaded backend...")
                DeviceManager.shared.saveToken(tokenString)
                DeviceManager.shared.registerDeviceWithBackend(token: tokenString)
        }else{
            print("APNs token unchanged, no backed update needed.")
        }
     
  print("From AppDelegate APNs token is = \(tokenString)")
  
    }

    
    private func application(_ application: UIApplication, didFailedToRegisterFromRemoteNotificationsWithError error: Error){
        print("Failed to register for remote notifications: \(error)")
    }
}


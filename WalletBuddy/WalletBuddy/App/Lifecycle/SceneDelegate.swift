//
//  SceneDelegate.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 6/7/25.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.backgroundColor = UIColor.systemBackground
        
        
        //Bridge SwiftUI View inside UIKit
        let rootSwiftUIView = LoginOptionsView()
        let hostingController = UIHostingController(rootView: rootSwiftUIView)
        hostingController.view.backgroundColor = UIColor.systemBackground

        navigationAppearance()
        
        
        //Embed Swift UI View in UIKitNavigation controller
        let navController = UINavigationController(rootViewController: hostingController)
        navController.view.backgroundColor = .systemBackground
        navController.view.isOpaque = true
        navController.modalPresentationCapturesStatusBarAppearance = true
    
        
        //Set initial view entry point 
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

      

     
    }
    
    
    //Global Apperance For Navigation Controller
func navigationAppearance(){
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    //Set Background and title color
      appearance.backgroundColor = UIColor.systemBackground  // 👈 Background color
      appearance.titleTextAttributes = [.foregroundColor: UIColor.black] //👈 Text Color
    
    //Remove back Button title
      appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]//Removes the title from the navigation bar back button

    //Remove bottom shadow/border
    appearance.shadowColor = .clear
    appearance.shadowImage = UIImage()//Optional fallback for older ios
    
    
    //Apply globally
      let navBar = UINavigationBar.appearance()
      navBar.standardAppearance = appearance
      navBar.scrollEdgeAppearance = appearance
      navBar.compactAppearance = appearance
      navBar.tintColor = .black //Color for back button
}
    
    func loginNC() -> UINavigationController {
        let logInVC = LoginVC()
        let navController = UINavigationController(rootViewController: logInVC)
        return navController
    }
    
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


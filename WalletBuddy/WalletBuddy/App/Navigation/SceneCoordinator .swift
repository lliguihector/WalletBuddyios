//
//  SceneCoordinator.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/25/25.
//
import SwiftUI
import UIKit

final class SceneCoordinator {
    
    static let shared = SceneCoordinator()
    private init() {}

    private(set) var window: UIWindow?

    @MainActor func setRoot<Content: View>(_ view: Content) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("❌ No active UIWindowScene found.")
            return
        }

        let rootView = view
            .environmentObject(AppViewModel.shared)
            .environmentObject(NavigationRouter.shared)

        let hostingVC = UIHostingController(rootView: rootView)

        let window = UIWindow(windowScene: scene)
        window.rootViewController = hostingVC
        window.makeKeyAndVisible()
        self.window = window
    }
}


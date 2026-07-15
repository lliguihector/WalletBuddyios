//
//  Untitled.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/16/25.
//
//
//  UIViewController+LoadingSpinner.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/16/25.
//
import UIKit
import SwiftUI

final class SpinnerManager {
    static let shared = SpinnerManager()
    
    private var spinnerWindow: UIWindow?

    private init() {}

    func show() {
        guard spinnerWindow == nil else { return }

        // 🪄 Get the active UIWindowScene
        guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            print("⚠️ No active window scene found")
            return
        }

        let window = UIWindow(windowScene: windowScene)
        window.frame = UIScreen.main.bounds

      
                let hostingController = UIHostingController(rootView: LoadingSpinnerView())
                hostingController.view.backgroundColor = .clear
        

        window.rootViewController = hostingController
        window.windowLevel = .alert + 1
        window.makeKeyAndVisible()

        spinnerWindow = window
        print("✅ Show Spinner")
    }

    func hide() {
        spinnerWindow?.isHidden = true
        spinnerWindow = nil
        print("❌  Hide Spinner")
    }
}

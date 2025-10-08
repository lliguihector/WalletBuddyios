import SwiftUI
import UIKit
import Foundation


struct LogInVCWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let loginVC = LoginVC()
        let nav = UINavigationController(rootViewController: loginVC)
        return nav
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Nothing needed
    }
}

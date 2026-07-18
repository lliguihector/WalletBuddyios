import SwiftUI
import UIKit
import Foundation


struct LogInVCWrapper: UIViewControllerRepresentable {
    
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    
    func makeUIViewController(context: Context) -> LoginVC {
        
        LoginVC(
            
            appViewModel: appViewModel,
            navigationRouter: navigationRouter
        )
  
    }

    func updateUIViewController(_ uiViewController: LoginVC, context: Context) {
        // Nothing needed
    }
}


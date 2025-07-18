import SwiftUI
import UIKit


struct LogInVCWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoginVC {
        
        return LoginVC()
    }
    
    
    func updateUIViewController(_ uiViewController: LoginVC, context: Context) {
        //Nothing Neede here for now 
    }
    
    
}

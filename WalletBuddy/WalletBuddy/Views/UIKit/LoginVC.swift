//
//  ViewController.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 6/7/25.
//

import UIKit
import SwiftUI

class LoginVC: UIViewController {

  
    var appWindow: UIWindow?
    
    let logoImageView = UIImageView()
    let usernameTextField = WBTextField(type: .username, iconName: "person")
    let passwordTextField = WBTextField(type: .password, iconName: "lock")
    let signInButton =  WBButton(backgroundColor: .systemGreen, title: "Sign In")

    let viewModel = LoginViewModel()
   
    
    
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .systemBackground
      
        
        
        //Accessibility Identifier for UITest
        usernameTextField.accessibilityIdentifier = "usernameTextField"
        passwordTextField.accessibilityIdentifier = "passwordTextField"
        signInButton.accessibilityIdentifier = "signInButton"
        
        
        //Delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        //UI Configurations
        configureLogoImageView()
        configureUserNameTextField()
        configurePasswordTextField()
        createDismissKeyboardTapGesture()
        configureSignInButton()
        
        
        //Set text fields for testing
        usernameTextField.text = "lliguichuzcah@gmail.com"
        passwordTextField.text = "poli09"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layer.removeAllAnimations()
    }

    
//MARK: -- UI Configurations
    
    //Logo Image Placement
    func configureLogoImageView(){
            view.addSubview(logoImageView)
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            logoImageView.image = UIImage(named: "robot")
            NSLayoutConstraint.activate([
                logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
                logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoImageView.heightAnchor.constraint(equalToConstant: 200),
                logoImageView.widthAnchor.constraint(equalToConstant: 200)
            ])}
    //Username TextField Placement
    func configureUserNameTextField(){
        view.addSubview(usernameTextField)
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 18),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])}
    //Password Text Field Placement
    func configurePasswordTextField(){
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ]) }
    //Sign In Button Placement
    func configureSignInButton(){
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(loginWithFirebaseAuth), for: .touchUpInside)
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])}
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    
    @objc func loginWithFirebaseAuth(){
        
      //Show Spinner
        SpinnerManager.shared.show()
        Task{
            
            
            //delays task for 2sec for testing loading spinner 
//            try? await Task.sleep(nanoseconds: 2_000_000_000)
            let result = await viewModel.login(email: usernameTextField.text, password: passwordTextField.text)
            
            
            //Hide spinner
            SpinnerManager.shared.hide()
            
            switch result{
            case .success(let user):
                showAlert(title: "Success ", message: "User \(user) Logged in.")
                
                
                AppViewModel.shared.handleLoginSuccess(user: user)
              
                
                let rootView = RootView(appViewModel: AppViewModel.shared)
                let hostingVC = UIHostingController(rootView: rootView)
                
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let window = UIWindow(windowScene: scene)
                    window.rootViewController = hostingVC
                    window.makeKeyAndVisible()
                    self.appWindow  = window
                }
                
                
            case .failure(let message):
                showAlert(title: "Error", message: message)
            }
            
            
            
        }
        
    }
//MARK: -- UI METHODS
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    //Spinner Handling
    
    
    
    
    
    
}










extension LoginVC: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginWithFirebaseAuth()
        }
        
        return true
    }
    
}

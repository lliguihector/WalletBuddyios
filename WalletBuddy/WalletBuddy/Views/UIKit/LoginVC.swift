//
//  LoginVC.swift
//  WalletBuddy
//

import UIKit
import SwiftUI
import Firebase
import Foundation

class LoginVC: UIViewController {

    private lazy var viewModel = LoginViewModel()
    
    let loginLabel = UILabel()
    
    let usernameLabel = WBLabel(title: "Email")
    let usernameTextField = WBTextField(type: .username, iconName: "person")
    
    let passwordLabel = WBLabel(title: "Password")
    let passwordTextField = WBTextField(type: .password, iconName: "lock")
    let showPasswordButton = UIButton(type: .system)
    
    let errorLabel = UILabel()
    
    let signInButton = WBButton(backgroundColor: .systemBlue, title: "Sign In")
    
    let forgotPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Forgot Password?", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Accessibility
        usernameTextField.accessibilityIdentifier = "usernameTextField"
        passwordTextField.accessibilityIdentifier = "passwordTextField"
        signInButton.accessibilityIdentifier = "signInButton"
        
        // Delegates
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Configure UI
        configureLoginLabel()
        configureUsernameField()
        configurePasswordField()
        configureShowPasswordButton()
        configureErrorLabel()
        configureForgotPasswordButton()
        configureSignInButton()
        createDismissKeyboardTapGesture()
        
        // Pre-fill for testing
        usernameTextField.text = "lliguichuzcah@gmail.com"
        passwordTextField.text = "poli09"
        
        // Back button
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(backToLoginOptions)
        )
        backButton.title = "Back"
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - UI Configurations
    
    func configureLoginLabel() {
        view.addSubview(loginLabel)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.text = "Log In"
        loginLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        loginLabel.textColor = .label
        loginLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureUsernameField() {
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 32),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configurePasswordField() {
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureShowPasswordButton() {
        view.addSubview(showPasswordButton)
        
        let eyeClosed = UIImage(systemName: "eye.slash")
        showPasswordButton.setImage(eyeClosed, for: .normal)
        showPasswordButton.tintColor = .systemGray
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showPasswordButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            showPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -8),
            showPasswordButton.widthAnchor.constraint(equalToConstant: 30),
            showPasswordButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configureErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .systemRed
        errorLabel.font = .systemFont(ofSize: 14)
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func configureForgotPasswordButton() {
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            forgotPasswordButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 8),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func configureSignInButton() {
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(loginWithFirebaseAuth), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 24),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeImageName = passwordTextField.isSecureTextEntry ? "eye-slash" : "eye"
        showPasswordButton.setImage(UIImage(systemName: eyeImageName), for: .normal)
    }
    
    

    
    @objc func forgotPasswordTapped() {
        // TODO: Show forgot password screen or alert
        print("Forgot password tapped")
    }
    
    @objc func backToLoginOptions() {
        NavigationRouter.shared.popToRoot()
        AppViewModel.shared.state = .loggedOut
    }
    
    @objc func loginWithFirebaseAuth() {
        errorLabel.isHidden = true
        SpinnerManager.shared.show()
        
        Task {
            let result = await viewModel.login(email: usernameTextField.text, password: passwordTextField.text)
            SpinnerManager.shared.hide()
            
            switch result {
            case .success:
                AppViewModel.shared.state = .loadingSkeleton
                await AppViewModel.shared.handleLoginSuccess(forecRefresh: true)
            case .failure(let message):
                errorLabel.text = message
                errorLabel.isHidden = false
            }
        }
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginWithFirebaseAuth()
        }
        return true
    }
}

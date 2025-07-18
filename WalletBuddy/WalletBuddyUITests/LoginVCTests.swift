//
//  LoginVCTests.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/14/25.
//
import XCTest

final class LoginVCTests: XCTestCase {
    
let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    
    func testLoginScreenAppears(){
        
        XCTAssert(app.textFields["usernameTextField"].exists)
        XCTAssert(app.secureTextFields["passwordTextField"].exists)
        XCTAssert(app.buttons["signInButton"].exists)
        
    }
    
    
    func testLoginButtonTap(){
        let username = app.textFields["usernameTextField"]
        let password = app.secureTextFields["passwordTextField"]
        let loginButton = app.buttons["signInButton"]
        
        username.tap()
        username.typeText("test@example.com")
        
        
        
        password.tap()
        password.typeText("test1234")
        
        loginButton.tap()
        
    }
    
    
    
}


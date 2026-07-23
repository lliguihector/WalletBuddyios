//
//  Constants.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/1/25.
//
import Foundation

struct Constants {
    static let appName = "WalletBuddy"
    
    
    static let apiBaseURL = "https://determitapi-709b9bad1b56.herokuapp.com"
//    static let apiBaseURL = "http://localhost:3000"
    
    //MARK: LOGIN/LOGOUT/STATE
static let checkInOrCreateEndPoint = "\(apiBaseURL)/user/check-or-create"
static let registerAdmin = "\(apiBaseURL)/user/auth/register-admin"

    //MARK: -- EMPLOYEE
    //CHEKIN
    static let checkInEndPoint = "\(apiBaseURL)/checkin/checkin"
    //CHECKOUT
    static let checkOutEndPoint = "\(apiBaseURL)/checkin/checkout"
    //GET EMPLOYEE RECENT CHECKIN
    static let getRecentCheckInEndPoint = "\(apiBaseURL)/checkin/lastCheckin"
    //GET ALL EMPLOYEES ON SITE
    static let getAllEmployeesOnSiteEndPoint = "\(apiBaseURL)/checkin/checkedin"

    
    //CHECKIN
   
    
    //HEROKU
    
    
    
    
    
    
    
    
    
    
    
    //EndPoints
//    static let checkOrCreateUserEndpoint = "\(apiBaseURL)/check-or-create"
    static let completeProfileEndpoint = "http://localhost:3000/user/"
    
}

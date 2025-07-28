//
//  APIService.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/28/25.
//

final class ApiService {
            
    static let shared = ApiService()
    
    private init() {}
    
    
    
    func verifyUser(with_ token: String) -> Bool{
        
        
        print("this is the firebase Token:\(token)")
        
        //TO DO: Send token to api
        return false 
    }
    
    
    
    func updateUserData(token: String,userData: AppUser)
    {
        
        
        
    }
    
}

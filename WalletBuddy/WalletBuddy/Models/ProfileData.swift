//
//  ProfileData.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/20/25.
//
struct ProfileData{
    
    var firstName: String  = ""
    var lastName: String = ""
    //Other Fields 
    
    init(appUser:AppUser){
        self.firstName = appUser.firstName
        self.lastName = appUser.lastName 

    }
    

    
}

//
//  CreateOrganizationRequest.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/12/26.
//

struct CreateOrganizationRequest: Encodable{
    
    let name: String
    let industry: String
    let email: String
    let phone: String
    let website: String?
    
  
    
}

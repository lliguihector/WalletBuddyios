//
//  AppRoute.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/21/25.
//
import SwiftUI
enum AppRoute: Hashable{
    
   

    case loginEmail
    
    
@ViewBuilder
    var view: some View{
        switch self{
        case .loginEmail:
            LogInVCWrapper()
        
        }
    }
    
    
}

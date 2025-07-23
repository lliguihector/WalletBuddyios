//
//  NavigationRouter.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/21/25.
//
import SwiftUI

class NavigationRouter: ObservableObject{
    
    static let shared = NavigationRouter()
    @Published var path: [AppRoute] = []
    
    
    
    func push (_ route: AppRoute){
        
        path.append(route)
    }
    
    
    
    func pop(){
        
        if !path.isEmpty{
            path.removeLast()
        }
    }
    
    
    func popToRoot(){
        
        path.removeAll()
    }
    
    
    func replace(with route: AppRoute){
        
        path = [route]
    }
    
    
    
}

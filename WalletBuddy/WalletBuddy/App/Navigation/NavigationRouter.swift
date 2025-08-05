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
        
        print("Navigation Stack: \(path.count)")
       
    }

    func pop(){
        if !path.isEmpty{
            path.removeLast()
        }
        print("Navigation Stack: \(path.count)")
        print("Array: \(path)")
    }
    
    func popToRoot(){
        path.removeAll()
        print("Navigation Stack: \(path.count)")
        print("Array: \(path)")
    }
    
    func replace(with route: AppRoute){
        path = [route]
    }

    
    
    
}

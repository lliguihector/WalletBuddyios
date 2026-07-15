//
//  Login.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/14/26.
//

import SwiftUI


struct LoginView: View {
    
    
    
    @State private var firstName: String = ""
    
    
    var body: some View {
        
        
        
        VStack(spacing: 20){
            
            Text("Welcome back!")
                .font(.system(size:32, weight: .bold))
                .padding(.top, 40)
            
            VStack(spacing: 20) {
                CustomTextField(
                    title: "First Name",
                    text: $firstName,
                    systemImage: "person"
                )
                
                
            }
          
            
            
            
            
            
        }
    }
}


#Preview {
    LoginView()
}

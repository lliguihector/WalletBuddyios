//
//  Untitled.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/14/26.
//

import SwiftUI

struct CreateAdminAccountView: View {
    
    

    @EnvironmentObject var onboardingVM: AdminOnboardingViewModel

    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    
    var body: some View {

        
    
 
            ScrollView {
                
                VStack(alignment: .leading, spacing: 28) {
                    
                    // MARK: Progress Bar
                    ProgressView(value: Double(1), total: Double(6))
                        .progressViewStyle(.linear)
                        .tint(.blue)
                    
                    // MARK: Header
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Create your administrator account")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Let's get your organization started.")
                            .foregroundStyle(.secondary)
                    }
                    
                    // MARK: Form
                    
                    VStack(spacing: 18) {
                        
                        CustomTextField(
                            title: "First Name",
                            text: $onboardingVM.firstName,
                            systemImage: "person"
                        )
                        
                        CustomTextField(
                            title: "Last Name",
                            text: $onboardingVM.lastName,
                            systemImage: "person"
                        )
                        
                        CustomTextField(
                            title: "Work Email",
                            text: $onboardingVM.email,
                            keyboard: .emailAddress,
                            systemImage: "envelope"
                        )
                        
                        PasswordField(
                            title: "Password",
                            text: $onboardingVM.password,
                            isVisible: $showPassword
                        )
                        
                        PasswordField(
                            title: "Confirm Password",
                            text: $onboardingVM.confirmPassword,
                            isVisible: $showConfirmPassword
                        )
                    }
                    
                    Button {
                        
                        // TODO:
                        // Validate
                        // Call API
                        // Navigate to Verify Email
                  
                        
                    } label: {
                        
                        Text("Continue")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.top)
                    
                }
                .padding(24)
            }
            
        
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.black)
        
    }
}

//#Preview {
//    NavigationStack {
//        CreateAdminAccountView()
//    }
//}

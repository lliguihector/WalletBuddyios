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
    
    
    enum Field{
        case firstName
        case lastName
        case email
        case password
        case confirmPassword
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {

        ZStack{
  
            ScrollView {

                VStack(alignment: .leading, spacing: 28) {
                    
            
                    // MARK: Header
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Create your account")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Enter your information to create your administrator account.")
                            .foregroundStyle(.secondary)
                    }
                    
                    // MARK: Form
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            CustomTextField(
                                title: "First Name",
                                text: $onboardingVM.firstName,
                                systemImage: "person"
                            )
                            .focused($focusedField, equals: .firstName)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .lastName
                            }
                            if let error = onboardingVM.firstNameError{
                                Label(error, systemImage: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.red)
            
                            }
                            
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                        CustomTextField(
                            title: "Last Name",
                            text: $onboardingVM.lastName,
                            systemImage: "person"
                        )
                        .focused($focusedField, equals: .lastName)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .email
                            }
                            if let error = onboardingVM.lastNameError{
                                Label(error, systemImage: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                
                            }
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                        CustomTextField(
                            title: "Work Email",
                            text: $onboardingVM.email,
                            keyboard: .emailAddress,
                            systemImage: "envelope"
                        )
                        .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .password
                            }
                            if let error = onboardingVM.emailError{
                                Label(error, systemImage: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            PasswordField(
                                title: "Password",
                                text: $onboardingVM.password,
                                isVisible: $showPassword
                            )
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .confirmPassword
                            }
                            if let error = onboardingVM.passwordError{
                                Label(error, systemImage: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                
                            }}
                        
                        VStack(alignment: .leading, spacing: 4) {
                            PasswordField(
                                title: "Confirm Password",
                                text: $onboardingVM.confirmPassword,
                                isVisible: $showConfirmPassword
                            )
                            .focused($focusedField, equals: .confirmPassword)
                            .submitLabel(.done)
                            .onSubmit {
                                focusedField = nil
                            }
                            if let error = onboardingVM.confirmPasswordError{
                                
                                Label(error, systemImage: "exclamationmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                
                            }}
                        
                    }
                    
                    Button {
             
                        Task {
                            
                            await onboardingVM.createFireBaseUser()
                            // Navigate to Verify Email
                        }
                        
                    } label: {
                        
                        Text("Continue")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.top,8)
                    
                }
                .padding(24)
            }
            .onTapGesture {
                focusedField = nil
            }
            
            //Disable Back ground and loading spinner
            if onboardingVM.isLoading{
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                
                ProgressView()
                    .scaleEffect(1.5)
                    .padding(30)
                    .background(.black)
                    .tint(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }

        }
        //Navigation Style
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    
                    Text("Step \(onboardingVM.currentStep) of \(onboardingVM.totalSteps)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    ProgressView(
                        value: Double(onboardingVM.currentStep),
                        total: Double(onboardingVM.totalSteps)
                    )
                    .progressViewStyle(.linear)
                    .frame(width: 160)
                    .tint(.blue)
                }
            }
        }
        .tint(.black)
        
    }
}


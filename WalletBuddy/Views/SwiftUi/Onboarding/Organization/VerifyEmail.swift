//
//  Verify Email.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/15/26.
//
import SwiftUI

struct VerifyEmail: View {
    
    @EnvironmentObject var onboardingVM: AdminOnboardingViewModel
    @EnvironmentObject var appViewModel: AppViewModel

    
    @State private var navigateToOrganization = false

    var body: some View {
        
        ZStack{
            
        VStack(spacing: 28) {
            
   
            //ICON
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.08))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(Color.blue, lineWidth: 3)
                    )
                
                Image(systemName: "envelope.open")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)
            }
            .padding(.top, 40)
            Text("Verify Your Email")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Description
            VStack(spacing: 12) {
                
                Text("We've sent a verification link to")
                    .foregroundStyle(.secondary)
                
                Text(appViewModel.userSession.user?.email ?? "No Email Found"
                )
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Text("Please check your inbox and click the link to verify your email address.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
            
            //MARK: Verify Button
            Button{
                //TODO: Refresh Firebase user and check if email is verified
                
                
                Task {
                    
                    
                    await onboardingVM.verifyEmail()
             
                  //Set true
                    navigateToOrganization = true
                    
               
                }
                
                
            }label:{
                Text("VERIFY")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
      //MARK: Resend Email
            Button{
                
                //TODO: RESEND Verification email
                Task{
                    await onboardingVM.resendEmailVerification()
                }
                
            }label:{
                Text("Resend verification email")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
            
            
            Spacer()
        }
            
            
        .padding()
        .disabled(onboardingVM.isLoading)
            
            
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
        //MARK: Navigate to Next
        .navigationDestination(isPresented: $navigateToOrganization) {
            SetDetails()
                .environmentObject(onboardingVM)
                .environmentObject(appViewModel)
         
        }
        
        

        //Navigation Style
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    
                    Text("Step \(2) of \(6)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    ProgressView(
                        value: Double(2),
                        total: Double(6)
                    )
                    .progressViewStyle(.linear)
                    .frame(width: 160)
                    .tint(.blue)
                }
            }}
        
        .alert(onboardingVM.alertTitle,
               isPresented: $onboardingVM.showAlert) {
            
            Button("OK", role: .cancel) {
                
            }
            
        } message: {
            Text(onboardingVM.errorMessage ?? "Something went wrong.")
        }
        
    }
}





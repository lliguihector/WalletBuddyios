//
//  AdminOnboardingViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/20/26.
//
import SwiftUI



@MainActor
class AdminOnboardingViewModel: ObservableObject{
    
    
    //Progress
    @Published var currentStep = 1
    let  totalSteps = 6.0
    
    //Account info
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    
    //Organization info
    
    
    func completeOnboarding(){
        
        //Call API
        //Uodate backend onboardingStatus = Complete
    }
    
    
    
}

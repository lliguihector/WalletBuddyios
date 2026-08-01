    //
    //  Organi.swift
    //  WalletBuddy
    //
    //  Created by Hector Lliguichuzca on 7/31/26.
    //


    import SwiftUI
    struct OrganizationInputView: View {

        @EnvironmentObject var onboardingVM: AdminOnboardingViewModel
        @EnvironmentObject var appViewModel: AppViewModel

        
            //MARK: Piker List
        
        private let industries = [
            "Construction",
            "Education",
            "Finance",
            "Government",
            "Healthcare",
            "Hospitality",
            "Information Technology",
            "Manufacturing",
            "Retail",
            "Transportation",
            "Utilities",
            "Other"
        ]
        
        //MARK: TextField
        enum Field:Hashable{
            case organizationName
            case industry
            case businessEmail
            case businessPhoneNumber
            case businessWebsiteUrl

        }
        
        @FocusState private var focusedField: Field?
        
        var body: some View {
           
            
            ZStack{
                
                ScrollView{
                    
                    VStack(alignment: .leading, spacing: 28){
                        
                        
                        //MARK: Heaader
                        VStack(alignment: .leading, spacing: 8){
                            Text("Tell us about your 0rganization")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("The information helps us set up your workspace.")
                                .foregroundStyle(.secondary)
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            
                            //MARK: Organization Name
                            VStack(alignment: .leading, spacing: 4) {
                                CustomTextField(title: "Organization Name",
                                    text: $onboardingVM.organizationName,
                                    systemImage: "building.2")
                                    .focused($focusedField, equals: .organizationName)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        focusedField = .businessEmail
                                    }
                                    if let error = onboardingVM.organizationNameError{
                                        Label(error, systemImage: "exclamationmark.circle.fill")
                                            .font(.caption)
                                            .foregroundStyle(.red)
                                    }
                            }
                            
                        
                            
                            
                            //MARK: Organization Inadustry Piker
                            VStack(alignment: .leading, spacing: 4) {

                                Picker("Select Industry", selection: $onboardingVM.industry) {
                                    Text("Select Industry")
                                        .tag("")
                                    ForEach(industries, id: \.self) { industry in
                                        Text(industry)
                                            .tag(industry)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.tertiarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.secondary.opacity(0.7), lineWidth: 1)
                                    
                                )
                            }
                            

                            //MARK: - Business Email
                            VStack(alignment: .leading, spacing: 4) {
                            CustomTextField(
                                title: "Bussiness Email",
                                text: $onboardingVM.organizationEmail,
                                keyboard: .emailAddress,
                                systemImage: "envelope"
                            )
                            .focused($focusedField, equals: .businessEmail)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .businessPhoneNumber
                                }
                                if let error = onboardingVM.organizationEmailError{
                                    Label(error, systemImage: "exclamationmark.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                            }
                            
                            
                            //MARK: - Bussiness Phone Number
                            VStack(alignment: .leading, spacing: 4) {
                            CustomTextField(
                                title: "Bussiness Phone (Optional)",
                                text: $onboardingVM.organizationPhoneNumber,
                                keyboard: .numberPad,
                                systemImage: "phone"
                            )
                            .focused($focusedField, equals: .businessPhoneNumber)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .businessWebsiteUrl
                                }
                                if let error = onboardingVM.organizationPhoneNumberError{
                                    Label(error, systemImage: "exclamationmark.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                            }
                            
                            //MARK: - Bussiness Website url
                            VStack(alignment: .leading, spacing: 4) {
                            CustomTextField(
                                title: "Website (Optional)",
                                text: $onboardingVM.organizationWebsiteUrl,
                                keyboard: .numberPad,
                                systemImage: "globe"
                            )
                            .focused($focusedField, equals: .businessWebsiteUrl)
                                .submitLabel(.done)
                                .onSubmit {
                                    focusedField = nil
                                }
                                if let error = onboardingVM.organizationWebsiteUrlError{
                                    Label(error, systemImage: "exclamationmark.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                            }
                            
                        }
                        Button {
                            onboardingVM.showAlert = false
                            Task {
                                
                            //Do Something
                           
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
                    }.padding(24)
                    
                }
            //MARK: TextField on screen Tap Disabled
                .onTapGesture {
                    focusedField = nil
                }
                //MARK: Background Disabled + Loading Spinner
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
            
            
            //MARK: Navigat to Next
    //        .navigationDestination(isPresented: $navigateToVerifyEmail) {
    //            VerifyEmail()
    //                .environmentObject(onboardingVM)
    //                .environmentObject(appViewModel)
    //
    //        }
            
            
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
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
            .alert(onboardingVM.alertTitle, isPresented:  $onboardingVM.showAlert){
                
                Button("OK", role: .cancel){
                    
                }
            }message:{
                Text(onboardingVM.errorMessage ?? "Somethiung went wrong.")
            }
            
            
        }
    }

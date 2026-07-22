//
//  ResumeOnboardingView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/22/26.
//
import SwiftUI
struct ResumeOnboardingView: View {

    @EnvironmentObject var appViewModel: AppViewModel

    @StateObject private var onboardingVM = AdminOnboardingViewModel()

    var body: some View {

        Group {

            switch appViewModel.userSession.user?.onboardingStatus {
            case .invite:
                LoginOptionsView()
            case .emailVerificationRequired:
                LoginOptionsView()
            case .organizationSetupRequired:
            LoginOptionsView()
            case .passwordResetRequired:
            LoginOptionsView()
            case .profileSetupRequired:
            LoginOptionsView()
            case .completed:
            LoginOptionsView()
            case nil:
                ProfileView()
            }

        }
        .environmentObject(onboardingVM)
    }
}

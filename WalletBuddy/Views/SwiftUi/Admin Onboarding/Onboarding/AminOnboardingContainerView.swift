//
//  Untitled.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/20/26.
//
import SwiftUI
struct AdminOnboardingContainerView: View {

    @StateObject private var onboardingVM = AdminOnboardingViewModel()

    var body: some View {

        CreateAdminAccountView()
            .environmentObject(onboardingVM)

    }
}

//
//  RootView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/18/25.
//

import SwiftUI
import UIKit

struct RootView: View {

    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    @EnvironmentObject var networkMonitor: NetworkMonitor

    var body: some View {

        ZStack {

            NavigationStack(path: $navigationRouter.path) {

                Group {

                    switch appViewModel.state {

                    case .launching:
                        SplashView()

                    case .loggedOut:
                          LoginOptionsView()
                   case .loadingSkeleton:
                        SkeletonView()

                    // Login As Employee
                    case .loggedIn:
                        MainView()

                    // Login As Admin
                    case .onboarding:

                            ResumeOnboardingView()
              
                    case .onboardingAdmin:

                            ResumeOnboardingView()
                     
                    }
                }
                // Router destination lives within NavigationStack
                .navigationDestination(for: AppRoute.self) { route in
                    route.view
                }
            }
            // NEW:
            // If the user is already logged in, do NOT replace MainView.
            // Instead, show a small offline banner over the app.
            if !networkMonitor.isConnected &&
                appViewModel.state == .loggedIn {

                OfflineBanner()
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .top
                    )
                    .transition(
                        .move(edge: .top)
                            .combined(with: .opacity)
                    )
                    .zIndex(5)
            }
            // Show Loading spinner when isLoading is true
            if appViewModel.isLoading {
                LoadingSpinnerView()
                    .transition(.opacity)
                    .zIndex(10)
            }
        }

        .animation(
            .easeInOut,
            value: appViewModel.isLoading
        )

        // NEW:
        // Animate the OfflineView / OfflineBanner appearing and disappearing.
        .animation(
            .easeInOut(duration: 0.25),
            value: networkMonitor.isConnected
        )

        .onAppear() {

            print(
                "Root Router:",
                ObjectIdentifier(navigationRouter)
            )

            print(
                "Root Path Count:",
                navigationRouter.path.count
            )

            print(
                "===== ROOT VIEW APPEARED ====="
            )

            print(
                "ROOT VIEW APPEARED"
            )
        }

        .onDisappear() {

            print(
                "===== ROOT VIEW DISAPPEARED ====="
            )

            print(
                "ROOT VIEW DISAPPEARED"
            )
        }

        .onChange(
            of: appViewModel.state
        ) { old, new in

            print(
                "STATE:",
                old,
                "→",
                new
            )

            print(
                "PATH COUNT:",
                navigationRouter.path.count
            )
        }


        // NEW:
        // Listen for changes to the device's network connection.
        .onChange(
            of: networkMonitor.isConnected
        ) { oldValue, newValue in

            if newValue {

                print("🌐 Internet connection restored")

                // Only re-sync if the user is already logged in.
                // This avoids trying to sync a logged-out user.
                if appViewModel.state == .loggedIn {

                    Task {

                        await appViewModel.syncAppUser()
                    }
                }

            } else {

                print("📴 Internet connection lost")
            }
        }
    }
}

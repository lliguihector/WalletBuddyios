//
//  LoginOptionsView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/15/25.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct LoginOptionsView: View {

    // MARK: - Environment Objects

    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter

    // MARK: - UI State

    @State private var showSubtitle = false

    // MARK: - Colors

    private let backgroundColor = Color(
        red: 0.98,
        green: 0.98,
        blue: 0.97
    )

    private let navyColor = Color(
        red: 0.05,
        green: 0.15,
        blue: 0.35
    )

    private let primaryBlue = Color(
        red: 0.16,
        green: 0.48,
        blue: 0.95
    )

    private let secondaryTextColor = Color(
        red: 0.42,
        green: 0.42,
        blue: 0.45
    )

    private let linkBlue = Color(
        red: 0.00,
        green: 0.38,
        blue: 0.80
    )

    private let cardBackground = Color(
        red: 0.94,
        green: 0.97,
        blue: 1.00
    )

    // MARK: - Body

    var body: some View {

        GeometryReader { geometry in

            let height = geometry.size.height
            let isCompact = height < 740

            ZStack {

                backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    // MARK: Logo

                    headerSection(
                        compact: isCompact
                    )

                    Spacer()
                        .frame(
                            height: isCompact ? 22 : 34
                        )

                    // MARK: Hero

                    heroSection(
                        compact: isCompact
                    )

                    Spacer()
                        .frame(
                            height: isCompact ? 18 : 26
                        )

                    // MARK: Audience Card

                    audienceSection(
                        compact: isCompact
                    )

                    Spacer()
                        .frame(
                            height: isCompact ? 22 : 32
                        )

                    // MARK: Authentication

                    authenticationSection(
                        compact: isCompact
                    )

                    Spacer(minLength: isCompact ? 18 : 28)

                    // MARK: Terms

                    termsSection(
                        compact: isCompact
                    )
                }
                .padding(.horizontal, 28)
                .padding(
                    .top,
                    isCompact ? 14 : 24
                )
                .padding(
                    .bottom,
                    isCompact ? 8 : 14
                )
                .frame(
                    maxWidth: 600,
                    maxHeight: .infinity
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            }
        }

        // Keeps the design identical in dark mode.
        .preferredColorScheme(.light)

        // MARK: - Connection Alert

        .alert(item: $appViewModel.activeAlert) { alert in

            Alert(
                title: Text("Connection Error"),
                message: Text(alert.message),
                dismissButton: .default(
                    Text("OK")
                )
            )
        }

        // MARK: - On Appear

        .onAppear {

            print(
                "LoginOptions Router:",
                ObjectIdentifier(navigationRouter)
            )

            print(
                "LoginOptions Path Count:",
                navigationRouter.path.count
            )

            withAnimation(
                .easeInOut(duration: 0.55)
                .delay(0.15)
            ) {
                showSubtitle = true
            }
        }

        // MARK: - Navigation Bar

        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .tint(.black)
    }
}


// MARK: - UI Sections

private extension LoginOptionsView {

    // MARK: Logo

    @ViewBuilder
    func headerSection(
        compact: Bool
    ) -> some View {

        HStack(spacing: compact ? 10 : 12) {

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(
                    width: compact ? 48 : 54,
                    height: compact ? 48 : 54
                )
                .accessibilityHidden(true)

            Text("Determit")
                .font(
                    .system(
                        size: compact ? 32 : 36,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(navyColor)
                .tracking(-0.8)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .center
        )
    }


    // MARK: Hero

    @ViewBuilder
    func heroSection(
        compact: Bool
    ) -> some View {

        VStack(
            alignment: .leading,
            spacing: compact ? 10 : 14
        ) {

            Text("Know who's on\nsite in real time.")
                .font(
                    .system(
                        size: compact ? 31 : 35,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(navyColor)
                .tracking(-1.1)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            if showSubtitle {

                Text(
                    "Sign in to your organization\nor create a new one."
                )
                .font(
                    .system(
                        size: compact ? 15 : 16,
                        weight: .semibold,
                        design: .rounded
                    )
                )
                .foregroundStyle(
                    secondaryTextColor
                )
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
                .transition(
                    .opacity.combined(
                        with: .move(edge: .bottom)
                    )
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .animation(
            .easeInOut(duration: 0.55),
            value: showSubtitle
        )
    }


    // MARK: Audience Card

    @ViewBuilder
    func audienceSection(
        compact: Bool
    ) -> some View {

        HStack(
            spacing: compact ? 14 : 17
        ) {

            Image(
                systemName: "person.2"
            )
            .font(
                .system(
                    size: compact ? 22 : 25,
                    weight: .medium
                )
            )
            .foregroundStyle(primaryBlue)
            .frame(
                width: compact ? 38 : 44
            )

            Rectangle()
                .fill(
                    primaryBlue.opacity(0.18)
                )
                .frame(
                    width: 1,
                    height: compact ? 30 : 36
                )

            Text(
                "For administrators and\ninvited members."
            )
            .font(
                .system(
                    size: compact ? 15 : 16,
                    weight: .semibold,
                    design: .rounded
                )
            )
            .foregroundStyle(navyColor)
            .lineSpacing(2)

            Spacer(minLength: 0)
        }
        .padding(
            .horizontal,
            compact ? 16 : 20
        )
        .frame(
            maxWidth: .infinity
        )
        .frame(
            height: compact ? 72 : 82
        )
        .background {

            RoundedRectangle(
                cornerRadius: 18,
                style: .continuous
            )
            .fill(cardBackground)
        }
        .accessibilityElement(
            children: .combine
        )
    }


    // MARK: Authentication

    @ViewBuilder
    func authenticationSection(
        compact: Bool
    ) -> some View {

        VStack(spacing: 0) {

            signInButton(
                compact: compact
            )

            newUserDivider
                .padding(
                    .vertical,
                    compact ? 18 : 22
                )

            createOrganizationButton(
                compact: compact
            )
        }
    }


    // MARK: Sign In Button

    @ViewBuilder
    func signInButton(
        compact: Bool
    ) -> some View {

        NavigationLink {

            LogInVCWrapper()

        } label: {

            HStack(
                spacing: compact ? 12 : 15
            ) {

                Image(
                    systemName: "envelope"
                )
                .font(
                    .system(
                        size: compact ? 21 : 23,
                        weight: .semibold
                    )
                )

                Text("Sign In")
                    .font(
                        .system(
                            size: compact ? 20 : 22,
                            weight: .bold,
                            design: .rounded
                        )
                    )
            }
            .foregroundStyle(.white)
            .frame(
                maxWidth: .infinity
            )
            .frame(
                height: compact ? 54 : 58
            )
            .background {

                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .fill(primaryBlue)
                .shadow(
                    color:
                        primaryBlue.opacity(0.18),
                    radius: 9,
                    x: 0,
                    y: 5
                )
            }
        }
        .buttonStyle(
            ScaleButtonStyle()
        )
        .accessibilityLabel(
            "Sign in to your organization"
        )
    }


    // MARK: Divider

    var newUserDivider: some View {

        HStack(spacing: 14) {

            dividerLine

            Text("OR")
                .font(
                    .system(
                        size: 14,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .foregroundStyle(
                    secondaryTextColor.opacity(
                        0.85
                    )
                )
                .fixedSize()

            dividerLine
        }
    }


    var dividerLine: some View {

        Rectangle()
            .fill(
                Color.gray.opacity(0.20)
            )
            .frame(height: 1)
    }


    // MARK: Create Organization

    @ViewBuilder
    func createOrganizationButton(
        compact: Bool
    ) -> some View {

        NavigationLink {

            AdminOnboardingContainerView()

        } label: {

            HStack(
                spacing: compact ? 12 : 15
            ) {

                Image(
                    systemName: "building.2"
                )
                .font(
                    .system(
                        size: compact ? 20 : 22,
                        weight: .semibold
                    )
                )

                Text(
                    "Create an Organization"
                )
                .font(
                    .system(
                        size: compact ? 18 : 20,
                        weight: .bold,
                        design: .rounded
                    )
                )
                .minimumScaleFactor(0.82)
                .lineLimit(1)
            }
            .foregroundStyle(.white)
            .frame(
                maxWidth: .infinity
            )
            .frame(
                height: compact ? 54 : 58
            )
            .background {

                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .fill(
                    Color(
                        red: 0.03,
                        green: 0.04,
                        blue: 0.06
                    )
                )
                .shadow(
                    color:
                        Color.black.opacity(
                            0.12
                        ),
                    radius: 9,
                    x: 0,
                    y: 5
                )
            }
        }
        .buttonStyle(
            ScaleButtonStyle()
        )
        .accessibilityLabel(
            "Create a new organization"
        )
    }


    // MARK: Terms & Privacy

    @ViewBuilder
    func termsSection(
        compact: Bool
    ) -> some View {

        VStack(
            spacing: compact ? 2 : 4
        ) {

            Text(
                "By continuing, you agree to our"
            )
            .foregroundStyle(
                secondaryTextColor
            )

            HStack(spacing: 4) {

                Button {

                    openTerms()

                } label: {

                    Text(
                        "Terms of Service"
                    )
                    .foregroundStyle(
                        linkBlue
                    )
                }

                Text("and")
                    .foregroundStyle(
                        secondaryTextColor
                    )

                Button {

                    openPrivacyPolicy()

                } label: {

                    Text(
                        "Privacy Policy"
                    )
                    .foregroundStyle(
                        linkBlue
                    )
                }

                Text(".")
                    .foregroundStyle(
                        secondaryTextColor
                    )
                    .padding(.leading, -4)
            }
        }
        .font(
            .system(
                size: compact ? 12 : 13,
                weight: .medium,
                design: .rounded
            )
        )
        .frame(
            maxWidth: .infinity
        )
        .multilineTextAlignment(.center)
        .buttonStyle(.plain)
    }
}


// MARK: - External Links

private extension LoginOptionsView {

    func openTerms() {

        guard let url = URL(
            string:
                "https://determit.com/terms"
        ) else {
            return
        }

        UIApplication.shared.open(url)
    }


    func openPrivacyPolicy() {

        guard let url = URL(
            string:
                "https://determit.com/privacy"
        ) else {
            return
        }

        UIApplication.shared.open(url)
    }
}


// MARK: - Button Press Animation

private struct ScaleButtonStyle:
    ButtonStyle {

    func makeBody(
        configuration: Configuration
    ) -> some View {

        configuration.label
            .scaleEffect(
                configuration.isPressed
                ? 0.97
                : 1
            )
            .opacity(
                configuration.isPressed
                ? 0.92
                : 1
            )
            .animation(
                .easeOut(
                    duration: 0.12
                ),
                value:
                    configuration.isPressed
            )
    }
}


// MARK: - Preview

#Preview {

    NavigationStack {

        LoginOptionsView()
            .environmentObject(
                AppViewModel.shared
            )
            .environmentObject(
                NavigationRouter.shared
            )
    }
}

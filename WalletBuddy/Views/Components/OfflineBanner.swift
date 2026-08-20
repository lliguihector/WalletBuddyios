//
//  OfflineBanner.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/7/26.
//

import SwiftUI

struct OfflineBanner: View {

    var body: some View {

        HStack(spacing: 10) {

            Image(systemName: "wifi.slash")
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text("You're Offline")
                    .font(
                        .subheadline
                        .bold()
                    )

                Text(
                    "Some information may not be up to date."
                )
                .font(.caption)
            }

            Spacer()
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 8,
            y: 3
        )
    }
}

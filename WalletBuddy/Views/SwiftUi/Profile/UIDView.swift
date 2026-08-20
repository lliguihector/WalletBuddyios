//
//  UIDView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/30/25.
//
import SwiftUI

struct UIDView: View {
    let uid: String  // property to hold the UID
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(alignment: .leading) {
            Text(uid)
                .font(.title2)
                .fontWeight(.semibold)

                .padding(.bottom, 20)
            Text("""
            Use this Account ID when contacting Customer Service.

            Do not share it with anyone else.
            """)
                .font(.footnote)
                .foregroundColor(.secondary)

            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationTitle("Account ID")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}


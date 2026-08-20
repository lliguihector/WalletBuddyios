//
//  Untitled.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/14/26.
//
import SwiftUI
struct StepProgressView: View {
    let currentStep: Int
    let totalSteps: Int = 6
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(1...totalSteps, id: \.self) { step in
                
                Circle()
                    .fill(step <= currentStep ? Color.secondary : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
                
                if step != totalSteps {
                    Rectangle()
                        .fill(step < currentStep ? Color.secondary : Color.gray.opacity(0.3))
                        .frame(height: 2)
                }
            }
        }
    }
}

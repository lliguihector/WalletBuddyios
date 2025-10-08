//
//  MapView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/8/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = CheckInViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3318, longitude: -122.031),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    // Toast state
    @State private var toastMessage: String? = nil
    @State private var showToast = false
    @State private var toastIsError = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // Map
            Map(coordinateRegion: $region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            
            // Top-left X button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                    .padding()
            }
            
            // MARK: - Check In Now Button
            VStack {
                Spacer()
                Button(action: {
                    Task {
                        await viewModel.checkinManually()
                        if viewModel.showSuccessAlert {
                            toastMessage = "Check-in successful!"
                            toastIsError = false
                            showToastWithAutoDismiss()
                        } else if viewModel.showFailureAlert {
                            toastMessage = viewModel.errorMessage ?? "An error occurred."
                            toastIsError = true
                            showToastWithAutoDismiss()
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.white)
                        Text("Check In Now")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
                .padding()
            }
            
            // MARK: - Loading Spinner
            if viewModel.isLoading {
                LoadingSpinnerView()
                    .transition(.opacity)
                    .zIndex(2)
            }
            
            // MARK: - Toast
            if showToast, let message = toastMessage {
                VStack {
                    WBToast(message: message, isError: toastIsError)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .zIndex(2)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: showToast)
    }
    
    // MARK: - Toast Auto Dismiss
    private func showToastWithAutoDismiss() {
        withAnimation { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { showToast = false }
        }
    }
}

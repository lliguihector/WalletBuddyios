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
        ZStack {
            // MARK: - Map
            Map(coordinateRegion: $region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)

            // MARK: - X Button (Dismiss)
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, height:50)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }

            // MARK: - Floating Buttons + Check-In Button
            VStack {
                Spacer()

                // Floating icon buttons (Compass + Google Maps)
                HStack {
                    Spacer()
                    VStack(spacing: 16) {
                        // Compass Button
                        Button(action: {
                            print("Compass tapped")
                        }) {
                            Image(systemName: "location.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                                .padding(14)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }

                        // Google Maps Button
                        Button(action: {
                            print("Google Map Button tapped")
                        }) {
                            Image("google-maps")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(14)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 40) // keeps icon buttons above Check-In

                // Check-In Button
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
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 20) // space from screen bottom
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
        
        //Request permission and start updating location whn view appears
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

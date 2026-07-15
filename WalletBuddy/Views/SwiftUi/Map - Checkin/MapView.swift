//
//  MapView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/8/25.
//
import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var mapViewModel: MapViewModel
    var onCheckinSuccess: (() -> Void)?

    // Init with MapViewModel
    init(userViewModel: UserViewModel, onCheckinSuccess: (() -> Void)? = nil) {
        _mapViewModel = StateObject(wrappedValue: MapViewModel(userViewModel: userViewModel))
        self.onCheckinSuccess = onCheckinSuccess
    }

    // Camera fallback
    let defaultCamera: MapCameraPosition = .region(.init(
        center: CLLocationCoordinate2D(latitude: 37.3318, longitude: -122.031),
        latitudinalMeters: 1300,
        longitudinalMeters: 1300
    ))

    // Toast state
    @State private var toastMessage: String? = nil
    @State private var showToast = false
    @State private var toastIsError = false

    var body: some View {
        ZStack {
            // MARK: - Map
            Map(initialPosition: mapViewModel.organizationCamera ?? defaultCamera) {
                if let orgCoord = mapViewModel.organizationCoordinate {
                    Annotation(userViewModel.appUser?.organization?.name ?? "Organization",
                               coordinate: orgCoord,
                               anchor: .center) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .padding(7)
                            .background(.green.gradient, in: .circle)
                    }
                }
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
                MapScaleView()
            }

            // MARK: - Dismiss Button
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }

            // MARK: - Check-In Button
            VStack {
                Spacer()
                Button(action: {
                    Task {
                        await mapViewModel.checkinManually()
                        if mapViewModel.showSuccessAlert {
                            toastMessage = "Check-in successful!"
                            toastIsError = false
                            showToastWithAutoDismiss()
                            onCheckinSuccess?()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                dismiss()
                            }
                        } else if mapViewModel.showFailureAlert {
                            toastMessage = mapViewModel.errorMessage ?? "An error occurred."
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
                .padding(.bottom, 20)
            }

            // MARK: - Loading Spinner
            if mapViewModel.isLoading {
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
 

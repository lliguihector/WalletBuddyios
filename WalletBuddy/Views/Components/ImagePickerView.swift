//
//  ImagePickerView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/12/26.
//
//
//  ImagePickerView.swift
//  WalletBuddy
//

import SwiftUI
import PhotosUI


// MARK: - Image Picker Type
enum ImagePickerType {
    case organization
    case profile

    var placeholderIcon: String {
        switch self {
        case .organization:
            return "building.2"

        case .profile:
            return "person.fill"
        }
    }

    var addText: String {
        switch self {
        case .organization:
            return "Add Organization Logo"

        case .profile:
            return "Add Profile Photo"
        }
    }

    var changeText: String {
        switch self {
        case .organization:
            return "Change Logo"

        case .profile:
            return "Change Photo"
        }
    }
}


// MARK: - Image Picker View
struct ImagePickerView: View {

    // Selected UIImage gets passed back to the parent/ViewModel
    @Binding var selectedImage: UIImage?

    // Determines whether this is a logo or profile picture
    let type: ImagePickerType

    // PhotosPicker selected item
    @State private var selectedItem: PhotosPickerItem?

    // Loading state while reading image
    @State private var isLoading = false


    var body: some View {

        VStack(spacing: 10) {

            // MARK: - Photo Picker
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {

                ZStack(alignment: .bottomTrailing) {

                    // MARK: - Selected Image
                    if let selectedImage {

                        selectedImageView(selectedImage)

                    } else {

                        // MARK: - Placeholder
                        placeholderView
                    }


                    // MARK: - Add / Edit Badge
                    Image(
                        systemName: selectedImage == nil
                        ? "plus.circle.fill"
                        : "pencil.circle.fill"
                    )
                    .font(.system(size: 27))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .blue)
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 23, height: 23)
                    }
                }
            }
            .disabled(isLoading)


            // MARK: - Add / Change Text
            Text(
                selectedImage == nil
                ? type.addText
                : type.changeText
            )
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.blue)


            // MARK: - Loading
            if isLoading {

                ProgressView()
                    .controlSize(.small)

            } else {

                Text("Optional")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)

        // MARK: - Detect Selected Photo
        .onChange(of: selectedItem) { _, newItem in

            guard let newItem else {
                return
            }

            Task {
                await loadImage(from: newItem)
            }
        }
    }


    // MARK: - Selected Image View
    @ViewBuilder
    private func selectedImageView(_ image: UIImage) -> some View {

        switch type {

        case .organization:

            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )


        case .profile:

            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(Circle())
        }
    }


    // MARK: - Placeholder View
    @ViewBuilder
    private var placeholderView: some View {

        switch type {

        // Organization logo
        case .organization:

            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
            .fill(Color(.tertiarySystemBackground))
            .frame(width: 90, height: 90)
            .overlay {

                Image(systemName: type.placeholderIcon)
                    .font(.system(size: 30))
                    .foregroundStyle(.secondary)
            }
            .overlay {

                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .stroke(
                    Color.secondary.opacity(0.4),
                    lineWidth: 1
                )
            }


        // User profile photo
        case .profile:

            Circle()
                .fill(Color(.tertiarySystemBackground))
                .frame(width: 90, height: 90)
                .overlay {

                    Image(systemName: type.placeholderIcon)
                        .font(.system(size: 32))
                        .foregroundStyle(.secondary)
                }
                .overlay {

                    Circle()
                        .stroke(
                            Color.secondary.opacity(0.4),
                            lineWidth: 1
                        )
                }
        }
    }


    // MARK: - Load Selected Image
    @MainActor
    private func loadImage(from item: PhotosPickerItem) async {

        isLoading = true

        defer {
            isLoading = false
        }

        do {

            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data)
            else {
                return
            }

            selectedImage = image

        } catch {

            print("Failed to load selected image: \(error)")
        }
    }
}


// MARK: - Preview
#Preview {

    VStack(spacing: 50) {

        ImagePickerView(
            selectedImage: .constant(nil),
            type: .organization
        )

        ImagePickerView(
            selectedImage: .constant(nil),
            type: .profile
        )
    }
    .padding()
}

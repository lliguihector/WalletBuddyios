//
//  LocationEligibilityView.swift
//  Determit
//
//  Created by Hector Lliguichuzca on 8/20/26.
//

import SwiftUI
import MapKit

struct LocationEligibilityView: View {

    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    // MARK: - Temporary Data

    // Replace this with the distance calculated from the
    // user's current location.
    let distanceFromWorkLocation: Double = 100

    // Approved clock-in distance measured in feet.
    let allowedDistance: Double = 100

    // Replace this with the coordinate provided by LocationManager.
    let userCoordinate = CLLocationCoordinate2D(
        latitude: 40.7600,
        longitude: -73.8730
    )

    // MARK: - Map Camera

    @State private var cameraPosition: MapCameraPosition = .automatic

    // MARK: - Organization Data

    private var workLocationName: String {
        appViewModel
            .userSession
            .user?
            .organization?
            .name ?? "Work Location"
    }

    private var workLocationAddress: String {
        guard let address = appViewModel
            .userSession
            .user?
            .organization?
            .address else {
            return "Address unavailable"
        }

        let cityState = [
            address.city,
            address.state
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
        .joined(separator: ", ")

        let finalLine = [
            cityState,
            address.postalCode
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
        .joined(separator: " ")

        return [
            address.street,
            finalLine
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
        .joined(separator: ", ")
    }
    
    
    private func fitMapToLocations() {
        
        guard let organizationCoordinate else {
            cameraPosition = .region( MKCoordinateRegion(center: userCoordinate,span: MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01))
            )
            return
        }

        let organizationPoint = MKMapPoint(organizationCoordinate)
        let userPoint = MKMapPoint(userCoordinate)

        let mapRect = MKMapRect(x: min(organizationPoint.x, userPoint.x),y: min(organizationPoint.y, userPoint.y),width: abs(organizationPoint.x - userPoint.x),height: abs(organizationPoint.y - userPoint.y)
        )

        cameraPosition = .rect(mapRect.insetBy(dx: -max(mapRect.width * 0.35, 1_500),dy: -max(mapRect.height * 0.35, 1_500)))
    }
    
    
    private var organizationCoordinate: CLLocationCoordinate2D? {
        guard let coordinates = appViewModel.userSession.user?.organization?.location?.coordinates,coordinates.count >= 2 else {
            return nil
        }

        // GeoJSON stores coordinates as:
        // [longitude, latitude]
        let longitude = coordinates[0]
        let latitude = coordinates[1]

        guard CLLocationCoordinate2DIsValid(CLLocationCoordinate2D(latitude: latitude,longitude: longitude)) else{
            return nil
        }
        return CLLocationCoordinate2D( latitude: latitude,longitude: longitude)
    }

    // MARK: - Range Information

    private var isWithinRange: Bool {
        distanceFromWorkLocation <= allowedDistance
    }
    
    
    private var distanceNeeded: Double {
        max(distanceFromWorkLocation - allowedDistance, 0)
    }

    // MapCircle expects its radius in meters.
    private var allowedDistanceInMeters: Double {
        allowedDistance * 0.3048
    }
//Open apple maps
    private func openInAppleMaps() {
        guard let organizationCoordinate else {
            return
        }

        let placemark = MKPlacemark(
            coordinate: organizationCoordinate
        )

        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = workLocationName
        mapItem.openInMaps()
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                mapSection
                locationInformationCard
               
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Location Check")
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
        .onAppear {
         
                fitMapToLocations()

        }
    }
}

// MARK: - Location Information Card

private extension LocationEligibilityView {

    var locationInformationCard: some View {
        VStack(spacing: 0) {
            distanceRow

            Divider()
                .padding(.horizontal)

            workLocationRow
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(
            color: Color.black.opacity(0.05),
            radius: 5,
            x: 0,
            y: 2
        )
    }

//    var distanceRow: some View {
//        HStack(spacing: 14) {
//            iconBackground(icon: "location.fill")
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text("Distance to work")
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//
//                Text("\(Int(distanceFromWorkLocation)) ft")
//                    .font(.title3.weight(.bold))
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//
//            rangeStatusBadge
//        }
//        .padding()
//    }
    var distanceRow: some View {
        HStack(alignment: .top, spacing: 14) {
            iconBackground(icon: "location.fill")

            VStack(alignment: .leading, spacing: 6) {
                Text("Distance to location")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("\(Int(distanceFromWorkLocation.rounded())) ft")
                    .font(.title3.weight(.bold))

                Text("Approved range: \(Int(allowedDistance.rounded())) ft")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if !isWithinRange {
                    Label(
                        "Move \(Int(distanceNeeded.rounded())) ft closer",
                        systemImage: "arrow.forward"
                    )
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.red)
                    .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            rangeStatusBadge
        }
        .padding()
    }

    var rangeStatusBadge: some View {
        HStack(spacing: 5) {
            Image(
                systemName: isWithinRange
                    ? "checkmark.circle.fill"
                    : "xmark.circle.fill"
            )

            Text(
                isWithinRange
                    ? "Within range"
                    : "Out of range"
            )
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(isWithinRange ? .green : .red)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            (isWithinRange ? Color.green : Color.red)
                .opacity(0.10)
        )
        .clipShape(Capsule())
        .fixedSize()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            isWithinRange
                ? "Within approved area"
                : "Outside approved area"
        )
    }

    var workLocationRow: some View {
        HStack(spacing: 14) {
            iconBackground(icon: "building.2.fill")

            VStack(alignment: .leading, spacing: 4) {
                Text("Work location")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(workLocationName)
                    .font(.headline)

                Text(workLocationAddress)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //Open and view in Apple Maps Button
            Button {
                openInAppleMaps()
            } label: {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.amazingBlue)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .disabled(organizationCoordinate == nil)
            .opacity(organizationCoordinate == nil ? 0.4 : 1)
            .accessibilityLabel("Open in Apple Maps")
        }
        .padding()
    }
}

// MARK: - Map Section

private extension LocationEligibilityView {

    var mapSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            locationMap

            Label(
                "The shaded circle shows the approved clock-in area.",
                systemImage: "info.circle"
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    var locationMap: some View {
        Map(position: $cameraPosition) {
            if let organizationCoordinate {
                MapCircle(
                    center: organizationCoordinate,
                    radius: allowedDistanceInMeters
                )
                .foregroundStyle(Color.blue.opacity(0.12))
                .stroke(
                    Color.blue.opacity(0.60),
                    lineWidth: 1.5
                )

                Annotation(
                    workLocationName,
                    coordinate: organizationCoordinate
                ) {
                    workLocationMarker
                }
            }

            // Temporary marker.
            // Replace this with UserAnnotation() after connecting
            // the view to your LocationManager.
            Annotation(
                "You",
                coordinate: userCoordinate
            ) {
                userLocationMarker
            }
        }
        .mapControls {
            MapCompass()
        }
        .frame(minHeight: 320, idealHeight: 380)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color(uiColor: .separator).opacity(0.20),
                    lineWidth: 1
                )
        }
    }

    var workLocationMarker: some View {
        ZStack {
            Circle()
                .fill(.blue)
                .frame(width: 38, height: 38)

            Image(systemName: "building.2.fill")
                .font(.caption)
                .foregroundStyle(.white)
        }
        .shadow(
            color: .black.opacity(0.15),
            radius: 3,
            y: 2
        )
    }

    var userLocationMarker: some View {
        Circle()
            .fill(.blue)
            .frame(width: 16, height: 16)
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 4)
            }
            .shadow(
                color: .black.opacity(0.15),
                radius: 3
            )
    }
}

// MARK: - Map Camera

private extension LocationEligibilityView {

    func centerMapOnOrganization() {
        guard let organizationCoordinate else {
            return
        }

        let diameterInMeters = allowedDistanceInMeters * 2

        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: organizationCoordinate,
                distance: max(diameterInMeters * 3, 500)
            )
        )
    }
}

// MARK: - Reusable Icon

private extension LocationEligibilityView {

    func iconBackground(icon: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.08))
                .frame(width: 48, height: 48)

            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
        }
        .accessibilityHidden(true)
    }
}

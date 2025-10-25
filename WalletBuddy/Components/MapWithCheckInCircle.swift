//
//  MapWithCheckInCircle.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/6/25.
//
//
//  MapWithOrgCheckInCircle.swift
//  WalletBuddy
//

import SwiftUI
import MapKit

struct MapWithOrgCheckInCircle: View {
    
    @Binding var region: MKCoordinateRegion
    let organization: Organization?
    var checkInRadius: CLLocationDistance = 100 // meters
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: annotationItems()) { item in
            MapAnnotation(coordinate: item.coordinate) {
                VStack(spacing: 4) {
                    Image("location-pointer")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(item.title)
                        .font(.caption2)
                        .bold()
                }
            }
        }
        .overlay(
            // Draw circle on top of the map
            GeometryReader { geo in
                if let org = organization,
                   org.location.coordinates.count == 2 {
                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 40) // lineWidth scaled roughly to meters
                        .frame(width: radiusInPoints(region: region, geo: geo, radius: checkInRadius),
                               height: radiusInPoints(region: region, geo: geo, radius: checkInRadius))
                        .position(mapPosition(for: org, in: geo))
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // Convert organization to annotation item
    private func annotationItems() -> [OrgAnnotation] {
        guard let org = organization,
              org.location.coordinates.count == 2 else { return [] }
        
        let coord = CLLocationCoordinate2D(latitude: org.location.coordinates[0],
                                           longitude: org.location.coordinates[1])
        return [OrgAnnotation(id: org.name, coordinate: coord, title: org.name)]
    }
    
    struct OrgAnnotation: Identifiable {
        let id: String
        let coordinate: CLLocationCoordinate2D
        let title: String
    }
    
    // Convert radius in meters to points on screen
    private func radiusInPoints(region: MKCoordinateRegion, geo: GeometryProxy, radius: CLLocationDistance) -> CGFloat {
        let mapWidthInMeters = region.span.longitudeDelta * 111_000 // approx meters per degree
        let mapWidthInPoints = geo.size.width
        let metersPerPoint = mapWidthInMeters / mapWidthInPoints
        return CGFloat(radius / metersPerPoint)
    }
    
    // Get screen position of org
    private func mapPosition(for org: Organization, in geo: GeometryProxy) -> CGPoint {
        let lonDelta = org.location.coordinates[1] - region.center.longitude
        let latDelta = region.center.latitude - org.location.coordinates[0]
        
        let x = geo.size.width * CGFloat(0.5 + lonDelta / region.span.longitudeDelta)
        let y = geo.size.height * CGFloat(0.5 + latDelta / region.span.latitudeDelta)
        
        return CGPoint(x: x, y: y)
    }
}

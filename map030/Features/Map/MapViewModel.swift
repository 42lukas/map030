//
//  MapViewModel.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI
import MapKit
import Observation

@Observable
@MainActor
final class MapViewModel {
    var cameraPosition: MapCameraPosition
    
    var isUserFocused: Bool {
        return !cameraPosition.positionedByUser
    }

    init() {
        cameraPosition = .userLocation(
            followsHeading: false,
            fallback: .region(Self.berlinRegion)
        )
    }
    
    func recenter() {
        cameraPosition = .userLocation(
            followsHeading: false,
            fallback: .region(Self.berlinRegion)
        )
    }
    
    
    // MARK: - berlin constant
    private static let berlinRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 52.5200,
            longitude: 13.4050
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.15,
            longitudeDelta: 0.15
        )
    )
    
    // MARK: - temporäre testdaten
    private(set) var reports: [Report] = [
        Report(
            id: UUID(),
            category: .transit,
            coordinate: CLLocationCoordinate2D(
                latitude: 52.5219,
                longitude: 13.4132
            ),
            createdAt: .now
        ),
        Report(
            id: UUID(),
            category: .obstruction,
            coordinate: CLLocationCoordinate2D(
                latitude: 52.5251,
                longitude: 13.3694
            ),
            createdAt: .now
        ),
        Report(
            id: UUID(),
            category: .notice,
            coordinate: CLLocationCoordinate2D(
                latitude: 52.5050,
                longitude: 13.4485
            ),
            createdAt: .now
        )
    ]
}

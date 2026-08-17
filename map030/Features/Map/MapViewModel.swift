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

    init() {
        cameraPosition = .userLocation(
            followsHeading: false,
            fallback: .region(Self.berlinRegion)
        )
    }

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
}

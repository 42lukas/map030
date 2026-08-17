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
    
    private(set) var reports: [Report]

    init() {
        cameraPosition = .userLocation(
            followsHeading: false,
            fallback: .region(Self.berlinRegion)
        )

        reports = MockTransitData.reports
    }
    
    var isUserFocused: Bool {
        return !cameraPosition.positionedByUser
    }
    
    func recenter() {
        cameraPosition = .userLocation(
            followsHeading: false,
            fallback: .region(Self.berlinRegion)
        )
    }
    
    
    // MARK: - Report Section
    private(set) var selectedReport: Report?

    func selectReport(_ report: Report) {
        selectedReport = report
    }

    func clearSelection() {
        selectedReport = nil
    }
    
    func addReport(_ report: Report) {
        reports.append(report)
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
}

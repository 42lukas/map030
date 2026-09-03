//
//  map030Tests.swift
//  map030Tests
//
//  Created by Lukas Karsten on 17.08.26.
//

import CoreLocation
import MapKit
import SwiftUI
import XCTest
@testable import map030

@MainActor
final class map030Tests: XCTestCase {
    func testNearbyStationsAreClustered() {
        let first = makeCluster(
            id: "first",
            latitude: 52.5200,
            longitude: 13.4050
        )
        let second = makeCluster(
            id: "second",
            latitude: 52.5210,
            longitude: 13.4050
        )

        let result = GeographicReportClustering.cluster(
            [first, second],
            within: 250
        )

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].stations.count, 2)
        XCTAssertEqual(result[0].reports.count, 2)
    }

    func testDistantStationsRemainSeparate() {
        let first = makeCluster(
            id: "first",
            latitude: 52.5200,
            longitude: 13.4050
        )
        let second = makeCluster(
            id: "second",
            latitude: 52.5400,
            longitude: 13.4050
        )

        let result = GeographicReportClustering.cluster(
            [first, second],
            within: 250
        )

        XCTAssertEqual(result.count, 2)
    }

    func testClusteringCanBeDisabledForDetailZoom() {
        let first = makeCluster(
            id: "first",
            latitude: 52.5200,
            longitude: 13.4050
        )
        let second = makeCluster(
            id: "second",
            latitude: 52.5201,
            longitude: 13.4050
        )

        let result = GeographicReportClustering.cluster(
            [first, second],
            within: 0
        )

        XCTAssertEqual(result.count, 2)
    }

    func testZoomOutIsLimitedToGermanyScale() throws {
        let viewModel = MapViewModel()
        let camera = MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: 52.5200,
                longitude: 13.4050
            ),
            distance: 10_000_000,
            heading: 20,
            pitch: 15
        )

        viewModel.limitZoomOut(camera: camera)

        let limitedCamera = try XCTUnwrap(
            viewModel.cameraPosition.camera
        )
        XCTAssertEqual(
            limitedCamera.distance,
            MapViewModel.maximumCameraDistance,
            accuracy: 1
        )
        XCTAssertEqual(limitedCamera.heading, camera.heading)
        XCTAssertEqual(limitedCamera.pitch, camera.pitch)
    }

    func testCreatedReportUsesCategoryExpiration() throws {
        let viewModel = CreateReportViewModel(
            transitRepository: LocalTransitRepository()
        )
        viewModel.selectedStation = MockTransitData.stations[0]
        viewModel.selectedCategory = .control

        let report = try XCTUnwrap(viewModel.createReport())

        XCTAssertEqual(
            report.expiresAt.timeIntervalSince(report.createdAt),
            ReportCategory.control.expirationInterval,
            accuracy: 0.1
        )
    }

    func testExpirationIntervalsForEveryCategory() {
        let expectedIntervals: [TimeInterval] = [
            30 * 60,
            45 * 60,
            90 * 60,
            3 * 60 * 60,
            24 * 60 * 60,
            12 * 60 * 60,
            8 * 60 * 60,
            4 * 60 * 60,
            2 * 60 * 60
        ]

        XCTAssertEqual(
            ReportCategory.allCases.map(\.expirationInterval),
            expectedIntervals
        )
    }

    func testExpiredReportsAreRemoved() {
        let viewModel = MapViewModel()
        let report = makeReport(
            station: MockTransitData.stations[0],
            expiresAt: Date(timeIntervalSince1970: 100)
        )

        viewModel.addReport(report)
        viewModel.selectReport(report)
        viewModel.removeExpiredReports(
            at: Date(timeIntervalSince1970: 101)
        )

        XCTAssertFalse(
            viewModel.reports.contains { $0.id == report.id }
        )
        XCTAssertNil(viewModel.activeSheet)
    }

    private func makeCluster(
        id: String,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) -> StationReportCluster {
        let station = TransitStation(
            id: id,
            name: id,
            coordinate: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            lines: []
        )
        let report = makeReport(
            station: station,
            expiresAt: .distantFuture
        )

        return StationReportCluster(
            station: station,
            reports: [report]
        )
    }

    private func makeReport(
        station: TransitStation,
        expiresAt: Date
    ) -> Report {
        Report(
            id: UUID(),
            station: station,
            line: nil,
            category: .control,
            createdAt: .now,
            expiresAt: expiresAt
        )
    }

}

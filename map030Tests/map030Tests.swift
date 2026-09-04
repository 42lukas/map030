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

    func testMarkersShrinkForWiderMapViews() {
        XCTAssertGreaterThan(
            MapZoomLevel.detail.markerScale,
            MapZoomLevel.station.markerScale
        )
        XCTAssertGreaterThan(
            MapZoomLevel.station.markerScale,
            MapZoomLevel.overview.markerScale
        )
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

    func testReportSummaryPrioritizesControlsAndCountsReports() {
        let viewModel = MapViewModel()
        let station = MockTransitData.stations[0]

        viewModel.addReport(
            makeReport(station: station, category: .delay)
        )
        viewModel.addReport(
            makeReport(station: station, category: .control)
        )
        viewModel.addReport(
            makeReport(station: station, category: .control)
        )

        XCTAssertEqual(
            viewModel.reportSummaries.map(\.category),
            [.control, .delay]
        )
        XCTAssertEqual(viewModel.reportSummaries.first?.count, 2)
    }

    func testCitySelectionKeepsReportsIndependent() throws {
        let viewModel = MapViewModel()
        let station = MockTransitData.stations[0]

        viewModel.addReport(
            makeReport(
                station: station,
                category: .control,
                city: .berlin
            )
        )
        viewModel.addReport(
            makeReport(
                station: station,
                category: .delay,
                city: .hamburg
            )
        )

        XCTAssertEqual(viewModel.reports.count, 1)
        XCTAssertEqual(viewModel.reports[0].city, .berlin)

        viewModel.selectCity(.hamburg)

        XCTAssertEqual(viewModel.reports.count, 1)
        XCTAssertEqual(viewModel.reports[0].city, .hamburg)
        XCTAssertEqual(
            try XCTUnwrap(viewModel.cameraPosition.region).center.latitude,
            TransitCity.hamburg.mapRegion.center.latitude,
            accuracy: 0.001
        )
    }

    func testHamburgNetworkProvidesSearchableStations() async throws {
        let repository = NetworkTransitRepository()

        let stations = try await repository.fetchStations(for: .hamburg)
        let lines = try await repository.fetchLines(for: .hamburg)

        XCTAssertFalse(stations.isEmpty)
        XCTAssertFalse(lines.isEmpty)
        XCTAssertTrue(stations.contains { $0.name == "Hamburg Hbf" })
        XCTAssertFalse(stations.contains { $0.name.contains("Alexanderplatz") })
        XCTAssertTrue(
            lines.allSatisfy {
                $0.routeType == TransitRouteType.sBahn
                    || $0.routeType == TransitRouteType.uBahn
            }
        )
    }

    func testCreatedReportUsesCategoryExpiration() throws {
        let viewModel = CreateReportViewModel(
            transitRepository: LocalTransitRepository(),
            city: .berlin
        )
        viewModel.selectedStation = MockTransitData.stations[0]
        viewModel.selectedCategory = .control

        let report = try XCTUnwrap(viewModel.createReport())

        XCTAssertEqual(report.city, .berlin)
        XCTAssertEqual(
            report.expiresAt.timeIntervalSince(report.createdAt),
            ReportCategory.control.expirationInterval,
            accuracy: 0.1
        )
    }

    func testCreateReportFlowRequiresSelectionsBeforeAdvancing() {
        let viewModel = CreateReportViewModel(
            transitRepository: LocalTransitRepository(),
            city: .berlin
        )

        viewModel.continueToNextStep()
        XCTAssertEqual(viewModel.step, .station)

        viewModel.selectStation(MockTransitData.stations[0])
        viewModel.continueToNextStep()
        XCTAssertEqual(viewModel.step, .category)

        viewModel.continueToNextStep()
        XCTAssertEqual(viewModel.step, .category)

        viewModel.selectCategory(.control)
        viewModel.continueToNextStep()
        XCTAssertEqual(viewModel.step, .review)

        viewModel.goBack()
        XCTAssertEqual(viewModel.step, .category)
    }

    func testNearestStationUsesCurrentLocation() async throws {
        let viewModel = CreateReportViewModel(
            transitRepository: LocalTransitRepository(),
            city: .berlin
        )
        let expectedStation = try XCTUnwrap(MockTransitData.stations.first)

        await viewModel.loadStations()
        viewModel.updateNearestStation(
            userLocation: CLLocation(
                latitude: expectedStation.coordinate.latitude,
                longitude: expectedStation.coordinate.longitude
            )
        )

        XCTAssertEqual(
            viewModel.nearestStation?.station.id,
            expectedStation.id
        )
        XCTAssertEqual(
            viewModel.nearestStation?.distance ?? -1,
            0,
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
            2 * 60 * 60,
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
        expiresAt: Date,
        category: ReportCategory = .control,
        city: TransitCity = .berlin
    ) -> Report {
        Report(
            id: UUID(),
            city: city,
            station: station,
            line: nil,
            category: category,
            createdAt: .now,
            expiresAt: expiresAt
        )
    }

    private func makeReport(
        station: TransitStation,
        category: ReportCategory,
        city: TransitCity = .berlin
    ) -> Report {
        makeReport(
            station: station,
            expiresAt: .distantFuture,
            category: category,
            city: city
        )
    }

}

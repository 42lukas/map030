//
//  MapViewModel.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import MapKit
import Observation
import SwiftUI

@Observable
@MainActor
final class MapViewModel {
    var cameraPosition: MapCameraPosition

    private var reportsByCity: [TransitCity: [Report]]

    private(set) var activeSheet: MapSheet?
    private(set) var transitioningToCity: TransitCity?
    private(set) var zoomLevel: MapZoomLevel = .station
    private(set) var selectedCity: TransitCity

    init(
        selectedCity: TransitCity = .berlin,
        reports: [Report]? = nil
    ) {
        self.selectedCity = selectedCity
        cameraPosition = .userLocation(
            followsHeading: false,
            fallback: .region(selectedCity.mapRegion)
        )

        reportsByCity = Dictionary(
            grouping: reports ?? MockTransitData.reports,
            by: \.city
        )
    }

    var reports: [Report] {
        reportsByCity[selectedCity] ?? []
    }

    var isUserFocused: Bool {
        return !cameraPosition.positionedByUser
    }

    var reportClusters: [StationReportCluster] {
        let stationClusters: [StationReportCluster] = Dictionary(grouping: reports) {
            $0.station.id
        }
        .compactMap { _, reports -> StationReportCluster? in
            guard let station = reports.first?.station else {
                return nil
            }

            return StationReportCluster(
                station: station,
                reports: reports
            )
        }
        .sorted { first, second in
            first.station.id < second.station.id
        }

        return GeographicReportClustering.cluster(
            stationClusters,
            within: zoomLevel.clusteringDistance
        )
        .sorted {
            $0.title.localizedStandardCompare(
                $1.title
            ) == .orderedAscending
        }
    }

    var reportSummaries: [ReportCategorySummary] {
        Self.reportSummaryCategoryOrder.compactMap { category in
            let categoryReports =
                reports
                .filter { $0.category == category }
                .sorted { $0.createdAt > $1.createdAt }

            guard !categoryReports.isEmpty else {
                return nil
            }

            return ReportCategorySummary(
                category: category,
                reports: categoryReports
            )
        }
    }

    var selectedReportID: UUID? {
        guard case .report(let report) = activeSheet else {
            return nil
        }

        return report.id
    }

    var selectedClusterID: String? {
        guard case .cluster(let cluster) = activeSheet else {
            return nil
        }

        return cluster.id
    }

    func recenter() {
        cameraPosition = .userLocation(
            followsHeading: false,
            fallback: .region(selectedCity.mapRegion)
        )
    }

    func selectCity(_ city: TransitCity) {
        guard city != selectedCity else {
            return
        }

        selectedCity = city
        cameraPosition = .region(city.mapRegion)
        zoomLevel = .station
        activeSheet = nil
        clearSelection()
    }

    func transition(to city: TransitCity) async {
        guard city != selectedCity, transitioningToCity == nil else {
            return
        }

        transitioningToCity = city

        defer {
            if transitioningToCity == city {
                transitioningToCity = nil
            }
        }

        do {
            try await Task.sleep(for: Self.transitionIntroDuration)
            selectCity(city)
            try await Task.sleep(for: Self.networkLoadDuration)
        } catch {
            return
        }
    }

    func limitZoomOut(camera: MapCamera) {
        guard camera.distance > Self.maximumCameraDistance else {
            return
        }

        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: camera.centerCoordinate,
                distance: Self.maximumCameraDistance,
                heading: camera.heading,
                pitch: camera.pitch
            )
        )
    }

    func updateZoomLevel(
        longitudeDelta: CLLocationDegrees
    ) {
        switch longitudeDelta {
        case ..<0.015:
            zoomLevel = .detail

        case ..<0.08:
            zoomLevel = .station

        default:
            zoomLevel = .overview
        }
    }

    // MARK: - Report Section
    private(set) var selectedReport: Report?
    private(set) var selectedCluster: StationReportCluster?

    func clearSelection() {
        selectedReport = nil
        selectedCluster = nil
    }

    func addReport(_ report: Report) {
        reportsByCity[report.city, default: []].append(report)
    }

    func monitorExpiredReports() async {
        removeExpiredReports()

        while !Task.isCancelled {
            do {
                try await Task.sleep(
                    for: Self.expirationCheckInterval
                )
            } catch {
                return
            }

            removeExpiredReports()
        }
    }

    func removeExpiredReports(at date: Date = .now) {
        let expiredReportIDs = Set(
            reportsByCity.values
                .flatMap { $0 }
                .filter { $0.expiresAt <= date }
                .map(\.id)
        )

        guard !expiredReportIDs.isEmpty else {
            return
        }

        for city in TransitCity.allCases {
            reportsByCity[city]?.removeAll {
                expiredReportIDs.contains($0.id)
            }
        }

        switch activeSheet {
        case .report(let report)
        where expiredReportIDs.contains(report.id):
            activeSheet = nil

        case .cluster(let cluster)
        where cluster.reports.contains(
            where: { expiredReportIDs.contains($0.id) }
        ):
            activeSheet = nil

        default:
            break
        }
    }

    func selectCluster(_ cluster: StationReportCluster) {
        if let report = cluster.singleReport {
            activeSheet = .report(report)
        } else {
            activeSheet = .cluster(cluster)
        }
    }

    func selectReport(_ report: Report) {
        activeSheet = .report(report)
    }

    func presentCreateReport() {
        activeSheet = .createReport
    }

    func presentReportSummary() {
        activeSheet = .reportSummary
    }

    func dismissSheet() {
        activeSheet = nil
    }

    private static let expirationCheckInterval: Duration = .seconds(30)
    private static let transitionIntroDuration: Duration = .milliseconds(180)
    private static let networkLoadDuration: Duration = .milliseconds(1_250)
    static let maximumCameraDistance: CLLocationDistance = 1_800_000
    private static let reportSummaryCategoryOrder: [ReportCategory] = [
        .control,
        .disruption,
        .cancellation,
        .delay,
        .crowding,
        .accessClosed,
        .elevatorOutOfService,
        .escalatorOutOfService,
        .other,
    ]

}

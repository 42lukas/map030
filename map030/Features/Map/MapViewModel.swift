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
    private(set) var activeSheet: MapSheet?
    private(set) var zoomLevel: MapZoomLevel = .station

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
            fallback: .region(Self.berlinRegion)
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
        reports.append(report)
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
            reports
                .filter { $0.expiresAt <= date }
                .map(\.id)
        )

        guard !expiredReportIDs.isEmpty else {
            return
        }

        reports.removeAll {
            expiredReportIDs.contains($0.id)
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

    func dismissSheet() {
        activeSheet = nil
    }


    private static let expirationCheckInterval: Duration = .seconds(30)

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

//
//  StationReportCluster.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import CoreLocation
import Foundation

struct StationReportCluster: Identifiable {
    let stations: [TransitStation]
    let reports: [Report]

    init(station: TransitStation, reports: [Report]) {
        self.stations = [station]
        self.reports = reports
    }

    init(stations: [TransitStation], reports: [Report]) {
        self.stations = stations
        self.reports = reports
    }

    var station: TransitStation {
        stations[0]
    }

    var coordinate: CLLocationCoordinate2D {
        let count = Double(stations.count)
        let latitude = stations.reduce(0) {
            $0 + $1.coordinate.latitude
        }
        let longitude = stations.reduce(0) {
            $0 + $1.coordinate.longitude
        }

        return CLLocationCoordinate2D(
            latitude: latitude / count,
            longitude: longitude / count
        )
    }

    var title: String {
        if stations.count == 1 {
            return station.name
        }

        return "\(stations.count) Haltestellen"
    }

    var canSpiderfy: Bool {
        stations.count == 1 && reports.count > 1 && reports.count <= 8
    }

    var containsOnlyControls: Bool {
        !reports.isEmpty && reports.allSatisfy {
            $0.category == .control
        }
    }

    var id: String {
        stations
            .map(\.id)
            .sorted()
            .joined(separator: "-")
    }

    var count: Int {
        reports.count
    }

    var singleReport: Report? {
        guard reports.count == 1 else {
            return nil
        }

        return reports.first
    }
}

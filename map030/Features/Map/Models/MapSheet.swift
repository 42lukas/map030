//
//  MapSheet.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import Foundation

enum MapSheet: Identifiable {
    case report(Report)
    case cluster(StationReportCluster)
    case createReport

    var id: String {
        switch self {
        case .report(let report):
            "report-\(report.id)"

        case .cluster(let cluster):
            "cluster-\(cluster.id)"

        case .createReport:
            "create-report"
        }
    }
}

//
//  ReportClusterDetailView.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI

struct ReportClusterDetailView: View {
    let cluster: StationReportCluster
    let onSelectReport: (Report) -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(cluster.reports) { report in
                        Button {
                            onSelectReport(report)
                        } label: {
                            ReportListRow(
                                report: report,
                                showsStationName: cluster.stations.count > 1
                            )
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text(
                        "\(cluster.count) Meldungen"
                    )
                }
            }
            .navigationTitle(
                cluster.title
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

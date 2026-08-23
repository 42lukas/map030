//
//  ExpandedReportClusterView.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI

struct ExpandedReportClusterView: View {

    let cluster: StationReportCluster
    let selectedReportID: UUID?
    let onSelect: (Report) -> Void

    var body: some View {
        ZStack {
            stationCenter

            ForEach(
                Array(cluster.reports.enumerated()),
                id: \.element.id
            ) { index, report in
                Button {
                    onSelect(report)
                } label: {
                    ReportMarkerView(
                        report: report,
                        isSelected: selectedReportID == report.id
                    )
                }
                .buttonStyle(.plain)
                .offset(
                    SpiderfyLayout.offset(
                        index: index,
                        count: cluster.reports.count
                    )
                )
            }
        }
        .frame(width: 150, height: 150)
    }

    private var stationCenter: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .frame(width: 26, height: 26)
            .overlay {
                Image(systemName: "tram.fill")
                    .font(.caption)
            }
    }
}

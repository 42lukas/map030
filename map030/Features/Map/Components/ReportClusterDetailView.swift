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
                            HStack(spacing: AppSpacing.md) {
                                ReportCategoryIcon(
                                    category: report.category
                                )

                                VStack(
                                    alignment: .leading,
                                    spacing: 4
                                ) {
                                    Text(
                                        report.category.displayName
                                    )
                                    .foregroundStyle(.primary)

                                    if cluster.stations.count > 1 {
                                        Text(report.station.name)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    HStack(spacing: 6) {
                                        if let line = report.line {
                                            TransitLineBadge(
                                                line: line
                                            )
                                        }

                                        Text(
                                            report.createdAt,
                                            style: .relative
                                        )
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    }
                                }

                                Spacer()

                                Image(
                                    systemName: "chevron.right"
                                )
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                            }
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

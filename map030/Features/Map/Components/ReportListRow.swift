//
//  ReportListRow.swift
//  map030
//
//  Created by Lukas Karsten on 03.09.26.
//

import SwiftUI

struct ReportListRow: View {
    let report: Report
    let showsStationName: Bool

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ReportCategoryIcon(category: report.category)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(report.category.displayName)
                    .foregroundStyle(.primary)

                if showsStationName {
                    Text(report.station.name)
                        .font(AppTypography.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: AppSpacing.sm) {
                    if let line = report.line {
                        TransitLineBadge(line: line)
                    }

                    Text(report.createdAt, style: .relative)
                        .font(AppTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(AppTypography.caption)
                .foregroundStyle(.tertiary)
        }
        .contentShape(Rectangle())
    }
}

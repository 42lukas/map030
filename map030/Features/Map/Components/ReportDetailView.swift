
//
//  ReportDetailView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI

struct ReportDetailView: View {
    let report: Report

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
            stationHeader

            categoryCard

            metadata
        }
        .padding(AppSpacing.lg)
    }

    private var stationHeader: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(report.station.name)
                .font(AppTypography.title)

            if let line = report.line {
                TransitLineBadge(line: line)
            } else if !report.station.uniqueLines.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach(report.station.uniqueLines) { line in
                            TransitLineBadge(line: line)
                        }
                    }
                }
            }
        }
    }

    private var categoryCard: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: report.category.systemImage)
                .font(.title2)
                .foregroundStyle(report.category.symbolColor)
                .frame(width: 40, height: 40)
                .background(report.category.tintColor)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(report.category.displayName)
                    .font(.headline)

                Text(report.category.detailDescription)
                    .font(AppTypography.secondary)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(AppSpacing.md)
        .background(report.category.tintColor.opacity(0.12))
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.lg,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: AppRadius.lg,
                style: .continuous
            )
            .stroke(
                report.category.tintColor.opacity(0.3),
                lineWidth: 1
            )
        }
    }

    private var metadata: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            metadataRow(
                systemName: "clock",
                title: "Erstellt",
                date: report.createdAt
            )

            metadataRow(
                systemName: "hourglass",
                title: "Läuft ab",
                date: report.expiresAt
            )
        }
    }

    private func metadataRow(
        systemName: String,
        title: String,
        date: Date
    ) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: systemName)
                .frame(width: AppSpacing.lg)

            Text(title)

            Spacer()

            Text(date, style: .relative)
        }
        .font(AppTypography.secondary)
        .foregroundStyle(.secondary)
    }
}

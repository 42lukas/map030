//
//  ReportSummaryDetailView.swift
//  map030
//
//  Created by Lukas Karsten on 03.09.26.
//

import SwiftUI

struct ReportSummaryDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let summaries: [ReportCategorySummary]
    let onSelectReport: (Report) -> Void

    var body: some View {
        NavigationStack {
            Group {
                if summaries.isEmpty {
                    emptyState
                } else {
                    summaryContent
                }
            }
            .background(AppColors.surface)
            .navigationTitle("Meldungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.circle)
                    .accessibilityLabel("Schließen")
                }
            }
        }
    }

    private var summaryContent: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                overview

                ForEach(summaries) { summary in
                    categoryCard(summary)
                }
            }
            .padding(AppSpacing.lg)
        }
    }

    private var overview: some View {
        HStack(spacing: AppSpacing.md) {
            metric(
                value: totalCount,
                title: "Aktiv",
                systemImage: "bell.fill",
                tint: AppColors.accent
            )

            metric(
                value: controlCount,
                title: "Kontrollen",
                systemImage: ReportCategory.control.systemImage,
                tint: ReportCategory.control.tintColor
            )
        }
    }

    private func metric(
        value: Int,
        title: String,
        systemImage: String,
        tint: Color
    ) -> some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: systemImage)
                .font(AppTypography.sectionTitle)
                .foregroundStyle(tint)
                .frame(width: AppSpacing.xxl, height: AppSpacing.xxl)
                .background(tint.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(value.formatted())
                    .font(AppTypography.title)

                Text(title)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity)
        .background(AppColors.elevatedSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.lg,
                style: .continuous
            )
        )
    }

    private func categoryCard(
        _ summary: ReportCategorySummary
    ) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: summary.category.systemImage)
                    .foregroundStyle(summary.category.tintColor)

                Text(summary.category.displayName)
                    .font(AppTypography.sectionTitle)

                Spacer()

                Text(summary.count.formatted())
                    .font(AppTypography.caption.weight(.semibold))
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xs)
                    .background(summary.category.tintColor.opacity(0.12))
                    .foregroundStyle(summary.category.tintColor)
                    .clipShape(Capsule())
            }
            .padding(AppSpacing.md)

            Divider()

            ForEach(Array(summary.reports.enumerated()), id: \.element.id) {
                index,
                report in
                Button {
                    onSelectReport(report)
                } label: {
                    ReportListRow(
                        report: report,
                        showsStationName: true
                    )
                    .padding(AppSpacing.md)
                }
                .buttonStyle(.plain)

                if index < summary.reports.count - 1 {
                    Divider()
                        .padding(.leading, AppSpacing.md + AppSpacing.xxl)
                }
            }
        }
        .background(AppColors.elevatedSurface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.lg,
                style: .continuous
            )
        )
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "Keine aktiven Meldungen",
            systemImage: "checkmark.circle",
            description: Text(
                "Neue Meldungen erscheinen hier automatisch."
            )
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var totalCount: Int {
        summaries.reduce(0) { result, summary in
            result + summary.count
        }
    }

    private var controlCount: Int {
        summaries.first { $0.category == .control }?.count ?? 0
    }
}

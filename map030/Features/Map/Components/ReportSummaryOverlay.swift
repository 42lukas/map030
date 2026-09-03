//
//  ReportSummaryOverlay.swift
//  map030
//
//  Created by Lukas Karsten on 03.09.26.
//

import SwiftUI

struct ReportSummaryOverlay: View {
    let summaries: [ReportCategorySummary]
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                reportSummary
                Divider()
                controlSummary
            }
            .padding(AppSpacing.md)
            .frame(width: 220, alignment: .leading)
            .background(.regularMaterial)
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
                .stroke(AppColors.divider.opacity(0.5), lineWidth: 1)
            }
            .shadow(
                color: .black.opacity(0.14),
                radius: AppRadius.md,
                y: AppSpacing.xs
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Meldungsübersicht")
        .accessibilityValue("\(totalCount) aktive Meldungen")
        .accessibilityHint("Öffnet alle Meldungen")
    }

    private var reportSummary: some View {
        HStack(spacing: AppSpacing.sm) {
            Text("Meldungen")
                .font(AppTypography.sectionTitle)

            Spacer()

            Text(totalCount.formatted())
                .font(AppTypography.secondary.weight(.bold))
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xs)
                .background(AppColors.accent.opacity(0.12))
                .foregroundStyle(AppColors.accent)
                .clipShape(Capsule())

            Image(systemName: "chevron.right")
                .font(AppTypography.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
    }

    private var controlSummary: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: ReportCategory.control.systemImage)
                .font(AppTypography.caption.weight(.semibold))
                .foregroundStyle(ReportCategory.control.tintColor)
                .frame(width: AppSpacing.lg)

            Text("Kontrollen")
                .font(AppTypography.secondary)

            Spacer()

            Text(controlCount.formatted())
                .font(AppTypography.secondary.weight(.semibold))
                .foregroundStyle(.secondary)
        }
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

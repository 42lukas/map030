//
//  CreateReportProgressView.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import SwiftUI

struct CreateReportProgressView: View {
    let step: CreateReportStep

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("Schritt \(step.rawValue + 1) von \(CreateReportStep.allCases.count)")
                    .font(AppTypography.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(
                value: Double(step.rawValue + 1),
                total: Double(CreateReportStep.allCases.count)
            )
            .tint(AppColors.accent)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(step.title)
                    .font(AppTypography.title)

                Text(step.description)
                    .font(AppTypography.secondary)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
    }
}

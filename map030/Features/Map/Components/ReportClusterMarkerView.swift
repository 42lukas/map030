//
//  ReportClusterMarkerView.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI

struct ReportClusterMarkerView: View {
    let cluster: StationReportCluster
    let isSelected: Bool

    var body: some View {
        VStack(spacing: -6) {
            RoundedRectangle(
                cornerRadius: AppRadius.md,
                style: .continuous
            )
            .fill(.primary)
            .frame(width: 46, height: 46)
            .overlay {
                VStack(spacing: AppSpacing.xs) {
                    Text("\(cluster.count)")
                        .font(.subheadline.weight(.bold))

                    categoryIndicators
                }
                .foregroundStyle(Color(.systemBackground))
            }
            .overlay {
                RoundedRectangle(
                    cornerRadius: AppRadius.md,
                    style: .continuous
                )
                .stroke(
                    Color(.systemBackground),
                    lineWidth: 2
                )
            }

            RoundedRectangle(cornerRadius: 2)
                .fill(.primary)
                .frame(width: 10, height: 10)
                .rotationEffect(.degrees(45))
        }
        .scaleEffect(isSelected ? 1.12 : 1)
        .shadow(
            color: .black.opacity(0.22),
            radius: 5,
            y: 3
        )
        .animation(
            .easeInOut(duration: 0.18),
            value: isSelected
        )
    }

    private var categoryIndicators: some View {
        HStack(spacing: AppSpacing.xs) {
            ForEach(
                Array(categories.enumerated()),
                id: \.offset
            ) { _, category in
                Circle()
                    .fill(
                        category == .control
                            ? Color.red
                            : category.tintColor
                    )
                    .frame(width: 5, height: 5)
            }
        }
    }

    private var categories: [ReportCategory] {
        ReportCategory.allCases
            .filter { category in
                cluster.reports.contains {
                    $0.category == category
                }
            }
            .prefix(3)
            .map { $0 }
    }
}

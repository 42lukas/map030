//
//  StandardReportMarkerView.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import SwiftUI

struct StandardReportMarkerView: View {
    let report: Report
    let isSelected: Bool

    var body: some View {
        VStack(spacing: -6) {
            RoundedRectangle(
                cornerRadius: AppRadius.md,
                style: .continuous
            )
            .fill(
                LinearGradient(
                    colors: [
                        report.category.tintColor.opacity(0.82),
                        report.category.tintColor
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 42, height: 42)
            .overlay {
                Image(systemName: report.category.systemImage)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(report.category.symbolColor)
            }
            .overlay {
                RoundedRectangle(
                    cornerRadius: AppRadius.md,
                    style: .continuous
                )
                .stroke(Color(.systemBackground), lineWidth: 2)
            }

            RoundedRectangle(cornerRadius: 2)
                .fill(report.category.tintColor)
                .frame(width: 10, height: 10)
                .rotationEffect(.degrees(45))
        }
        .frame(width: 68, height: 58)
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
}

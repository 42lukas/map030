//
//  LineSelectionSection.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import SwiftUI

struct LineSelectionSection: View {

    let lines: [TransitLine]
    let selectedLine: TransitLine?
    let onSelect: (TransitLine) -> Void
    let onClear: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("Betroffene Linie")
                    .font(AppTypography.sectionTitle)

                Text("Optional – ohne Auswahl gilt die Meldung für die ganze Station.")
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
            }

            if lines.isEmpty {
                Text("Für diese Station sind keine Linien verfügbar.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {
                    HStack(spacing: AppSpacing.sm) {
                        Button {
                            onClear()
                        } label: {
                            lineLabel(
                                title: "Ganze Station",
                                isSelected: selectedLine == nil
                            )
                        }
                        .buttonStyle(.plain)

                        ForEach(lines) { line in
                            lineButton(line)
                        }
                    }
                }
            }
        }
    }

    private func lineButton(
        _ line: TransitLine
    ) -> some View {
        let isSelected = selectedLine?.id == line.id

        return Button {
            onSelect(line)
        } label: {
            lineLabel(
                title: line.name,
                isSelected: isSelected
            )
        }
        .buttonStyle(.plain)
    }

    private func lineLabel(
        title: String,
        isSelected: Bool
    ) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Text(title)
                .font(AppTypography.secondary.weight(.semibold))

            if isSelected {
                Image(systemName: "checkmark")
                    .font(AppTypography.caption.weight(.bold))
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(
            isSelected
                ? AnyShapeStyle(AppColors.accent.opacity(0.14))
                : AnyShapeStyle(.quaternary)
        )
        .foregroundStyle(isSelected ? AppColors.accent : .primary)
        .clipShape(Capsule())
    }
}

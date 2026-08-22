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

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Text("Linie")
                    .font(.headline)

                Text("Optional")
                    .font(.caption)
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
                    HStack(spacing: 8) {
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
            HStack(spacing: 6) {
                Text(line.name)
                    .font(.subheadline.weight(.semibold))

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.bold))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected
                    ? AnyShapeStyle(.primary.opacity(0.12))
                    : AnyShapeStyle(.quaternary)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

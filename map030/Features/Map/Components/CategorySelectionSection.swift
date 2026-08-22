//
//  CategorySelectionSection.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import SwiftUI

struct CategorySelectionSection: View {

    let selectedCategory: ReportCategory?
    let onSelect: (ReportCategory) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kategorie")
                .font(.headline)

            VStack(spacing: 0) {
                ForEach(
                    ReportCategory.allCases,
                    id: \.self
                ) { category in
                    Button {
                        onSelect(category)
                    } label: {
                        HStack(spacing: 12) {
                            Image(
                                systemName: systemImage(
                                    for: category
                                )
                            )
                            .frame(width: 24)

                            Text(category.displayName)

                            Spacer()

                            if selectedCategory == category {
                                Image(
                                    systemName: "checkmark.circle.fill"
                                )
                            }
                        }
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)

                    if category != ReportCategory.allCases.last {
                        Divider()
                            .padding(.leading, 50)
                    }
                }
            }
            .background(.thinMaterial)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
            )
        }
    }

    private func systemImage(
        for category: ReportCategory
    ) -> String {
        switch category {
        case .control:
            "person.badge.shield.checkmark"

        case .crowding:
            "person.3.fill"

        case .delay:
            "clock.fill"

        case .cancellation:
            "xmark.circle.fill"

        case .elevatorOutOfService:
            "figure.roll"

        case .escalatorOutOfService:
            "stairs"

        case .accessClosed:
            "door.left.hand.closed"

        case .disruption:
            "exclamationmark.triangle.fill"

        case .other:
            "ellipsis.circle.fill"
        }
    }
}

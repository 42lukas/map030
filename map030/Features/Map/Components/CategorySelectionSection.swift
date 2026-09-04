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

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.sm),
        GridItem(.flexible(), spacing: AppSpacing.sm),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
                ForEach(
                    ReportCategory.allCases,
                    id: \.self
                ) { category in
                    Button {
                        onSelect(category)
                    } label: {
                        VStack(
                            alignment: .leading,
                            spacing: AppSpacing.sm
                        ) {
                            HStack {
                                ReportCategoryIcon(
                                    category: category
                                )

                                Spacer()

                                if selectedCategory == category {
                                    Image(
                                        systemName: "checkmark.circle.fill"
                                    )
                                    .foregroundStyle(category.tintColor)
                                }
                            }

                            Text(category.displayName)
                                .font(AppTypography.body.weight(.semibold))

                            Text(category.detailDescription)
                                .font(AppTypography.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 112,
                            alignment: .topLeading
                        )
                        .foregroundStyle(.primary)
                        .padding(AppSpacing.md)
                        .background(
                            selectedCategory == category
                                ? category.tintColor.opacity(0.12)
                                : AppColors.surface
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: AppRadius.md,
                                style: .continuous
                            )
                        )
                        .overlay {
                            RoundedRectangle(
                                cornerRadius: AppRadius.md,
                                style: .continuous
                            )
                            .stroke(
                                selectedCategory == category
                                    ? category.tintColor.opacity(0.65)
                                    : .clear,
                                lineWidth: 1.5
                            )
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

}

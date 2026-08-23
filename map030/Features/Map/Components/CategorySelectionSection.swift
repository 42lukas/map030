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
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Kategorie")
                .font(AppTypography.sectionTitle)

            VStack(spacing: AppSpacing.xs) {
                ForEach(
                    ReportCategory.allCases,
                    id: \.self
                ) { category in
                    Button {
                        onSelect(category)
                    } label: {
                        HStack(spacing: AppSpacing.md) {
                            ReportCategoryIcon(
                                category: category
                            )

                            VStack(
                                alignment: .leading,
                                spacing: AppSpacing.xs
                            ) {
                                Text(category.displayName)
                                    .font(AppTypography.body.weight(.medium))

                                Text(category.detailDescription)
                                    .font(AppTypography.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if selectedCategory == category {
                                Image(
                                    systemName: "checkmark.circle.fill"
                                )
                                .foregroundStyle(category.tintColor)
                            }
                        }
                        .foregroundStyle(.primary)
                        .padding(AppSpacing.md)
                        .background {
                            if selectedCategory == category {
                                RoundedRectangle(
                                    cornerRadius: AppRadius.md,
                                    style: .continuous
                                )
                                .fill(category.tintColor.opacity(0.12))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(AppSpacing.xs)
            .background(AppColors.surface)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppRadius.lg,
                    style: .continuous
                )
            )
        }
    }

}

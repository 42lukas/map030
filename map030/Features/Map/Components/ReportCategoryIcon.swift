//
//  ReportCategoryIcon.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI

struct ReportCategoryIcon: View {
    let category: ReportCategory

    var body: some View {
        Image(systemName: category.systemImage)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(category.symbolColor)
            .frame(
                width: AppSpacing.xxl,
                height: AppSpacing.xxl
            )
            .background(category.tintColor)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppRadius.sm,
                    style: .continuous
                )
            )
    }
}

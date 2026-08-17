
//
//  ReportDetailView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI

struct ReportDetailView: View {
    let report: Report

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(report.category.displayName)
                .font(.title2)
                .fontWeight(.semibold)

            Text(report.createdAt, style: .relative)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

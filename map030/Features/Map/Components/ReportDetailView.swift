
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
        VStack(alignment: .leading, spacing: 8) {
            Text(report.station.name)
                .font(.title2)
                .fontWeight(.semibold)

            if let line = report.line {
                Text(line.name)
                    .font(.headline)
            }

            Text(report.category.displayName)

            Text(report.createdAt, style: .relative)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

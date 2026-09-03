//
//  ReportMarkerView.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI

struct ReportMarkerView: View {
    let report: Report
    let isSelected: Bool

    @ViewBuilder
    var body: some View {
        if report.category == .control {
            ControlReportMarkerView(
                count: 1,
                isSelected: isSelected
            )
        } else {
            StandardReportMarkerView(
                report: report,
                isSelected: isSelected
            )
        }
    }
}

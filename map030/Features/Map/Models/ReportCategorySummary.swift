//
//  ReportCategorySummary.swift
//  map030
//
//  Created by Lukas Karsten on 03.09.26.
//

import Foundation

struct ReportCategorySummary: Identifiable {
    let category: ReportCategory
    let reports: [Report]

    var id: String {
        category.displayName
    }

    var count: Int {
        reports.count
    }
}

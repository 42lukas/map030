//
//  Report.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import Foundation

struct Report: Identifiable {
    let id: UUID
    let station: TransitStation
    let line: TransitLine?
    let category: ReportCategory
    let createdAt: Date
}

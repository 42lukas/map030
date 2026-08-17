//
//  Report.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import Foundation
import MapKit

struct Report: Identifiable {
    let id: UUID
    let category: ReportCategory
    let coordinate: CLLocationCoordinate2D
    let createdAt: Date
}

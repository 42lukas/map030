//
//  CreateReportViewModel.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import CoreLocation
import Observation

@Observable
@MainActor
final class CreateReportViewModel {
    var selectedCategory: ReportCategory?

    var canCreateReport: Bool {
        selectedCategory != nil
    }

    func createReport(at coordinate: CLLocationCoordinate2D) -> Report? {
        guard let selectedCategory else {
            return nil
        }

        return Report(
            id: UUID(),
            category: selectedCategory,
            coordinate: coordinate,
            createdAt: .now
        )
    }
}

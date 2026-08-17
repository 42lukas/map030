//
//  CreateReportViewModel.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import Foundation

@Observable
@MainActor
final class CreateReportViewModel {

    let stations: [TransitStation]

    var selectedStation: TransitStation?
    var selectedLine: TransitLine?
    var selectedCategory: ReportCategory?

    init(stations: [TransitStation]) {
        self.stations = stations
    }

    var availableLines: [TransitLine] {
        selectedStation?.lines ?? []
    }

    var canCreateReport: Bool {
        selectedStation != nil &&
        selectedCategory != nil
    }

    func selectStation(_ station: TransitStation) {
        selectedStation = station
        selectedLine = nil
    }

    func createReport() -> Report? {
        guard
            let selectedStation,
            let selectedCategory
        else {
            return nil
        }

        return Report(
            id: UUID(),
            station: selectedStation,
            line: selectedLine,
            category: selectedCategory,
            createdAt: .now
        )
    }
}

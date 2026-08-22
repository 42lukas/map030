//
//  CreateReportViewModel.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import Foundation
import Observation

@Observable
@MainActor
final class CreateReportViewModel {

    private let transitRepository: any TransitRepository

    private(set) var stations: [TransitStation] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    var selectedStation: TransitStation?
    var selectedLine: TransitLine?
    var selectedCategory: ReportCategory?

    init(transitRepository: any TransitRepository) {
        self.transitRepository = transitRepository
    }

    var availableLines: [TransitLine] {
        selectedStation?.lines ?? []
    }

    var canCreateReport: Bool {
        selectedStation != nil &&
        selectedCategory != nil
    }
    
    var searchText = ""

    var filteredStations: [TransitStation] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return stations
        }

        return stations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    func loadStations() async {
        guard stations.isEmpty else {
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            stations = try await transitRepository.fetchStations()
        } catch {
            errorMessage = "Stationen konnten nicht geladen werden."
        }

        isLoading = false
    }

    func selectStation(_ station: TransitStation) {
        selectedStation = station
        selectedLine = nil
    }
    
    func selectLine(_ line: TransitLine) {
        if selectedLine?.id == line.id {
            selectedLine = nil
        } else {
            selectedLine = line
        }
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

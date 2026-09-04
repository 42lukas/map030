//
//  CreateReportViewModel.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import CoreLocation
import Foundation
import Observation

@Observable
@MainActor
final class CreateReportViewModel {

    private let transitRepository: any TransitRepository
    private let city: TransitCity

    private(set) var nearestStation: NearbyStation?
    private(set) var stations: [TransitStation] = []
    private(set) var isLoading = true
    private(set) var errorMessage: String?
    private(set) var step: CreateReportStep = .station

    var selectedStation: TransitStation?
    var selectedLine: TransitLine?
    var selectedCategory: ReportCategory?

    init(
        transitRepository: any TransitRepository,
        city: TransitCity
    ) {
        self.transitRepository = transitRepository
        self.city = city
    }

    var availableLines: [TransitLine] {
        selectedStation?.uniqueLines ?? []
    }

    var canCreateReport: Bool {
        selectedStation != nil && selectedCategory != nil
    }

    var canContinue: Bool {
        switch step {
        case .station:
            selectedStation != nil
        case .category:
            selectedCategory != nil
        case .review:
            canCreateReport
        }
    }

    var canGoBack: Bool {
        step != .station
    }

    var searchText = ""

    var filteredStations: [TransitStation] {
        let query =
            searchText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !query.isEmpty else {
            return []
        }

        return
            stations
            .filter {
                $0.name.localizedStandardContains(query)
            }
            .sorted { lhs, rhs in
                let lhsPriority = searchPriority(
                    for: lhs,
                    query: query
                )

                let rhsPriority = searchPriority(
                    for: rhs,
                    query: query
                )

                if lhsPriority != rhsPriority {
                    return lhsPriority < rhsPriority
                }

                return lhs.name.localizedStandardCompare(
                    rhs.name
                ) == .orderedAscending
            }
            .prefix(20)
            .map { $0 }
    }

    func loadStations() async {
        guard stations.isEmpty else {
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            stations = try await transitRepository.fetchStations(
                for: city
            )
        } catch {
            errorMessage = "Stationen konnten nicht geladen werden."
        }

        isLoading = false
    }

    func selectStation(_ station: TransitStation) {
        selectedStation = station
        selectedLine = nil
        searchText = ""
    }

    func selectLine(_ line: TransitLine) {
        if selectedLine?.id == line.id {
            selectedLine = nil
        } else {
            selectedLine = line
        }
    }

    func clearSelectedLine() {
        selectedLine = nil
    }

    func selectCategory(_ category: ReportCategory) {
        selectedCategory = category
    }

    func continueToNextStep() {
        guard
            canContinue,
            let nextStep = CreateReportStep(
                rawValue: step.rawValue + 1
            )
        else {
            return
        }

        step = nextStep
    }

    func goBack() {
        guard
            let previousStep = CreateReportStep(
                rawValue: step.rawValue - 1
            )
        else {
            return
        }

        step = previousStep
    }

    func createReport() -> Report? {
        guard
            let selectedStation,
            let selectedCategory
        else {
            return nil
        }

        let createdAt = Date()

        return Report(
            id: UUID(),
            city: city,
            station: selectedStation,
            line: selectedLine,
            category: selectedCategory,
            createdAt: createdAt,
            expiresAt: createdAt.addingTimeInterval(
                selectedCategory.expirationInterval
            )
        )
    }

    func updateNearestStation(userLocation: CLLocation) {
        nearestStation =
            stations
            .map { station in
                let stationLocation = CLLocation(
                    latitude: station.coordinate.latitude,
                    longitude: station.coordinate.longitude
                )

                return NearbyStation(
                    station: station,
                    distance: stationLocation.distance(
                        from: userLocation
                    )
                )
            }
            .min { first, second in
                first.distance < second.distance
            }
    }

    private func searchPriority(
        for station: TransitStation,
        query: String
    ) -> Int {
        let name = station.name.lowercased()
        let query = query.lowercased()

        if name == query {
            return 0
        }

        if name.hasPrefix(query) {
            return 1
        }

        return 2
    }
}

//
//  CreateReportViewModel.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import Foundation
import Observation
import CoreLocation

@Observable
@MainActor
final class CreateReportViewModel {

    private let transitRepository: any TransitRepository

    private(set) var nearbyStations: [NearbyStation] = []
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
        let query = searchText
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !query.isEmpty else {
            return []
        }

        return stations
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
    
    func updateNearbyStations(
        userLocation: CLLocation,
        limit: Int = 5
    ) {
        nearbyStations = stations
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
            .filter {
                $0.distance <= Constants.nearbyRadius
            }
            .sorted {
                $0.distance < $1.distance
            }
            .prefix(Constants.maxNearbyStations)
            .map { $0 }
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

private enum Constants {
    static let nearbyRadius: CLLocationDistance = 500
    static let maxNearbyStations = 5
}

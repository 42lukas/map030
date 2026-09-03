//
//  LocalTransitRepository.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import Foundation

final class LocalTransitRepository: TransitRepository {

    private let decoder: JSONDecoder
    private var cachedStations: [TransitStation]?
    private var cachedLines: [TransitLine]?

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func fetchStations() async throws -> [TransitStation] {
        if let cachedStations {
            return cachedStations
        }

        let stationDTOs: [TransitStationDTO] = try load(
            resource: "stations"
        )
        let lines = try await fetchLines()

        let linesByID = Dictionary(
            uniqueKeysWithValues: lines.map {
                ($0.id, $0)
            }
        )

        let stations = stationDTOs.map {
            TransitMapper.mapStation(
                $0,
                linesByID: linesByID
            )
        }

        cachedStations = stations
        return stations
    }

    func fetchLines() async throws -> [TransitLine] {
        if let cachedLines {
            return cachedLines
        }

        let lineDTOs: [TransitLineDTO] = try load(
            resource: "lines"
        )

        let lines = lineDTOs.map(
            TransitMapper.mapLine
        )

        cachedLines = lines
        return lines
    }

    private func load<T: Decodable>(
        resource: String
    ) throws -> T {
        guard let url = Bundle.main.url(
            forResource: resource,
            withExtension: "json"
        ) else {
            throw TransitRepositoryError.resourceNotFound(
                resource
            )
        }

        do {
            let data = try Data(
                contentsOf: url
            )

            return try decoder.decode(
                T.self,
                from: data
            )
        } catch {
            throw TransitRepositoryError.decodingFailed(
                resource,
                error
            )
        }
    }
}

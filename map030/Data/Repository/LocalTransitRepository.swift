//
//  LocalTransitRepository.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import Foundation

final class LocalTransitRepository: TransitRepository {

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func fetchStations() async throws -> [TransitStation] {
        let lineDTOs: [TransitLineDTO] = try load(
            resource: "lines"
        )

        let stationDTOs: [TransitStationDTO] = try load(
            resource: "stations"
        )

        let lines = lineDTOs.map(
            TransitMapper.mapLine
        )

        let linesByID = Dictionary(
            uniqueKeysWithValues: lines.map {
                ($0.id, $0)
            }
        )

        return stationDTOs.map {
            TransitMapper.mapStation(
                $0,
                linesByID: linesByID
            )
        }
    }

    func fetchLines() async throws -> [TransitLine] {
        let lineDTOs: [TransitLineDTO] = try load(
            resource: "lines"
        )

        return lineDTOs.map(
            TransitMapper.mapLine
        )
    }

    func fetchShapes() async throws -> [TransitShape] {
        let shapeDTOs: [
            String: [TransitShapePointDTO]
        ] = try load(
            resource: "shapes"
        )

        return shapeDTOs.map {
            TransitMapper.mapShape(
                id: $0.key,
                points: $0.value
            )
        }
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

//
//  NetworkTransitRepository.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import BerlinTransitNetwork
import HamburgTransitNetwork
import TransitOverlayKit

final class NetworkTransitRepository: TransitRepository {
    private let repository = TransitNetworkRepository()
    private var cachedStations: [TransitCity: [TransitStation]] = [:]
    private var cachedLines: [TransitCity: [TransitLine]] = [:]

    func fetchStations(
        for city: TransitCity
    ) async throws -> [TransitStation] {
        if let stations = cachedStations[city] {
            return stations
        }

        let network = try await network(for: city)
        let stations = NetworkTransitMapper.mapStations(network)
        cachedStations[city] = stations
        return stations
    }

    func fetchLines(
        for city: TransitCity
    ) async throws -> [TransitLine] {
        if let lines = cachedLines[city] {
            return lines
        }

        let network = try await network(for: city)
        let lines = NetworkTransitMapper.mapLines(network)
        cachedLines[city] = lines
        return lines
    }

    private func network(
        for city: TransitCity
    ) async throws -> TransitOverlayKit.TransitNetwork {
        switch city {
        case .berlin:
            try await repository.network(for: BerlinNetwork())
        case .hamburg:
            try await repository.network(for: HamburgNetwork())
        }
    }
}

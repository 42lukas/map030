//
//  TransitRepository.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

protocol TransitRepository {
    func fetchStations(
        for city: TransitCity
    ) async throws -> [TransitStation]

    func fetchLines(
        for city: TransitCity
    ) async throws -> [TransitLine]
}

//
//  TransitRepository.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

protocol TransitRepository {
    func fetchStations() async throws -> [TransitStation]
    func fetchLines() async throws -> [TransitLine]
}

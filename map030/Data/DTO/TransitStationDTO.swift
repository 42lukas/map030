//
//  TransitStationDTO.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import Foundation

struct TransitStationDTO: Decodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let lineIds: [String]
}

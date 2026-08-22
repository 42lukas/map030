//
//  TransitLineDTO.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import Foundation

struct TransitLineDTO: Decodable {
    let id: String
    let name: String
    let longName: String
    let type: Int
    let color: String?
    let textColor: String?
    let shapeIds: [String]
}

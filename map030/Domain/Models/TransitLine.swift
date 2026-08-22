//
//  TransitLine.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import Foundation

struct TransitLine: Identifiable, Hashable {
    let id: String
    let name: String
    let routeType: Int
    let colorHex: String?
    let textColorHex: String?
    let shapeIDs: [String]
}

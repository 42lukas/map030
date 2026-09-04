//
//  TransitCity.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import Foundation

enum TransitCity: String, CaseIterable, Identifiable {
    case berlin
    case hamburg

    var id: String {
        rawValue
    }

    var displayName: String {
        switch self {
        case .berlin:
            "Berlin"
        case .hamburg:
            "Hamburg"
        }
    }

    var shortName: String {
        switch self {
        case .berlin:
            "B"
        case .hamburg:
            "HH"
        }
    }
}

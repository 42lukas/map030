//
//  ReportCategory.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import Foundation

enum ReportCategory: CaseIterable, Equatable {
    case control
    case crowding
    case delay
    case cancellation
    case elevatorOutOfService
    case escalatorOutOfService
    case accessClosed
    case disruption
    case other

    var displayName: String {
        switch self {
        case .control:
            "Kontrolle"
        case .crowding:
            "Überfüllung"
        case .delay:
            "Verspätung"
        case .cancellation:
            "Ausfall"
        case .elevatorOutOfService:
            "Aufzug defekt"
        case .escalatorOutOfService:
            "Rolltreppe defekt"
        case .accessClosed:
            "Zugang gesperrt"
        case .disruption:
            "Störung"
        case .other:
            "Sonstiges"
        }
    }

    var expirationInterval: TimeInterval {
        switch self {
        case .control:
            30 * 60

        case .crowding:
            45 * 60

        case .delay:
            90 * 60

        case .cancellation:
            3 * 60 * 60

        case .elevatorOutOfService:
            24 * 60 * 60

        case .escalatorOutOfService:
            12 * 60 * 60

        case .accessClosed:
            8 * 60 * 60

        case .disruption:
            4 * 60 * 60

        case .other:
            2 * 60 * 60
        }
    }
}

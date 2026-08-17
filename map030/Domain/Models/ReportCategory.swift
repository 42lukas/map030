//
//  ReportCategory.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

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
}

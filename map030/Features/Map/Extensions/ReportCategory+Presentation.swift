//
//  ReportCategory+Presentation.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI

extension ReportCategory {
    var systemImage: String {
        switch self {
        case .control:
            "person.badge.shield.checkmark"
        case .crowding:
            "person.3.fill"
        case .delay:
            "clock.fill"
        case .cancellation:
            "xmark.circle.fill"
        case .elevatorOutOfService:
            "figure.roll"
        case .escalatorOutOfService:
            "stairs"
        case .accessClosed:
            "door.left.hand.closed"
        case .disruption:
            "exclamationmark.triangle.fill"
        case .other:
            "ellipsis.circle.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .control:
            .blue
        case .crowding:
            .orange
        case .delay:
            .yellow
        case .cancellation:
            .red
        case .elevatorOutOfService:
            .purple
        case .escalatorOutOfService:
            .indigo
        case .accessClosed:
            .brown
        case .disruption:
            .pink
        case .other:
            .gray
        }
    }

    var symbolColor: Color {
        switch self {
        case .delay:
            .black
        default:
            .white
        }
    }

    var detailDescription: String {
        switch self {
        case .control:
            "Ticketkontrolle gemeldet"
        case .crowding:
            "Hohe Auslastung vor Ort"
        case .delay:
            "Abweichung vom Fahrplan"
        case .cancellation:
            "Verbindung fällt aus"
        case .elevatorOutOfService:
            "Barrierefreier Zugang eingeschränkt"
        case .escalatorOutOfService:
            "Rolltreppe derzeit nicht nutzbar"
        case .accessClosed:
            "Ein Zugang ist geschlossen"
        case .disruption:
            "Betrieb aktuell beeinträchtigt"
        case .other:
            "Weitere Information zur Station"
        }
    }
}

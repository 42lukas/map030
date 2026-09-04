//
//  CreateReportStep.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import Foundation

enum CreateReportStep: Int, CaseIterable {
    case station
    case category
    case review

    var title: String {
        switch self {
        case .station:
            "Wo ist etwas passiert?"
        case .category:
            "Was möchtest du melden?"
        case .review:
            "Fast geschafft"
        }
    }

    var description: String {
        switch self {
        case .station:
            "Wähle eine Station in deiner Nähe oder suche danach."
        case .category:
            "Wähle die Art der Meldung aus."
        case .review:
            "Prüfe deine Auswahl und ergänze bei Bedarf eine Linie."
        }
    }

    var primaryActionTitle: String {
        switch self {
        case .station,
            .category:
            "Weiter"
        case .review:
            "Meldung veröffentlichen"
        }
    }
}

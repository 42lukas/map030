//
//  ReportCategory.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

enum ReportCategory: CaseIterable, Equatable {
    case transit
    case obstruction
    case notice
    case other

    var displayName: String {
        switch self {
        case .transit:
            "Transit"
        case .obstruction:
            "Obstruction"
        case .notice:
            "Notice"
        case .other:
            "Other"
        }
    }
}

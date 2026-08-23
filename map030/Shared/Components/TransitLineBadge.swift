//
//  TransitLineBadge.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI

enum TransitRouteType {
    static let sBahn = 109
    static let uBahn = 400
    static let tram = 900
}

struct TransitLineBadge: View {
    let line: TransitLine

    var body: some View {
        Text(line.name)
            .font(.caption.weight(.bold))
            .foregroundStyle(textColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .clipShape(Capsule())
    }

    private var backgroundColor: Color {
        if let colorHex = line.colorHex {
            return Color(hex: colorHex)
        }

        if line.routeType == TransitRouteType.tram {
            return Color(hex: "BE1414")
        }

        return .secondary
    }

    private var textColor: Color {
        if let textColorHex = line.textColorHex {
            return Color(hex: textColorHex)
        }

        return .white
    }
}

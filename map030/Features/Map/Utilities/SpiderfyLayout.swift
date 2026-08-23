//
//  SpiderfyLayout.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import CoreGraphics
import Foundation

enum SpiderfyLayout {

    static func offset(
        index: Int,
        count: Int
    ) -> CGSize {
        guard count > 1 else {
            return .zero
        }

        let radius = radius(for: count)

        let angle = (
            Double(index) /
            Double(count)
        ) * 2 * Double.pi - Double.pi / 2

        return CGSize(
            width: cos(angle) * radius,
            height: sin(angle) * radius
        )
    }

    private static func radius(
        for count: Int
    ) -> CGFloat {
        switch count {
        case 2...3:
            38

        case 4...5:
            46

        default:
            54
        }
    }
}

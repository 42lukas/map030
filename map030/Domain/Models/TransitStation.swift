//
//  TransitStation.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import CoreLocation
import Foundation

struct TransitStation: Identifiable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let lines: [TransitLine]
}

extension TransitStation {
    var uniqueLines: [TransitLine] {
        var seen = Set<String>()

        return lines.filter { line in
            let key = "\(line.routeType)-\(line.name)"

            if seen.contains(key) {
                return false
            }

            seen.insert(key)
            return true
        }
    }
}

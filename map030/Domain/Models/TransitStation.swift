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

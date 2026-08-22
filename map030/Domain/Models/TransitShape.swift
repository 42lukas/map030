//
//  TransitShape.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import CoreLocation
import Foundation

struct TransitShape: Identifiable {
    let id: String
    let coordinates: [CLLocationCoordinate2D]
}

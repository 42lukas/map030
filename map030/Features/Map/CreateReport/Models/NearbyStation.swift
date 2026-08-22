//
//  NearbyStation.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import Foundation
import CoreLocation

struct NearbyStation: Identifiable {
    let station: TransitStation
    let distance: CLLocationDistance

    var id: String {
        station.id
    }
}

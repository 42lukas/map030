//
//  MapZoomLevel.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import CoreLocation

enum MapZoomLevel {
    case overview
    case station
    case detail

    var clusteringDistance: CLLocationDistance {
        switch self {
        case .overview:
            return 1_500

        case .station:
            return 250

        case .detail:
            return 0
        }
    }

}

//
//  MapZoomLevel.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import CoreLocation

enum MapZoomLevel: Equatable {
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

    var markerScale: CGFloat {
        switch self {
        case .overview:
            return 0.68

        case .station:
            return 0.84

        case .detail:
            return 1
        }
    }

}

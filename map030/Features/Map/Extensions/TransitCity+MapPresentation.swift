//
//  TransitCity+MapPresentation.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import MapKit

extension TransitCity {
    var mapRegion: MKCoordinateRegion {
        switch self {
        case .berlin:
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: 52.5200,
                    longitude: 13.4050
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )

        case .hamburg:
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: 53.5511,
                    longitude: 9.9937
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
        }
    }
}

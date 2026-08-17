//
//  MapView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(LocationManager.self) private var locationManager
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(
        followsHeading: false,
        fallback: .region(
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
        )
    )
    
    var body: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
        }.ignoresSafeArea()
            .task {
                locationManager.requestLocationIfNeeded()
            }
    }
}

#Preview {
    MapView()
}

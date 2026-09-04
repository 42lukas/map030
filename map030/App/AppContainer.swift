//
//  AppContainer.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import Observation

@MainActor
final class AppContainer {

    let locationManager: LocationManager
    let transitRepository: any TransitRepository

    init() {
        locationManager = LocationManager()
        transitRepository = NetworkTransitRepository()
    }
}

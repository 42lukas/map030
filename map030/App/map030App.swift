
//
//  map030App.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI

@main
struct map030App: App {
    private let container: AppContainer
    
    init() {
        container = AppContainer()
    }
    
    var body: some Scene {
        WindowGroup {
            MapView()
                .environment(container.locationManager)
        }
    }
}

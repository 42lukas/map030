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
    
    @State private var viewModel = MapViewModel()
    
    var body: some View {
        @Bindable var viewModel = viewModel
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
        }.ignoresSafeArea()
            .task {
                locationManager.requestLocationIfNeeded()
            }
    }
}

#Preview {
    MapView()
        .environment(LocationManager())
}

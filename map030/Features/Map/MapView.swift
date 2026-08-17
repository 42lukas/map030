//
//  MapView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        Map()
            .ignoresSafeArea()
            
    }
}

#Preview {
    MapView()
}

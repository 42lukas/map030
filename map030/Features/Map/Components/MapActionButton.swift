//
//  MapActionButton.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI

struct MapActionButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title3.weight(.semibold))
                .frame(width: 48, height: 48)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .buttonStyle(.plain)
    }
}

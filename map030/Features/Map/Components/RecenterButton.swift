//
//  RecenterButton.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI

struct RecenterButton: View {

    let action: () -> Void
    let systemName: String

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title3)
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .accessibilityLabel("Recenter map")
    }
}

#Preview {
    RecenterButton(action: {
        print("Recenter")
    }, systemName: "location.fill")
}

//
//  CitySwitcherButton.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import SwiftUI

struct CitySwitcherButton: View {
    let selectedCity: TransitCity
    let onSelect: (TransitCity) -> Void

    var body: some View {
        Menu {
            ForEach(TransitCity.allCases) { city in
                Button {
                    onSelect(city)
                } label: {
                    if city == selectedCity {
                        Label(city.displayName, systemImage: "checkmark")
                    } else {
                        Text(city.displayName)
                    }
                }
            }
        } label: {
            Text(selectedCity.shortName)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.primary)
                .frame(width: 48, height: 48)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(AppColors.divider.opacity(0.45), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        }
        .accessibilityLabel("Stadt auswählen")
        .accessibilityValue(selectedCity.displayName)
    }
}

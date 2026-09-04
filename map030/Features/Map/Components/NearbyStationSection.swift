//
//  NearbyStationSection.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import CoreLocation
import SwiftUI

struct NearbyStationsSection: View {

    let station: NearbyStation
    let onSelect: (TransitStation) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(
                "In deiner Nähe",
                systemImage: "location.fill"
            )
            .font(.headline)

            Button {
                onSelect(station.station)
            } label: {
                HStack {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.xs
                    ) {
                        Text(station.station.name)
                            .font(AppTypography.body.weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(
                            station.station.uniqueLines
                                .map(\.name)
                                .joined(separator: " · ")
                        )
                        .font(AppTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                        Text(formattedDistance(station.distance))
                            .font(AppTypography.secondary.weight(.semibold))

                        Text("entfernt")
                            .font(AppTypography.caption)
                            .foregroundStyle(.secondary)
                    }

                    Image(systemName: "chevron.right")
                        .font(AppTypography.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.md)
                .background(.thinMaterial)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: AppRadius.lg,
                        style: .continuous
                    )
                )
            }
            .buttonStyle(.plain)
        }
    }

    private func formattedDistance(
        _ distance: CLLocationDistance
    ) -> String {
        if distance < 1_000 {
            return "\(Int(distance.rounded())) m"
        }

        return String(
            format: "%.1f km",
            distance / 1_000
        )
    }
}

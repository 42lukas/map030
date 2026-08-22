//
//  NearbyStationSection.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI
import CoreLocation

struct NearbyStationsSection: View {

    let stations: [NearbyStation]
    let onSelect: (TransitStation) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(
                "In deiner Nähe",
                systemImage: "location.fill"
            )
            .font(.headline)

            VStack(spacing: 0) {
                ForEach(stations) { item in
                    Button {
                        onSelect(item.station)
                    } label: {
                        HStack {
                            VStack(
                                alignment: .leading,
                                spacing: 4
                            ) {
                                Text(item.station.name)
                                    .foregroundStyle(.primary)

                                Text(
                                    item.station.lines
                                        .map(\.name)
                                        .joined(separator: " · ")
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(
                                formattedDistance(
                                    item.distance
                                )
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)

                    if item.id != stations.last?.id {
                        Divider()
                    }
                }
            }
            .background(.thinMaterial)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 14,
                    style: .continuous
                )
            )
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

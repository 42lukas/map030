//
//  StationsSearchSection.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import SwiftUI

struct StationSearchSection: View {

    @Binding var searchText: String

    let selectedStation: TransitStation?
    let stations: [TransitStation]
    let onSelect: (TransitStation) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Station")
                .font(.headline)

            if let selectedStation {
                selectedStationView(selectedStation)
            }

            searchField

            if !searchText.isEmpty {
                searchResults
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                selectedStation == nil
                    ? "Station suchen"
                    : "Andere Station suchen",
                text: $searchText
            )
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
        .background(.thinMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 12,
                style: .continuous
            )
        )
    }

    @ViewBuilder
    private var searchResults: some View {
        if stations.isEmpty {
            ContentUnavailableView(
                "Keine Station gefunden",
                systemImage: "tram",
                description: Text(
                    "Versuche einen anderen Stationsnamen."
                )
            )
            .frame(maxWidth: .infinity)
        } else {
            LazyVStack(spacing: 0) {
                ForEach(stations) { station in
                    Button {
                        onSelect(station)
                    } label: {
                        stationRow(station)
                    }
                    .buttonStyle(.plain)

                    if station.id != stations.last?.id {
                        Divider()
                    }
                }
            }
            .background(.thinMaterial)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
            )
        }
    }

    private func selectedStationView(
        _ station: TransitStation
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "tram.fill")
                .font(.title3)
                .frame(width: 34, height: 34)
                .background(.quaternary)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(station.name)
                    .font(.body.weight(.semibold))

                Text(
                    station.uniqueLines
                        .map(\.name)
                        .joined(separator: " · ")
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.regularMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )
    }

    private func stationRow(
        _ station: TransitStation
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(station.name)
                .foregroundStyle(.primary)

            if !station.uniqueLines.isEmpty {
                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {
                    HStack(spacing: 6) {
                        ForEach(station.uniqueLines) { line in
                            TransitLineBadge(line: line)
                        }
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }
}

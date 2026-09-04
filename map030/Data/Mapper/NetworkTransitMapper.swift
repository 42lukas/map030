//
//  NetworkTransitMapper.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import CoreLocation
import Foundation
import TransitOverlayKit

enum NetworkTransitMapper {
    static func mapLines(
        _ network: TransitOverlayKit.TransitNetwork
    ) -> [TransitLine] {
        network.lines.map { line in
            TransitLine(
                id: line.id,
                name: line.name,
                routeType: routeType(for: line.mode),
                colorHex: hexColor(line.color),
                textColorHex: textColor(for: line.color)
            )
        }
    }

    static func mapStations(
        _ network: TransitOverlayKit.TransitNetwork
    ) -> [TransitStation] {
        let lines = mapLines(network)
        let linesByID = Dictionary(
            uniqueKeysWithValues: lines.map { ($0.id, $0) }
        )

        return Dictionary(grouping: network.stations, by: \.name)
            .compactMap { name, stations in
                guard let stationID = stations.map(\.id).min() else {
                    return nil
                }

                let count = Double(stations.count)
                let latitude =
                    stations.reduce(0) {
                        $0 + $1.coordinate.latitude
                    } / count
                let longitude =
                    stations.reduce(0) {
                        $0 + $1.coordinate.longitude
                    } / count
                let lineIDs = stations.reduce(into: Set<String>()) {
                    $0.formUnion($1.servedLineIDs)
                }

                return TransitStation(
                    id: stationID,
                    name: name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: latitude,
                        longitude: longitude
                    ),
                    lines:
                        lineIDs
                        .compactMap { linesByID[$0] }
                        .sorted {
                            $0.name.localizedStandardCompare($1.name)
                                == .orderedAscending
                        }
                )
            }
            .sorted {
                $0.name.localizedStandardCompare($1.name)
                    == .orderedAscending
            }
    }

    private static func routeType(
        for mode: TransitOverlayKit.TransitMode
    ) -> Int {
        switch mode {
        case .suburbanRail:
            TransitRouteType.sBahn
        case .subway:
            TransitRouteType.uBahn
        case .tram:
            TransitRouteType.tram
        default:
            0
        }
    }

    private static func hexColor(
        _ color: TransitOverlayKit.TransitColor
    ) -> String {
        String(
            format: "%02X%02X%02X",
            colorComponent(color.red),
            colorComponent(color.green),
            colorComponent(color.blue)
        )
    }

    private static func textColor(
        for color: TransitOverlayKit.TransitColor
    ) -> String {
        let luminance =
            0.299 * color.red
            + 0.587 * color.green
            + 0.114 * color.blue

        return luminance > 0.62 ? "000000" : "FFFFFF"
    }

    private static func colorComponent(_ value: Double) -> Int {
        Int((value * 255).rounded())
    }
}

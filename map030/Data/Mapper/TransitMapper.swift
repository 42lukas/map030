//
//  TransitMapper.swift
//  map030
//
//  Created by Lukas Karsten on 21.08.26.
//

import CoreLocation
import Foundation

enum TransitMapper {

    static func mapLine(
        _ dto: TransitLineDTO
    ) -> TransitLine {
        TransitLine(
            id: dto.id,
            name: dto.name,
            routeType: dto.type,
            colorHex: dto.color,
            textColorHex: dto.textColor,
            shapeIDs: dto.shapeIds
        )
    }

    static func mapStation(
        _ dto: TransitStationDTO,
        linesByID: [String: TransitLine]
    ) -> TransitStation {
        let lines = dto.lineIds.compactMap {
            linesByID[$0]
        }

        return TransitStation(
            id: dto.id,
            name: dto.name,
            coordinate: CLLocationCoordinate2D(
                latitude: dto.latitude,
                longitude: dto.longitude
            ),
            lines: lines
        )
    }

    static func mapShape(
        id: String,
        points: [TransitShapePointDTO]
    ) -> TransitShape {
        TransitShape(
            id: id,
            coordinates: points.map {
                CLLocationCoordinate2D(
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }
        )
    }
}

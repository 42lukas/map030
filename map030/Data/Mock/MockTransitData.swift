//
//  MockTransitData.swift
//  map030
//
//  Created by Lukas Karsten on 18.08.26.
//

import CoreLocation
import Foundation

enum MockTransitData {

    static let u2 = TransitLine(
        id: "u2",
        name: "U2",
        routeType: 400,
        colorHex: "DA421E",
        textColorHex: "FFFFFF",
        shapeIDs: []
    )

    static let u5 = TransitLine(
        id: "u5",
        name: "U5",
        routeType: 400,
        colorHex: "7E5330",
        textColorHex: "FFFFFF",
        shapeIDs: []
    )

    static let u8 = TransitLine(
        id: "u8",
        name: "U8",
        routeType: 400,
        colorHex: "224F86",
        textColorHex: "FFFFFF",
        shapeIDs: []
    )

    static let s3 = TransitLine(
        id: "s3",
        name: "S3",
        routeType: 109,
        colorHex: "0066AD",
        textColorHex: "FFFFFF",
        shapeIDs: []
    )

    static let s5 = TransitLine(
        id: "s5",
        name: "S5",
        routeType: 109,
        colorHex: "EB7405",
        textColorHex: "FFFFFF",
        shapeIDs: []
    )

    static let stations: [TransitStation] = [
        TransitStation(
            id: "alexanderplatz",
            name: "Alexanderplatz",
            coordinate: CLLocationCoordinate2D(
                latitude: 52.5219,
                longitude: 13.4132
            ),
            lines: [u2, u5, u8]
        ),

        TransitStation(
            id: "hauptbahnhof",
            name: "Hauptbahnhof",
            coordinate: CLLocationCoordinate2D(
                latitude: 52.5251,
                longitude: 13.3694
            ),
            lines: [s3, s5]
        ),

        TransitStation(
            id: "warschauer-strasse",
            name: "Warschauer Straße",
            coordinate: CLLocationCoordinate2D(
                latitude: 52.5050,
                longitude: 13.4485
            ),
            lines: [s3, s5]
        )
    ]

    static let reports: [Report] = {
        let createdAt = Date()

        return [
            Report(
                id: UUID(),
                station: stations[0],
                line: u8,
                category: .control,
                createdAt: createdAt,
                expiresAt: createdAt.addingTimeInterval(
                    ReportCategory.control.expirationInterval
                )
            ),

            Report(
                id: UUID(),
                station: stations[1],
                line: nil,
                category: .elevatorOutOfService,
                createdAt: createdAt,
                expiresAt: createdAt.addingTimeInterval(
                    ReportCategory.elevatorOutOfService.expirationInterval
                )
            ),

            Report(
                id: UUID(),
                station: stations[2],
                line: s5,
                category: .crowding,
                createdAt: createdAt,
                expiresAt: createdAt.addingTimeInterval(
                    ReportCategory.crowding.expirationInterval
                )
            )
        ]
    }()
}

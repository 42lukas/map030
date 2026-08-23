//
//  GeographicReportClustering.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import CoreLocation

enum GeographicReportClustering {
    static func cluster(
        _ stationClusters: [StationReportCluster],
        within maximumDistance: CLLocationDistance
    ) -> [StationReportCluster] {
        guard maximumDistance > 0 else {
            return stationClusters
        }

        var visited = Array(
            repeating: false,
            count: stationClusters.count
        )
        var result: [StationReportCluster] = []

        for startIndex in stationClusters.indices where !visited[startIndex] {
            visited[startIndex] = true
            var memberIndexes = [startIndex]
            var currentIndex = 0

            while currentIndex < memberIndexes.count {
                let clusterIndex = memberIndexes[currentIndex]

                for candidateIndex in stationClusters.indices
                where !visited[candidateIndex] {
                    let distance = distance(
                        from: stationClusters[clusterIndex].coordinate,
                        to: stationClusters[candidateIndex].coordinate
                    )

                    if distance <= maximumDistance {
                        visited[candidateIndex] = true
                        memberIndexes.append(candidateIndex)
                    }
                }

                currentIndex += 1
            }

            let members = memberIndexes.map {
                stationClusters[$0]
            }

            result.append(
                StationReportCluster(
                    stations: members.flatMap(\.stations),
                    reports: members.flatMap(\.reports)
                )
            )
        }

        return result
    }

    private static func distance(
        from firstCoordinate: CLLocationCoordinate2D,
        to secondCoordinate: CLLocationCoordinate2D
    ) -> CLLocationDistance {
        CLLocation(
            latitude: firstCoordinate.latitude,
            longitude: firstCoordinate.longitude
        )
        .distance(
            from: CLLocation(
                latitude: secondCoordinate.latitude,
                longitude: secondCoordinate.longitude
            )
        )
    }
}

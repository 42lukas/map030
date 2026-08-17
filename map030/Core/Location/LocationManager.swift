//
//  LocationManager.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import CoreLocation
import Observation

@Observable
@MainActor
final class LocationManager: NSObject {
    private let manager: CLLocationManager
    
    private(set) var authorizationStatus: CLAuthorizationStatus
    private(set) var location: CLLocation?
    
    override init() {
        let manager = CLLocationManager()
        
        self.manager = manager
        self.authorizationStatus = manager.authorizationStatus
        
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        guard isAuthorized else {
            return
        }
        
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    func requestLocationIfNeeded() {
        switch authorizationStatus {
        case .notDetermined:
            requestAuthorization()
            
        case .authorizedWhenInUse,
                .authorizedAlways:
            startUpdatingLocation()
            
        case .denied,
                .restricted:
            break
            
        @unknown default:
            break
        }
    }
    
    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse ||
        authorizationStatus == .authorizedAlways
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        authorizationStatus = manager.authorizationStatus
        
        if isAuthorized {
            startUpdatingLocation()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let latestLocation = locations.last else {
            return
        }
        
        location = latestLocation
    }
}

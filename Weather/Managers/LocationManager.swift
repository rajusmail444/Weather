//
//  LocationManager.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import Foundation
import CoreLocation

enum LocationError {
    case notAvailable
    case none
}

final class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var locationError: LocationError = .none
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = .notAvailable
        isLoading = false
    }
}

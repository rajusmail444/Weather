//
//  LocationManagerMock.swift
//  WeatherTests
//
//  Created by Rajesh Billakanti on 8/27/23.
//

import Foundation
import CoreLocation
@testable import Weather

final class LocationManagerMock: LocationManager {
    override init() {
        super.init()
    }

    override func requestLocation() {
        location = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(1234.123),
            longitude: CLLocationDegrees(5678.123)
        )
    }
}

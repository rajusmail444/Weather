//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine

final class WeatherViewModel: ObservableObject {
    @Published var latitude: CLLocationDegrees?
    @Published var longitude: CLLocationDegrees?
    @Published var isLoading = false

    var cancellable = Set<AnyCancellable>()
    private var locationManager: LocationManager

    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        observeLocationCoordinates()
    }

    func requestLocation() {
        isLoading = true
        locationManager.requestLocation()
    }

    private func observeLocationCoordinates() {
        locationManager.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                guard let self else { return }
                self.isLoading = false
                self.latitude = self.locationManager.location?.latitude
                self.longitude = self.locationManager.location?.longitude
                if self.locationManager.locationError == .notAvailable {
                    print("~~> Location Failed")
                }
            }
            .store(in: &cancellable)
    }
}

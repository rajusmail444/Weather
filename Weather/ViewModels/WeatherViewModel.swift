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
    @Published var isLoading = false
    @Published var isLocationAvailable = false
    @Published var currentWeather: CurrentWeather?
    @Published var forecastedWeather: ForecastedWeather?
    @Published var currentWeatherError: String?
    @Published var forecastedWeatherError: String?
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?

    var cancellable = Set<AnyCancellable>()
    private var locationManager: LocationManager
    private var networkManager: NetworkManager

    init(
        locationManager: LocationManager,
        networkManager: NetworkManager
    ) {
        self.locationManager = locationManager
        self.networkManager = networkManager
        observeLocationCoordinates()
    }

    func requestLocation() {
        isLoading = true
        locationManager.requestLocation()
    }

    func fetchData() {
        isLoading = true
        fetchCurrentWeather()
        fetchForecastedWeather()
    }

    private func fetchCurrentWeather() {
        guard let latitude, let longitude else {
            return
        }
        networkManager.getData(
            endpoint: .currentLocation(latitude, longitude),
            type: CurrentWeather.self
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: {[weak self] completion in
                if case let .failure(error) = completion {
                    self?.currentWeatherError = (error as? NetworkError)?.errorDescription
                }
                print("~~> currentWeatherError: \(self?.currentWeatherError)")
                self?.isLoading = false
            },
            receiveValue: { [weak self] response in
                self?.currentWeather = response
            }
        )
        .store(in: &cancellable)
    }

    private func fetchForecastedWeather() {
        guard let latitude, let longitude else {
            return
        }
        networkManager.getData(
            endpoint: .forecast(latitude, longitude, 6),
            type: ForecastedWeather.self
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: {[weak self] completion in
                if case let .failure(error) = completion {
                    self?.forecastedWeatherError = (error as? NetworkError)?.errorDescription
                }

                self?.isLoading = false
            },
            receiveValue: { [weak self] response in
                self?.forecastedWeather = response
            }
        )
        .store(in: &cancellable)
    }

    private func observeLocationCoordinates() {
        locationManager.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                guard let self else { return }
                self.isLoading = false
                self.isLocationAvailable = true
                self.latitude = self.locationManager.location?.latitude
                self.longitude = self.locationManager.location?.longitude
                if self.locationManager.locationError == .notAvailable {
                    print("~~> Location Failed")
                }
            }
            .store(in: &cancellable)
    }
}

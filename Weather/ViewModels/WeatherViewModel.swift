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
    @Published var forecastedWeatherError: String?
    @Published var toastError: Bool = false
    @Published var toastErrorMessage: String = ""
    @Published var toastButtonTitle: String = ""

    var cancellable = Set<AnyCancellable>()

    private(set) var latitude: CLLocationDegrees?
    private(set) var longitude: CLLocationDegrees?
    private var locationManager: LocationManager
    private var networkManager: NetworkManagerType

    init(
        locationManager: LocationManager,
        networkManager: NetworkManagerType
    ) {
        self.locationManager = locationManager
        self.networkManager = networkManager
        observeLocationCoordinates()
    }

    func requestLocation() {
        isLoading = true
        locationManager.requestLocation()
    }

    func fetchData(for city: String) {
        guard !city.isEmpty else {
            return
        }
        networkManager.getData(
            endpoint: .geoLocation(city),
            type: [GeoLocationModel].self
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: {[weak self] completion in
                if case .failure = completion {
                    self?.toastError = true
                    self?.toastErrorMessage = NetworkError.locationError.errorDescription ?? "unknown.error".localized()
                    self?.toastButtonTitle = "ok".localized()
                }
                self?.isLoading = false
            },
            receiveValue: { [weak self] response in
                if let location = response.first {
                    self?.latitude = location.lat
                    self?.longitude = location.lon
                    self?.fetchData()
                } else {
                    self?.toastError = true
                    self?.toastErrorMessage = NetworkError.locationError.errorDescription ?? "unknown.error".localized()
                    self?.toastButtonTitle = "ok".localized()
                }

            }
        )
        .store(in: &cancellable)
    }

    func fetchData() {
        fetchCurrentWeather()
        fetchForecastedWeather()
    }

    private func fetchCurrentWeather() {
        guard let latitude, let longitude else {
            return
        }
        networkManager.getData(
            endpoint: .currentWeather(latitude, longitude),
            type: CurrentWeather.self
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: {[weak self] completion in
                if case let .failure(error) = completion {
                    self?.toastError = true
                    self?.toastErrorMessage = (error as? NetworkError)?.errorDescription ?? "unknown.error".localized()
                    self?.toastButtonTitle = "reload.weather.forecast".localized()
                }
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
                self.latitude = self.locationManager.location?.latitude
                self.longitude = self.locationManager.location?.longitude
                self.isLocationAvailable = self.latitude != nil
            }
            .store(in: &cancellable)
    }
}

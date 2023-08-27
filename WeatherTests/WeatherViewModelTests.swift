//
//  WeatherViewModelTests.swift
//  WeatherViewModelTests
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import XCTest
import CoreLocation
import Combine
@testable import Weather

final class WeatherViewModelTests: XCTestCase {
    var sut: WeatherViewModel!
    var mockLocationManager: LocationManager!
    var mockNetworkManager: NetworkManagerType!
    override func setUp() {
        mockLocationManager = LocationManagerMock()
        mockNetworkManager = NetworkManagerMock()
        sut = WeatherViewModel(
            locationManager: mockLocationManager,
            networkManager: mockNetworkManager
        )
    }

    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        mockLocationManager = nil
    }

    func testRequestLocation() {
        // given
        let expectation = XCTestExpectation(description: "Get location")

        // when
        sut.$isLocationAvailable
            .dropFirst()
            .sink(receiveValue: {_ in
                XCTAssertEqual(self.sut.isLoading, false, "Progress indicator should be displayed when we request for location")
                XCTAssertEqual(self.sut.latitude?.roundDouble(), "1234", "Location latitude should be fetched")
                XCTAssertEqual(self.sut.longitude?.roundDouble(), "5678", "Location longitude should be fetched")
                expectation.fulfill()
            })
            .store(in: &sut.cancellable)
        sut.requestLocation()

        // then
        wait(for: [expectation], timeout: 5)
    }

    func testFetchDataForCitySuccess() {
        // given
        let expectation = XCTestExpectation(description: "Get Geo location from given city")
        let mockNM = (mockNetworkManager as! NetworkManagerMock)
        mockNM.responseStatus = .success

        // when
        sut.$currentWeather
            .dropFirst()
            .sink(receiveValue: {_ in
                XCTAssertEqual(self.sut.latitude?.roundDouble(), "33", "Location latitude should be fetched")
                XCTAssertEqual(self.sut.longitude?.roundDouble(), "-97", "Location longitude should be fetched")
                expectation.fulfill()
            })
            .store(in: &sut.cancellable)
        sut.fetchData(for: "Dallas")

        // then
        wait(for: [expectation], timeout: 5)
    }

    func testFetchDataForCityFailure() {
        // given
        let expectation = XCTestExpectation(description: "failed to get Geo location from given city")
        let mockNM = (mockNetworkManager as! NetworkManagerMock)
        mockNM.responseStatus = .failure

        // when
        sut.$toastButtonTitle
            .dropFirst()
            .sink(receiveValue: { buttonTitle in
                XCTAssertEqual(self.sut.toastError, true, "Toast error should be displayed on API failure")
                XCTAssertEqual(self.sut.toastErrorMessage, "city.weather.not.available".localized(), "Toast error message to be displayed on API failure")
                XCTAssertEqual(buttonTitle, "ok".localized(), "Toast action button title to be displayed on API failure")
                expectation.fulfill()
            })
            .store(in: &sut.cancellable)
        sut.fetchData(for: "Dallas")

        // then
        wait(for: [expectation], timeout: 5)
    }

    func testFetchDataForCurrentWeatherSuccess() {
        // given
        let expectation = XCTestExpectation(description: "Get current weather")
        let mockNM = (mockNetworkManager as! NetworkManagerMock)
        mockNM.responseStatus = .success

        // when
        sut.$isLocationAvailable
            .dropFirst()
            .sink(receiveValue: {_ in
                self.sut.fetchData()
            })
            .store(in: &sut.cancellable)
        sut.$currentWeather
            .dropFirst()
            .sink(receiveValue: { weather in
                XCTAssertEqual(weather?.name, "New York", "Current city name should be fetched")
                XCTAssertNotNil(weather?.main.time, "Current city time should be fetched")
                XCTAssertEqual(weather?.logo, "https://openweathermap.org/img/wn/04d@2x.png", "Image describing current weather should be fetched")
                XCTAssertEqual(weather?.main.feelsLike, "1", "Current weather temperature should be fetched")
                XCTAssertEqual(weather?.description, "Overcast clouds", "description about current weather should be fetched")
                expectation.fulfill()
            })
            .store(in: &sut.cancellable)
        sut.requestLocation()

        // then
        wait(for: [expectation], timeout: 5)
    }

    func testFetchDataForCurrentWeatherFailure() {
        // given
        let expectation = XCTestExpectation(description: "fail to get current weather")
        let mockNM = (mockNetworkManager as! NetworkManagerMock)
        mockNM.responseStatus = .failure

        // when
        sut.$isLocationAvailable
            .dropFirst()
            .sink(receiveValue: {_ in
                self.sut.fetchData()
            })
            .store(in: &sut.cancellable)
        sut.$toastButtonTitle
            .dropFirst()
            .sink(receiveValue: { buttonTitle in
                XCTAssertEqual(self.sut.toastError, true, "Toast error should be displayed on API failure")
                XCTAssertEqual(self.sut.toastErrorMessage, "invalid.url".localized(), "Toast error message to be displayed on API failure")
                XCTAssertEqual(buttonTitle, "reload.weather.forecast".localized(), "Toast action button title to be displayed on API failure")
                expectation.fulfill()
            })
            .store(in: &sut.cancellable)
        sut.requestLocation()

        // then
        wait(for: [expectation], timeout: 5)
    }

    func testFetchDataForForecastedWeatherSuccess() {
        // given
        let expectation = XCTestExpectation(description: "Get forecasted weather")
        let mockNM = (mockNetworkManager as! NetworkManagerMock)
        mockNM.responseStatus = .success

        // when
        sut.$isLocationAvailable
            .dropFirst()
            .sink(receiveValue: {_ in
                self.sut.fetchData()
            })
            .store(in: &sut.cancellable)
        sut.$forecastedWeather
            .dropFirst()
            .sink(receiveValue: { weather in
                XCTAssertEqual(weather?.list.first?.logo, "https://openweathermap.org/img/wn/01d@2x.png", "Tomorrows forecasted weather logo fetched")
                XCTAssertEqual(weather?.list.first?.temperature, "292°C to 305°C", "Tomorrows forecasted temperature range fetched")

                XCTAssertEqual(weather?.list.first?.date, "Aug 26, 2023", "Tomorrows date should be displayed")
                expectation.fulfill()
            })
            .store(in: &sut.cancellable)
        sut.requestLocation()

        // then
        wait(for: [expectation], timeout: 5)
    }

    func testFetchDataForForecastedWeatherFailure() {
        // given
        let expectation = XCTestExpectation(description: "fail to get forecasted weather")
        let mockNM = (mockNetworkManager as! NetworkManagerMock)
        mockNM.responseStatus = .failure

        // when
        sut.$isLocationAvailable
            .dropFirst()
            .sink(receiveValue: {_ in
                self.sut.fetchData()
            })
            .store(in: &sut.cancellable)
        sut.$forecastedWeatherError
            .dropFirst()
            .sink(receiveValue: { error in
                XCTAssertEqual(error, "invalid.url".localized(), "Action sheet error should be displayed on API failure")

                expectation.fulfill()
            })
            .store(in: &sut.cancellable)
        sut.requestLocation()

        // then
        wait(for: [expectation], timeout: 5)
    }
}

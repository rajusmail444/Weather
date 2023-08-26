//
//  CurrentWeatherModel.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import Foundation

struct CurrentWeather: Codable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Codable {
        var lon: Double
        var lat: Double
    }

    struct MainResponse: Codable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }

    struct WindResponse: Codable {
        var speed: Double
        var deg: Double
    }
}

struct WeatherResponse: Codable, Hashable {
    var id: Double
    var main: String
    var description: String
    var icon: String
}

extension CurrentWeather.MainResponse {
    var feelsLike: Double { feels_like }
    var tempMin: Double { temp_min }
    var tempMax: Double { temp_max }
    var time: String {
        "\("today".localized()), \(Date().formatted(.dateTime.month().day().minute().second()))"
    }
}



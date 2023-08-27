//
//  CurrentWeatherModel.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import Foundation

struct CurrentWeather: Codable {
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String

    struct MainResponse: Codable {
        var feels_like: Double
    }
}

struct WeatherResponse: Codable, Hashable {
    var id: Double
    var description: String
    var icon: String
}

extension CurrentWeather {
    var logo: String {
        "https://openweathermap.org/img/wn/\(weather[0].icon)@2x.png"
    }
    var description: String {
        weather[0].description.capitalizingFirstLetter()
    }
}

extension CurrentWeather.MainResponse {
    var feelsLike: String { feels_like.roundDouble() }
    var time: String {
        "\("today".localized()), \(Date().formatted(.dateTime.month().day().minute().second()))"
    }
}

struct GeoLocationModel: Codable {
    var name: String
    var lat: Double
    var lon: Double
}

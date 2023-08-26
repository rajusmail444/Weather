//
//  ForecastedWeatherModel.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/26/23.
//

import Foundation

struct ForecastedWeather: Codable {
    var list: [DaysResponse]
}

struct DaysResponse: Codable, Hashable {
    var dt: Int
    var temp: Temperature
    var weather: [WeatherResponse]
}

extension DaysResponse {
    var logo: String {
        weather[0].icon
    }
    var temperature: String {
        "\(temp.min)\("fahrenheit".localized()) to \(temp.max)\("fahrenheit".localized())"
    }
    var date: String {
        "\(Date(timeIntervalSince1970: TimeInterval(dt)).formatted(.dateTime.month().day().year()))"
    }
}

struct Temperature: Codable, Hashable {
    var min: Double
    var max: Double
}



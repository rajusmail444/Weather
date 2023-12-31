//
//  LoadData.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import Foundation

final class FileLoader {
    static let shared = FileLoader()
    private init() {}
    var previewCurrentWeather: CurrentWeather {
        load("WeatherData.json", type: CurrentWeather.self)
    }
    var previewForecastWeather: ForecastedWeather {
        load("ForecastData.json", type: ForecastedWeather.self)
    }
    var previewCityLocation: [GeoLocationModel] {
        load("CityLocationData.json", type: [GeoLocationModel].self)
    }

    func load<T: Decodable>(_ filename: String, type: T.Type) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}

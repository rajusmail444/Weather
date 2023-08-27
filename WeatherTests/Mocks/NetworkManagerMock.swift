//
//  NetworkManagerMock.swift
//  WeatherTests
//
//  Created by Rajesh Billakanti on 8/27/23.
//

import Foundation
import Combine
@testable import Weather

final class NetworkManagerMock: NetworkManagerType {
    enum ResponseStatus {
        case success
        case failure
        case unknown
    }

    var responseStatus: ResponseStatus = .unknown
    func getData<T>(endpoint: Weather.Endpoint, type: T.Type) -> Future<T, Error> where T : Decodable {
        return Future<T, Error> { [weak self] promise in
            guard let self else {
                return promise(.failure(NetworkError.unknown))
            }
            switch responseStatus {
            case .success:
                var data: T
                if type.self == CurrentWeather.self {
                    data = FileLoader.shared.load("WeatherData.json", type: type)
                    promise(.success(data))
                } else if type.self == ForecastedWeather.self {
                    data = FileLoader.shared.load("ForecastData.json", type: type)
                    promise(.success(data))
                } else if type.self == [GeoLocationModel].self {
                    data = FileLoader.shared.load("CityLocationData.json", type: type)
                    promise(.success(data))
                }
            case .failure:
                promise(.failure(NetworkError.invalidURL))
            case .unknown:
                promise(.failure(NetworkError.unknown))
            }
        }
    }
}

private extension Bundle {
    func  decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}

//
//  NetworkManager.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
    case missingUrl
    case noResponse
    case none
}

final class NetworkManager {
    private enum Constants {
        static let host: String = "https://api.openweathermap.org/data/2.5"
        static let apiKey: String = "8bf352fcd95e743683b4dcf992a6e46e"

    }
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> CurrentLocationResponse {
        guard let url = URL(string: "\(Constants.host)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.apiKey)") else {
            throw NetworkError.missingUrl
        }

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.noResponse
        }

        let decodedData = try JSONDecoder().decode(CurrentLocationResponse.self, from: data)
        return decodedData
    }
}

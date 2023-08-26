//
//  NetworkManager.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import Foundation
import CoreLocation
import Combine

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

enum Endpoint {
    case currentLocation(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees)
    case forecast(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, _ days: Int)
}

extension Endpoint {
    var params: String {
        switch self {
        case .currentLocation(let latitude, let longitude):
            return "/weather?lat=\(latitude)&lon=\(longitude)"
        case .forecast(let latitude, let longitude, let days):
            return "/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=\(days)"
        }
    }
}

final class NetworkManager {
    enum Constants {
        static let baseURL = "https://api.openweathermap.org/data/2.5"
        static let apiKey: String = "&appid=8bf352fcd95e743683b4dcf992a6e46e"

    }
    private var cancellable = Set<AnyCancellable>()

    func getData<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: Constants.baseURL.appending(endpoint.params).appending(Constants.apiKey)) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            print("~~> URL is \(url.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellable)
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}

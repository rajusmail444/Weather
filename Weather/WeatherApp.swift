//
//  WeatherApp.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: WeatherViewModel(
                    locationManager: LocationManager(),
                    networkManager: NetworkManager()
                )
            )
        }
    }
}

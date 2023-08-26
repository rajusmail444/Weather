//
//  ContentView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if viewModel.isLocationAvailable {
                if let currentWeather = viewModel.currentWeather,
                    let forecast = viewModel.forecastedWeather {
                    HomeView(
                        currentWeather: currentWeather,
                        forecastWeather: forecast)
                } else {
                    LoadingView()
                        .task {
                            viewModel.fetchData()
                        }
                }
            } else {
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(viewModel)
                }
            }
        }
        .background(Color(.systemFill))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: WeatherViewModel(
                locationManager: LocationManager(),
                networkManager: NetworkManager()
            )
        )
    }
}

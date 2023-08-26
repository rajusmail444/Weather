//
//  ContentView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: WeatherViewModel
    @State private var showError = false

    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }


    var body: some View {
        VStack {
            if viewModel.isLocationAvailable {
                if let currentWeather = viewModel.currentWeather {
                    HomeView(
                        currentWeather: currentWeather
                    )
                    .environmentObject(viewModel)
                    .refreshable {
                        viewModel.fetchData()
                    }
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
        .overlay {
            if showError {
                VStack {
                    ToastErrorView()
                        .environmentObject(viewModel)
                    Spacer()
                }.transition(.move(edge: .top))
            }
        }
        .transition(.move(edge: .top))
        .animation(.default, value: viewModel.currentWeatherError)
        .onChange(of: viewModel.currentWeatherError) { error in
            showError = error != nil
        }
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

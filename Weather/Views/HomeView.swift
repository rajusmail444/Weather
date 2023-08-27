//
//  HomeView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var showCityView = false
    var currentWeather: CurrentWeather

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(currentWeather.name)
                            .bold().font(.title)

                        Text(currentWeather.main.time)
                            .fontWeight(.light)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        viewModel.fetchData()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.system(size: 30))
                            .tint(Color(.systemBackground))
                    }
                    Button {
                        showCityView.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 30))
                            .tint(Color(.systemBackground))
                    }
                }
                Spacer()

                VStack(alignment: .center) {
                    HStack() {
                        AsyncImage(url: URL(string: currentWeather.logo)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 110, height: 110)
                        } placeholder: {
                            ProgressView()
                        }

                        Text(currentWeather.main.feelsLike)
                            .font(.system(size: 65))
                            .fontWeight(.bold)

                        Text(LocalizedStringKey("fahrenheit"))
                            .font(.system(size: 65))
                    }.padding(.top)
                    Text(currentWeather.description)
                        .font(.system(size: 35))
                        .fontWeight(.light)
                        .foregroundColor(Color(.systemBackground))

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)

            if let forecastedWeather = viewModel.forecastedWeather {
                ForecastView(forecastWeather: forecastedWeather)
            } else if viewModel.forecastedWeatherError != nil {
                ActionSheetErrorView()
                    .environmentObject(viewModel)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(.systemCyan))
        .overlay {
            if showCityView {
                VStack {
                    CityView(isPresented: $showCityView)
                        .environmentObject(viewModel)
                    Spacer()
                }.transition(.move(edge: .top))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            currentWeather: FileLoader.shared.previewCurrentWeather
        )
        .environmentObject(WeatherViewModel(
            locationManager: LocationManager(),
            networkManager: NetworkManager()
        ))
    }
}

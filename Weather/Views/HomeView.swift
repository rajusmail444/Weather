//
//  HomeView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import SwiftUI

struct HomeView: View {
    var currentWeather: CurrentWeather
    var forecastWeather: ForecastedWeather

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(currentWeather.name)
                        .bold().font(.title)

                    Text(currentWeather.main.time)
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                VStack(alignment: .center) {
                    HStack() {
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(currentWeather.weather[0].icon)@2x.png")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                        } placeholder: {
                            ProgressView()
                        }

                        Text(currentWeather.main.feelsLike.roundDouble() + "°")
                            .font(.system(size: 60))
                            .fontWeight(.bold)

                        Text("F")
                            .font(.system(size: 50))
                    }.padding(.top)
                    Text(currentWeather.weather[0].description.capitalizingFirstLetter())
                        .font(.system(size: 35))
                        .fontWeight(.light)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)

            ForecastView(forecastWeather: forecastWeather)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(.systemCyan))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            currentWeather: previewCurrentWeather,
            forecastWeather: previewForecastWeather
        )
    }
}

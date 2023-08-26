//
//  ActionSheetErrorView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/26/23.
//

import SwiftUI

struct ActionSheetErrorView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    var body: some View {
        let errorDesc = viewModel.forecastedWeatherError ?? "unknown.error".localized()
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.orange)
                .overlay {
                    VStack {
                        Text(errorDesc)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Button(LocalizedStringKey("reload.weather.forecast")) {
                            Task {
                                viewModel.fetchData()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height/2.2, alignment: .center)
        }
    }
}

struct ActionSheetErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ActionSheetErrorView()
            .environmentObject(WeatherViewModel(
                locationManager: LocationManager(),
                networkManager: NetworkManager()
            ))
    }
}


//
//  ToastErrorView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/26/23.
//

import SwiftUI

struct ToastErrorView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        let errorDesc = viewModel.currentWeatherError ?? "unknown.error".localized()
        Spacer()
            .frame(height: 80)
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.orange)
            .frame(height: 300)
            .padding()
            .overlay {

                VStack {
                    Text(errorDesc)
                        .padding()
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
    }
}

struct ToastErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ToastErrorView()
            .environmentObject(WeatherViewModel(
                locationManager: LocationManager(),
                networkManager: NetworkManager()
            ))
    }
}

//
//  ForecastView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/26/23.
//

import SwiftUI

struct ForecastView: View {
    var forecastWeather: ForecastedWeather

    var body: some View {
        let list = forecastWeather.list.dropFirst()
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("Daily Forecast")
                    .bold()
                    .padding(.leading)
                    .padding(.top)
                    .font(.title2)
                List {
                    ForEach(list, id: \.self) {
                        ItemRow(
                            logo: $0.logo,
                            temperature: $0.temperature,
                            date: $0.date
                        )
                    }
                }
                .listStyle(.plain)
            }
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height/2.2, alignment: .leading)
            .padding(.bottom, 20)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(forecastWeather: previewForecastWeather)
    }
}

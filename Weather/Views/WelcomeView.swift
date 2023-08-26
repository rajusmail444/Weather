//
//  WelcomeView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text(LocalizedStringKey("welcome"))
                    .bold()
                    .font(.largeTitle)
                
                Text(LocalizedStringKey("weather.forecast"))
                    .bold()
                    .font(.title2)
                
                Text(LocalizedStringKey("location.permission.info"))
                    .multilineTextAlignment(.center)
                    .padding()
                
                LocationButton(.shareCurrentLocation) {
                    viewModel.requestLocation()
                }
                .cornerRadius(30)
                .symbolVariant(.fill)
                .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

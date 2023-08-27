//
//  CityView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/26/23.
//

import SwiftUI

struct CityView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var cityName: String = ""
    @State private var cityNameError: Bool = false
    @Binding var isPresented: Bool

    var body: some View {
        Spacer()
            .frame(height: 80)
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.white)
            .frame(height: 200)
            .padding()
            .overlay {
                VStack {
                    VStack {
                        TextField("Enter city name", text: $cityName, onEditingChanged: { isChanged in
                            cityNameError = !isChanged
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                        if cityNameError {
                            Text(LocalizedStringKey("city.name.empty"))
                                .foregroundColor(.red)
                                .font(.caption)
                                .fontWeight(.light)
                        }
                    }
                    .padding()
                    .frame(maxWidth: 350)

                    Button(LocalizedStringKey("weather")) {
                        if !cityName.isEmpty {
                            isPresented = false
                            Task {
                                viewModel.fetchData(for: cityName)
                            }
                        } else {
                            cityNameError = cityName.isEmpty
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }

            }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView(isPresented: .constant(true))
            .environmentObject(WeatherViewModel(
                locationManager: LocationManager(),
                networkManager: NetworkManager()
            ))
    }
}

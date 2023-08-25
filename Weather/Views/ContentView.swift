//
//  ContentView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/25/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                Text("Your coordinates are: \(location.longitude), \(location.latitude)")
            } else {
                if locationManager.isLoading {
                    ProgressView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(.systemFill))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

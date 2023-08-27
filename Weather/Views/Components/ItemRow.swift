//
//  ItemRow.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/26/23.
//

import SwiftUI

struct ItemRow: View {
    var logo: String
    var temperature: String
    var date: String

    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(logo)@2x.png")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            } placeholder: {
                ProgressView()
            }


            VStack(alignment: .leading, spacing: 8) {
                Text(temperature)
                    .font(.title2)

                Text(date)
                    .bold()
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .listRowBackground(Color(.clear))
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(
            logo: "10d",
            temperature: "230°F to 250°F",
            date: "Aug 27, 2023")
    }
}

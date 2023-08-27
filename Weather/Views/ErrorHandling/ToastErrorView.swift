//
//  ToastErrorView.swift
//  Weather
//
//  Created by Rajesh Billakanti on 8/26/23.
//

import SwiftUI

struct ToastErrorView: View {
    @Binding var isPresented: Bool
    var errorDesc: String
    var buttonTitle: String
    var buttonAction: (() -> Void)?
    
    var body: some View {
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
                    Button(buttonTitle) {
                        isPresented = false
                        Task {
                            buttonAction?()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }

            }
    }
}

struct ToastErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ToastErrorView(
            isPresented: .constant(true),
            errorDesc: "Network Error",
            buttonTitle: "Ok"
        )
    }
}

//
//  QRCodeView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/3/25.
//
import SwiftUI
struct QRCodeView: View {
    @Environment(GameStateModel.self) private var model
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .opacity(0.90)
            Button(action: {
                model.showTradeQR.toggle()
                model.pollingTask?.cancel()
            }) {
                Text("Close")
                    .font(.headline).bold(true)
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.23, green: 0.29, blue: 0.36))
                    .cornerRadius(25)
                    .shadow(radius: 3)
                    .bold(true)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 10)
            .padding(.bottom, 680)
            VStack(spacing: 20) {
                Text("Your Trade QR Code")
                    .font(.system(size: 22, weight: .bold))
                    .shadow(color: .black ,radius: 1)
                    .bold()
                    .multilineTextAlignment(.center)
                
                AsyncImage(url: model.tradeQRCodeURL) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                } placeholder: {
                    ProgressView()
                }
                
                Text("Make sure to give a good offer!")
                    .font(.system(size: 22, weight: .bold))
                    .shadow(color: .black ,radius: 1)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            .padding()
            
        }
    }
}

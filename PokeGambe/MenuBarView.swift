//
//  MenuBarView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/20/25.
//

import SwiftUI

public struct MenuBarView: View {
    @Binding var balance: Double
    @Binding var showGains: Bool
    @Binding var gains: Double
    @Binding var showOptionsMenu: Bool
    public var body: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.9, green: 0.95, blue: 0.7),  // Cool yellow (a hint toward blue-green)
                    Color(red: 0.5, green: 0.7, blue: 1.0)    // Soft blue
                ]),
                startPoint: .top,
                endPoint: .bottom
            ))
            .edgesIgnoringSafeArea(.all)
            .padding(.bottom, 735)
            .shadow(radius: 5)
            .opacity(0.8)
        VStack{
            ZStack {
                Text("$\(String(format: "%.2f", balance))")
                    .font(.title2)
                    .foregroundColor(colorForBalance(balance))
                    .frame(alignment: .center)
                    .padding(.bottom, 735)
                    .shadow(color: .black ,radius: 0.5)
                    .bold(true)
                

                if showGains {
                    Text("\(gains >= 0 ? "+" : "")\(String(format: "%.2f", gains))")
                        .font(.title3)
                        .foregroundColor(gains >= 0 ? .green : .red)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20)
                        .padding(.bottom, 735)
                        .transition(.opacity)
                        .shadow(color: .black ,radius: 0.5)
                }
                HStack {
                    Button(action: {
                        showOptionsMenu.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 28, height: 25)
                            .foregroundStyle(.yellow)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .shadow(radius: 2)
                    }
                    Spacer()
                }
                .padding(.leading, 7)
                .padding(.bottom, 740)
                
            }
        }
    }
}

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
            .fill(Color.yellow)
            .edgesIgnoringSafeArea(.all)
            .padding(.bottom, 735)
            .shadow(radius: 5)
        VStack{
            ZStack {
                Text("Balance: \(String(format: "%.2f", balance))")
                    .font(.title2)
                    .foregroundColor(colorForBalance(balance))
                    .frame(alignment: .center)
                    .padding(.bottom, 735)

                if showGains {
                    Text("\(gains >= 0 ? "+" : "")\(String(format: "%.2f", gains))")
                        .font(.title3)
                        .foregroundColor(gains >= 0 ? .green : .red)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 20)
                        .padding(.bottom, 735)
                        .transition(.opacity)
                }
                HStack {
                    Button(action: {
                        showOptionsMenu.toggle()
                    }) {
                        Text("Menu")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(25)
                    }
                    Spacer()
                }
                .padding(.leading, 7)
                .padding(.bottom, 740)
            }
        }
    }
}

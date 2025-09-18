//
//  ITSCHOPPEDVIEW.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/18/25.
//

import SwiftUI
import SwiftData

public struct ITSCHOPPEDVIEW: View {
    @Environment(GameStateModel.self) private var model
    
    public var body: some View {
        ZStack {
            BackgroundView()
                .opacity(0.70)
            VStack {
                Button(action: {
                    model.showOptionsMenu.toggle()
                    model.showAddFunds = true
                }) {
                    Text("Add Funds")
                        .font(.headline).bold(true)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 3)
                        .bold(true)
                }
                Button(action: {
                    model.showOptionsMenu.toggle()
                    //updateBalanceBasedOnTime()
                }) {
                    Text("History")
                        .font(.headline).bold(true)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 3)
                        .bold(true)
                }
                Button(action: {
                    //refreshDexValue()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        model.refreshedView = false
                    }
                }) {
                    Text("Refresh Dex Value")
                        .font(.headline).bold(true)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 3)
                        .bold(true)
                        .multilineTextAlignment(.center)
                }
                Button(action: {
                    model.showOptionsMenu.toggle()
                }) {
                    Text("Close Menu")
                        .font(.headline).bold(true)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .shadow(radius: 3)
                        .bold(true)
                }
            }
            
            if model.refreshedView {
                ZStack {
                    Rectangle().fill(Color.white)
                        .frame(width: 280, height: 170)
                        .cornerRadius(25)
                        .opacity(0.30)
                    
                    Text("Refreshed\nDex Value\nCleared\nTemp Files")
                        .font(.system(size: 30))
                        .bold(true)
                        .shadow(radius: 3)
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 500)
            }
            
            if model.showAddFunds {
                ZStack {
                    BackgroundView()
                        .opacity(0.70)
                    
                    Button(action: {
                        model.showOptionsMenu = true
                        model.showAddFunds = false
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
                    
                    Text("Add Funds")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .padding(.bottom, 600)
                    
                    Rectangle()
                        .frame(width: 300, height: 100)
                        .foregroundColor(.purple)
                        .cornerRadius(40)
                        .opacity(0.60)
                    
                    Text("Enter Value: $10000000 TODO")
                }
            }
        }
    }
}


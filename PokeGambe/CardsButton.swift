//
//  Untitled.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/20/25.
//

import SwiftUI
struct CardsButtonView: View {
    @Environment(GameStateModel.self) private var model
    let action: () -> Void
    var body: some View {
        VStack{
            Button(action: {
                if !model.isOpeningPack {
                    action()
                }
            }) {
                Text( model.cardViewShow ?  "Sell Rest" : "Open Pack")
                    .font(.headline).bold(true)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color.yellow)
                    .cornerRadius(25)
                    .shadow(radius: 3)
                    .bold(true)
            }
//            if isOpeningPack {
//                VStack{
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle())
//                    
//                    Text(currentQuote)
//                        .foregroundColor(.white)
//                        .bold(true)
//                        .shadow(radius: 3)
//                }
//            }
        }
    }
}

//
//  Untitled.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/20/25.
//

import SwiftUI
struct CardsButtonView: View {
    @Binding var isOpeningPack: Bool
    @Binding var currentQuote: String
    @Binding var cardViewShow: Bool
    @Binding var pulledCards: [Card]
    let action: () -> Void
    var body: some View {
        VStack{
            Button(action: {
                action()
            }) {
                Text( cardViewShow ?  "Sell Rest" : "Open Pack")
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

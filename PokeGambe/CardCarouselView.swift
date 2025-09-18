//
//  CardCarouselView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/18/25.
//

import SwiftUI
import SwiftData

public struct CardCarouselView: View {
    @Binding var cards: [Card]
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach($cards) { $card in
                    CardView(card: $card)
                    if cards.isEmpty {
                        Text("No $s loaded.")
                    }
                }
            }
        }
        Spacer()
            .frame(height: 20)
    }
}

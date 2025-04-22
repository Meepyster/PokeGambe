//
//  TotalView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/20/25.
//

import SwiftUI

struct TotalView: View {
    @Binding var cardResponse: CardResponse?
    @Binding var pulledCards: [Card]

    var body: some View {
        Text("Current Pack Value: \(String(format: "%.2f", getTotalValue()))")
            .font(.system(size: 27))
            .foregroundColor(.white)
            .padding(.top)
            .shadow(radius: 3)
            .bold()
    }

    func getTotalValue() -> Double {
        guard var total = cardResponse?.totalValue else {
            return 0.00
        }
        for card in pulledCards {
            total -= card.value
        }
        if abs(total) < 0.0001 {
            return 0.0
        }
        return total
    }
}

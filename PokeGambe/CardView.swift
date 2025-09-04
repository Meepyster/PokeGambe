//
//  CardView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/20/25.
//

import SwiftUI
import SwiftData

struct CardView: View {
    @Binding var card: Card
    @Binding var pulledCards: [Card]
    @State private var dragOffset = CGSize.zero
    @Environment(\.modelContext) var modelContext
    @State private var saveNotif = false
    @State private var loadingAlert = false
    @Binding var balance: Double
    @Binding var isOpeningPack: Bool
    
    func saveCard(_ card: Card) {
        pulledCards.append(card)
        print("Card Added to pullCards: \(card.name) \(card.id)")
    }
    
    func removeCard(_ card: Card) {
        print("All Cards in Pulled Cards")
        for c in pulledCards{
            print(c.name, c.id)
            }
        pulledCards.removeAll { $0.id == card.id }
        print("Card to find in pulledCards: \(card.id)")
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(card.cardTitle)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(colorForRarity(card.rarity))
                    .shadow(color: .black ,radius: 1)
                    .bold()
                    .multilineTextAlignment(.center)
                Button(action: {
                    if !pulledCards.contains(where: { $0.id == card.id }) && !isOpeningPack {
                        saveCard(card)
                        saveNotif = true
                    }
                    else if isOpeningPack && !pulledCards.contains(where: { $0.id == card.id }){
                        loadingAlert = true
                    }
                    else if !isOpeningPack && pulledCards.contains(where: { $0.id == card.id }){
                        removeCard(card)
                        saveNotif = false
                    }
                }) {
                    Image(systemName: "square.and.arrow.down.fill")
                        .resizable()
                        .frame(width: 25, height: 33)
                        .foregroundStyle(colorForRarity(card.rarity))
                        .shadow(color: .black ,radius: 1)
                }
            }
            ZStack{
                AsyncImage(url: URL(string: card.cardImage)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 450)
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "xmark.octagon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 200)
                            .foregroundColor(.red)
                    @unknown default:
                        EmptyView()
                    }
                }.shadow(radius: 3)
                
                if saveNotif {
                    Text("Saved to Dex!")
                        .font(.system(size: 40))
                        .bold(true)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.6))
                        )
                        .padding(.top, 20)
                }

                if loadingAlert {
                    Text("Can Not Save\nWhile Loading")
                        .font(.system(size: 40))
                        .bold(true)
                        .foregroundColor(.red)
                        .shadow(radius: 3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.7))
                        )
                        .padding(.top, 20)
                }
            }
            Text("$\(String(format: "%.2f", card.value))")
                .font(.system(size: 18))
                .foregroundColor(.white)
                .bold(true)
                .shadow(radius: 3)
        }
    }
}

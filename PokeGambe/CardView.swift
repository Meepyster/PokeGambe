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
        let savedCard = DBCard(
            id: card.id,
            cardTitle: card.cardTitle,
            name: card.name,
            baseExperience: card.baseExperience,
            cardImage: card.cardImage,
            rarity: card.rarity,
            value: card.value,
            realMarketValue: card.realMarketValue,
            discrepancyRatio: card.discrepancyRatio,
            subtypes: card.subtypes
        )
        modelContext.insert(savedCard)
        try? modelContext.save()
        print("Card saved id: \(savedCard.id)")
        
        let savedHistCard = HistCard(
            id: card.id,
            cardTitle: card.cardTitle,
            name: card.name,
            baseExperience: card.baseExperience,
            cardImage: card.cardImage,
            rarity: card.rarity,
            value: card.value,
            realMarketValue: card.realMarketValue,
            discrepancyRatio: card.discrepancyRatio,
            subtypes: card.subtypes
        )
        modelContext.insert(savedHistCard)
        try? modelContext.save()
        
        // Optional: show confirmation
        print("Card saved: \(savedCard.name)")
        print("Card saved in History: \(savedHistCard.name)")
    }
    
    func removeCard(_ card: Card) {
        if let allCards = try? modelContext.fetch(FetchDescriptor<DBCard>()) {
            print("All DB Cards in storage:")
            for c in allCards {
                print(c.name, c.id)
            }
        }
        if let existing = try? modelContext.fetch(FetchDescriptor<DBCard>()).first(where: {$0.id.uuidString == card.id.uuidString }) {
            modelContext.delete(existing)
            try? modelContext.save()
            print("Card removed: \(existing.name)")
        } else {
            print("Card not found in DBCard")
            print("Card to find id in db: \(card.id)")
        }
        
        if let existingHist = try? modelContext.fetch(FetchDescriptor<HistCard>()).first(where: {$0.id == card.id }) {
            modelContext.delete(existingHist)
            try? modelContext.save()
            print("Card removed: \(existingHist.name)")
        } else {
            print("Card not found in HistCard")
            print("Card to find id in hist: \(card.id)")
        }
        print("REMOVED GONE")
        pulledCards.removeAll { $0.id == card.id }
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(card.cardTitle)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(colorForRarity(card.rarity))
                    .shadow(radius: 3)
                    .bold()
                Button(action: {
                    if !pulledCards.contains(where: { $0.id == card.id }) && !isOpeningPack {
                        saveCard(card)
                        pulledCards.append(card)
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
                        .foregroundColor(colorForRarity(card.rarity))
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
            Text("Value: \(String(format: "%.2f", card.value))")
                .font(.system(size: 18))
                .foregroundColor(.white)
                .bold(true)
                .shadow(radius: 3)
        }
    }
}

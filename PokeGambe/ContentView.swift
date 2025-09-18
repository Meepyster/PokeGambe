//
//  ContentView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/19/25.
//


import SwiftUI
import SwiftData
import CodeScanner

struct ContentView: View {
    
    @Environment(GameStateModel.self) private var model
    @Environment(\.modelContext) var modelContext
    @State private var cards: [Card] = []
    @Query var savedCards: [DBCard]
    @Query var savedHistCards: [HistCard]

    var body: some View {
        ZStack{
            BackgroundView()
            MenuBarView()
            VStack {
                if model.cardViewShow{
                    TotalView()
                }
                CardCarouselView(cards:$cards)
                HStack{
                    PokeDexButtonView()
                    CardsButtonView(action: getCards)
                }
                if model.isOpeningPack {
                    LoadingQuoteView()
                }
            }
            if model.showHistDex {
                HistDexView()
            }
            if model.showDex {
                DexView(action: startTradeA)
            }
            if model.showScanner {
                ScannerView()
            }
            if model.showTradeQR {
                QRCodeView()
            }
            if model.isTradingA{
                ZStack{
                    BackgroundView()
                        .opacity(0.70)
                }
                Text("IT FUCKING WORKS")
                    .font(.system(size: 40, weight: .bold))
                    .shadow(color: .black ,radius: 1)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            if model.showOptionsMenu {
                ITSCHOPPEDVIEW()
            }
        }.onAppear(perform: updateBalanceBasedOnTime)
    }

    private func getCards() {
        if !model.pulledCards.isEmpty {
            for card in model.pulledCards {
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
        }
        clearTempDirectory()
        print("trying to get cards")
        for card in model.pulledCards {
            model.dexValue += card.value
        }
        model.isOpeningPack = true
        model.balance -= 30
        model.gains = -30
        var change = 0.00
        if model.cardViewShow {
            for card in model.pulledCards {
                model.balance -= card.value
                change -= card.value
            }
            model.balance += model.cardResponse!.totalValue
            model.gains += model.cardResponse!.totalValue + change
        }
        model.showGains = true
        model.currentQuote = loadingQuotes.randomElement() ?? "Opening pack..."
        Task {
            do {
                let result = try await CardService.fetchCards()
                model.cardResponse = result
                cards = model.cardResponse!.cards
                model.buttonArmed = true
                model.pulledCards.removeAll()
            } catch {
                print("Error fetching cards: \(error)")
                model.buttonArmed = false
            }
            model.isOpeningPack = false
            model.showGains = false
            model.cardViewShow = true
        }
    }
    func refreshDexValue() {
        model.dexValue = 0.00
        Task{
            do {
                let allCards = try modelContext.fetch(FetchDescriptor<DBCard>())
                for card in allCards {
                    if !model.pulledCards.contains(where: {$0.id == card.id}){
                        model.dexValue += Double(card.value)
                    }
                }
                Task {
                    clearTempDirectory()
                }
                model.refreshedView = true
            } catch {
                print("Failed to fetch DBCard objects: \(error)")
            }
        }
    }
    
    func clearTempDirectory() {
        let tempDir = FileManager.default.temporaryDirectory
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: tempDir.path)
            for file in files {
                let fileURL = tempDir.appendingPathComponent(file)
                try FileManager.default.removeItem(at: fileURL)
            }
            print("Temporary files cleared.")
        } catch {
            print("Failed to clear temp directory: \(error)")
        }
    }
    func sellDex() {
        model.balance += model.dexValue
        model.dexValue = 0.00
        do {
            try modelContext.delete(model: DBCard.self)
        } catch {
            print("Failed to clear")
        }
        model.showConfirm.toggle()
        clearTempDirectory()
    }
    
    func startTradeA() {
        if let card = model.cardToShow {
            model.pollingTask?.cancel()
            model.pollingTask = TradeService.startPolling(tradeId: card.id.uuidString) { trade in
                Task { @MainActor in
                    model.tradeStatus = trade
                    if trade.status == "joined" {
                        model.showTradeQR = false
                        model.isTradingA = true
                    }
                }
            }
        }
    }

    func stopPolling() {
        model.pollingTask?.cancel()
        model.pollingTask = nil
    }

    func updateBalanceBasedOnTime() {
        let now = Date().timeIntervalSince1970
        let timePassed = now - model.lastUpdated
        print(model.lastUpdated)
        let minutesPassed = timePassed / 60
        let increments = minutesPassed / 3
        print(increments)
        print(minutesPassed)
        print(now)
        if increments > 0 {
            model.balance += (Double(increments) * 100).rounded() / 100
            model.lastUpdated = now
        }
    }

}

func colorForRarity(_ rarity: String) -> LinearGradient {
    switch rarity {
    case "Common", "Uncommon":
        return LinearGradient(
            gradient: Gradient(colors: [.white, .white]),
            startPoint: .trailing,
            endPoint: .leading
        )
    case "Rare":
        return LinearGradient(
            gradient: Gradient(colors: [.green, .mint]),
            startPoint: .trailing,
            endPoint: .leading
        )
    case "Rare Holo", "Amazing Rare":
        return LinearGradient(
            gradient: Gradient(colors: [Color(red: 1.0, green: 0.85, blue: 0.2), Color(red: 1.0, green: 0.85, blue: 0.2)]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "Rare Holo LV.X", "Rare Holo GX", "Rare Holo EX", "Promo", "Illustration Rare":
        return LinearGradient(
            gradient: Gradient(colors: [.orange, .yellow]),
            startPoint: .leading,
            endPoint: .trailing
        )
    case "Rare Secret", "Rare Ultra", "Rare Shiny", "Rare Shiny GX":
        return LinearGradient(
            gradient: Gradient(colors: [.red, .pink]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case "Rare Holo VSTAR":
        return LinearGradient(
            gradient: Gradient(colors: [.white, Color(red: 0.6, green: 0.85, blue: 1.0), Color(red: 0.7, green: 1.0, blue: 0.7)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case "Rare Rainbow":
        return LinearGradient(
            gradient: Gradient(colors: [.green,.yellow, .orange,.pink, .blue, .purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    case "Rare Holo Star", "Rare Prism Star":
        return LinearGradient(
            gradient: Gradient(colors: [.yellow, .orange]),
            startPoint: .top,
            endPoint: .bottom
        )
    case "LEGEND":
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.85, blue: 0.2),
                .black
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    default:
        return LinearGradient(
            gradient: Gradient(colors: [.gray, .black]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

func negZeroCheck(num: Double) -> Double {
    if num < 0.00 && num > -0.01 {
        return 0.00
    }
    return num
}


func colorForBalance(_ balance: Double) -> Color {
    if balance < 25 {
        return .red
    }
    return .white
}


let loadingQuotes = [
    "Shuffling the pixels...",
    "Dawg your cooked",
    "Put the fries in the bag...",
    "ts ckd br... 🥀",
    "THIS WILL BE IT",
    "RAHHHHHHHHHH",
    "Surely Surley Surley ...",
    "Drawing power from the Pokéballs...",
    "Feeding your luck stat...",
    "Polishing holographics ✨",
    "Connecting on linkedIn...",
    "Ensuring cards are fresh...",
    "Buffing rates...",
    "DEVS LISTENED",
    "xd",
    "You wait here... for what?",
    "This API is cooked bruh",
    "Give it like, 10 seconds...",
    "mimimimimimi......",
    "Let me knoooooow, let me knooooow",
    "DoyoulovethewayIdowhenImlovinyourbody?",
    "AAAHHH AHHHHHH - French Woman",
    "You will in fact not be the very best...",
    "😂"
    
]

//#Preview {
//    ContentView()
//}

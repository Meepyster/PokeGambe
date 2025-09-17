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
    
    @Bindable var gameState: GameStateModel
    
    @State private var pollingTask: Task<Void, Never>? = nil
    @State private var isPolling: Bool = false
    @State private var isTradingA: Bool = false
    @State private var isTradingB: Bool = false
    @State private var tradeStatus: Trade?
    @Environment(\.modelContext) var modelContext
    @State private var cards: [Card] = []
    @State private var isOpeningPack = false
    @State private var cardResponse: CardResponse?
    @State private var currentQuote = ""
    @State private var profit: Double = 0
    @AppStorage("IGN") private var IGN: String = "TONKYWONKY"
    @AppStorage("balance") private var balance: Double = 100
    @State private var showGains: Bool = false
    @State private var gains: Double = 0
    @State private var showDex: Bool = false
    @State private var showHistDex: Bool = false
    @State private var showConfirm: Bool = false
    @Query var savedCards: [DBCard]
    @Query var savedHistCards: [HistCard]
    @State private var showLargeImage: Bool = false
    @State private var cardToShow: DBCard?
    @State private var histCardToShow: HistCard?
    @State private var showOptionsMenu: Bool = false
    @State private var showLargeHistImage:Bool = false
    @State private var cardViewShow: Bool = false
    @State private var pulledCards: [Card] = []
    @State private var showTotalView: Bool = false
    @AppStorage("dexValue") private var dexValue: Double = 0.00
    @State private var refreshedView: Bool = false
    @State private var showAddFunds: Bool = false
    @State private var toAdd: String = "0.00"
    @State private var buttonArmed: Bool = true
    @AppStorage("lastUpdated") private var lastUpdated: Double = Date().timeIntervalSince1970
    
    // 🔥 New Trade + Scan State
    @State private var showTradeQR = false
    @State private var tradeQRCodeURL: URL?
    @State private var showScanner = false
    @State private var scannedCode: String?
    @State private var tradeToShow: Card?
    @State private var showLargeTradeImage: Bool = false
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.3, green: 0.4, blue: 0.9), Color(red: 0.6, green: 0.8, blue: 1.0)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            MenuBarView(balance: $balance, showGains: $showGains, gains:$gains, showOptionsMenu: $showOptionsMenu)
            VStack {
                if cardViewShow{
                    TotalView(cardResponse: $cardResponse, pulledCards: $pulledCards)
                }
                Spacer()
                    .frame(height:-5)
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
                HStack{
                    Button(action: {
                        showDex.toggle()
                    }) {
                        Text("My PokeDex")
                            .font(.headline).bold(true)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                            .background(Color(red: 0.3, green: 0.5, blue: 1.0))
                            .cornerRadius(25)
                            .shadow(radius: 3)
                            .bold(true)
                    }
                    CardsButtonView(isOpeningPack: $isOpeningPack, currentQuote: $currentQuote, cardViewShow: $cardViewShow, pulledCards: $pulledCards, buttonArmed: $buttonArmed, action: getCards)
                }
                if isOpeningPack {
                    VStack{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        
                        Text(currentQuote)
                            .foregroundColor(.white)
                            .bold(true)
                            .shadow(radius: 3)
                    }
                }
            }
            if showHistDex {
                HistDexView(showLargeHistImage: $showLargeHistImage, histCardToShow: $histCardToShow, showHistDex: $showHistDex, showDex: $showDex)
            }
            if showDex {
                DexView(pollingTask:$pollingTask,action: startTradeA,IGN: $IGN, dexValue: $dexValue, balance: $balance, showLargeImage: $showLargeImage, cardToShow: $cardToShow, showDex: $showDex, showHistDex: $showHistDex, showLargeTradeImage: $showLargeTradeImage, tradeToShow: $tradeToShow, showTradeQR: $showTradeQR, tradeQRCodeURL: $tradeQRCodeURL, pulledCards: $pulledCards, showScanner: $showScanner, isPolling:$isPolling, showConfirm: $showConfirm)
            }
            if showScanner {
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .opacity(0.70)
                    CodeScannerView(
                        codeTypes: [.qr],
                        completion: handleScan
                    )
                    Button(action: {
                        showScanner.toggle()
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
                }
            }
            if showTradeQR {
                QRCodeView(pollingTask:$pollingTask,showTradeQR:$showTradeQR, tradeQRCodeURL: $tradeQRCodeURL, trade:$tradeStatus)
            }
            if isTradingA{
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .opacity(0.70)
                }
                Text("IT FUCKING WORKS")
                    .font(.system(size: 40, weight: .bold))
                    .shadow(color: .black ,radius: 1)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            if showOptionsMenu {
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .opacity(0.70)
                    VStack{
                        Button(action: {
                            showOptionsMenu.toggle()
                            showAddFunds = true
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
                            showOptionsMenu.toggle()
                            updateBalanceBasedOnTime()
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
                            refreshDexValue()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                refreshedView = false
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
                            showOptionsMenu.toggle()
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
                    if refreshedView {
                        ZStack{
                            Rectangle().fill(Color.white)
                                .frame(width: 280, height: 170)
                                .cornerRadius(25)
                                .opacity(0.30)
                            Text("Refreshed\nDex Value\nCleared\nTemp Files")
                                .font(.system(size: 30))
                                .bold(true)
                                .shadow(radius: 3)
                                .foregroundColor(.white)
                                .padding(.leading,10)
                                .multilineTextAlignment(.center)
                        }.padding(.bottom, 500)
                    }
                }
            }
            // neck
            if showAddFunds{
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .opacity(0.70)
                    Button(action: {
                        showOptionsMenu = true
                        showAddFunds = false
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
                    TextField("Enter Value:", text: $toAdd)
                }
            }
        }.onAppear(perform: updateBalanceBasedOnTime)
    }

    private func getCards() {
        if !pulledCards.isEmpty {
            for card in pulledCards {
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
        for card in pulledCards {
            dexValue += card.value
        }
        isOpeningPack = true
        balance -= 30
        gains = -30
        var change = 0.00
        if cardViewShow {
            for card in pulledCards {
                balance -= card.value
                change -= card.value
            }
            balance += cardResponse!.totalValue
            gains += cardResponse!.totalValue + change
        }
        showGains = true
        currentQuote = loadingQuotes.randomElement() ?? "Opening pack..."
        Task {
            do {
                let result = try await CardService.fetchCards()
                cardResponse = result
                cards = cardResponse!.cards
                buttonArmed = true
                pulledCards.removeAll()
            } catch {
                print("Error fetching cards: \(error)")
                buttonArmed = false
            }
            isOpeningPack = false
            showGains = false
            cardViewShow = true
        }
    }
    func refreshDexValue() {
        dexValue = 0.00
        Task{
            do {
                let allCards = try modelContext.fetch(FetchDescriptor<DBCard>())
                for card in allCards {
                    if !pulledCards.contains(where: {$0.id == card.id}){
                        dexValue += Double(card.value)
                    }
                }
                Task {
                    clearTempDirectory()
                }
                refreshedView = true
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
        balance += dexValue
        dexValue = 0.00
        do {
            try modelContext.delete(model: DBCard.self)
        } catch {
            print("Failed to clear")
        }
        showConfirm.toggle()
        clearTempDirectory()
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let scanResult):
            scannedCode = scanResult.string
            showScanner = false
            print("Scanned code: \(scanResult.string)")

            Task {
                do {
                    let card = try await CardService.fetchTradedCard(scanResult.string)
                    tradeToShow = card
                    showLargeTradeImage = true
                    print("Fetched traded card: \(card.cardTitle)")
                } catch {
                    print("❌ Failed to fetch traded card: \(error)")
                }
            }

        case .failure(let error):
            print("❌ Scanning failed: \(error.localizedDescription)")
            showScanner = false
        }
    }
    func startTradeA() {
        if let card = cardToShow {
            pollingTask?.cancel()
            pollingTask = TradeService.startPolling(tradeId: card.id.uuidString) { trade in
                Task { @MainActor in
                    tradeStatus = trade
                    if trade.status == "joined" {
                        showTradeQR = false
                        isTradingA = true
                    }
                }
            }
        }
    }

    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    func updateBalanceBasedOnTime() {
        let now = Date().timeIntervalSince1970
        let timePassed = now - lastUpdated
        print(lastUpdated)
        let minutesPassed = timePassed / 60
        let increments = minutesPassed / 3
        print(increments)
        print(minutesPassed)
        print(now)
        if increments > 0 {
            balance += (Double(increments) * 100).rounded() / 100
            lastUpdated = now
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

struct QRScannerView: View {
    @Environment(\.dismiss) var dismiss
    var onScan: (String) -> Void

    var body: some View {
        CodeScannerView(codeTypes: [.qr]) { result in
            switch result {
            case .success(let code):
                onScan(code.string)
                dismiss()
            case .failure(let error):
                print("Scanning failed: \(error)")
                dismiss()
            }
        }
    }
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

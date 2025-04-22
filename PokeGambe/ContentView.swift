//
//  ContentView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/19/25.
//


import SwiftUI
import SwiftData

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

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var cards: [Card] = []
    @State private var isOpeningPack = false
    @State private var cardResponse: CardResponse?
    @State private var currentQuote = ""
    @State private var profit: Double = 0
    @AppStorage("balance") private var balance: Double = 0
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
                            CardView(card: $card, pulledCards: $pulledCards, balance: $balance, isOpeningPack: $isOpeningPack)
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
                    CardsButtonView(isOpeningPack: $isOpeningPack, currentQuote: $currentQuote, cardViewShow: $cardViewShow, pulledCards: $pulledCards, action: getCards)
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
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.3, green: 0.4, blue: 0.9), Color(red: 0.6, green: 0.8, blue: 1.0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .opacity(0.70)
                    Rectangle()
                        .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .frame(width: 350, height: 670)
                        .cornerRadius(25)
                    Text("History Dex")
                        .font(.system(size: 25))
                        .foregroundStyle(.blue)
                        .bold(true)
                        .padding(.bottom,620)
                        .shadow(radius: 3)
                    VStack {
                            
                        // Scrollable list of images
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 4)], spacing: 3) {
                                ForEach(savedHistCards) { card in
                                    Button(action: {
                                        showLargeHistImage.toggle()
                                        histCardToShow = card
                                    }) {
                                        AsyncImage(url: URL(string: card.cardImage)) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 140)
                                                .cornerRadius(10)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 100, height: 140)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(height: 620)
                        .padding(.top, 100)
                        
                        Spacer()
                    }
                    Button(action: {
                        showDex = false
                        showHistDex = false
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
                    HStack{
                        Button(action: {
                            showDex.toggle()
                            showHistDex.toggle()
                        }) {
                            Text("Swap Dex")
                                .font(.headline).bold(true)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .background(Color.yellow)
                                .cornerRadius(25)
                                .shadow(radius: 3)
                                .bold(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing,20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,30)
                    .padding(.top,720)
                    if showLargeHistImage {
                        ZStack{
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                            .opacity(0.70)
                            VStack{
                                Text(histCardToShow!.cardTitle)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(colorForRarity(histCardToShow!.rarity))
                                    .shadow(radius: 3)
                                    .bold()
                                AsyncImage(url: URL(string: histCardToShow!.cardImage)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 520)
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
                                Text("Value: \(String(format: "%.2f", histCardToShow!.value))")
                                    .font(.system(size: 23))
                                    .foregroundColor(.white)
                                    .bold(true)
                                    .shadow(radius: 3)
                            }
                        }
                        Button(action: {
                            showLargeHistImage.toggle()
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
            }
            if showDex {
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.3, green: 0.4, blue: 0.9), Color(red: 0.6, green: 0.8, blue: 1.0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .opacity(0.70)
                    
                    Rectangle()
                        .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .frame(width: 350, height: 670)
                        .cornerRadius(25)
                    HStack{
                        Text("Trading Dex")
                            .font(.system(size: 20))
                            .foregroundStyle(.blue)
                            .bold(true)
                            .padding(.bottom,620)
                            .shadow(radius: 3)
                        
                        Text("\(String(format: "%.2f", dexValue))")
                            .font(.system(size: 20))
                            .foregroundStyle(.red)
                            .bold(true)
                            .padding(.bottom,620)
                            .shadow(radius: 3)
                    }
                    VStack {
                        
                        // Scrollable list of images
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 4)], spacing: 3) {
                                ForEach(savedCards) { card in
                                    Button(action: {
                                        showLargeImage.toggle()
                                        cardToShow = card
                                    }) {
                                        AsyncImage(url: URL(string: card.cardImage)) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 140)
                                                .cornerRadius(10)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 100, height: 140)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(height: 620)
                        .padding(.top, 100)
                        
                        Spacer()
                    }
                    Button(action: {
                        showDex = false
                        showHistDex = false
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
                    HStack{
                        Button(action: {
                            showConfirm.toggle()
                        }) {
                            Text("TRADE DEX")
                                .font(.headline).bold(true)
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .cornerRadius(25)
                                .shadow(radius: 3)
                                .bold(true)
                        }
                        Button(action: {
                            showHistDex.toggle()
                            showDex.toggle()
                        }) {
                            Text("Swap Dex")
                                .font(.headline).bold(true)
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 15)
                                .background(Color.yellow)
                                .cornerRadius(25)
                                .shadow(radius: 3)
                                .bold(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing,20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading,30)
                    .padding(.top,720)
                    
                    
                    if showConfirm {
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                        .opacity(0.70)
                        Text("Are you sure you want to clear and trade your entire PókeDex?")
                            .font(.system(size: 30))
                            .bold(true)
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal, 30)
                            .padding(.bottom,500)
                            .multilineTextAlignment(.center)
                            .shadow(radius: 3)
                        HStack{
                            Button(action: {
                                do {
                                    try modelContext.delete(model: DBCard.self)
                                } catch {
                                    print("Failed to clear")
                                }
                                showConfirm.toggle()
                            }) {
                                Text("YES")
                                    .font(.headline).bold(true)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 20)
                                    .background(Color.red)
                                    .cornerRadius(25)
                                    .shadow(radius: 3)
                                    .bold(true)
                            }
                            Button(action: {
                                showConfirm.toggle()
                            }) {
                                Text("NO")
                                    .font(.headline).bold(true)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 20)
                                    .background(Color.green)
                                    .cornerRadius(25)
                                    .shadow(radius: 3)
                                    .bold(true)
                            }
                        }
                    }
                    if showLargeImage {
                        ZStack{
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                            .opacity(0.70)
                            VStack{
                                Text(cardToShow!.cardTitle)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(colorForRarity(cardToShow!.rarity))
                                    .shadow(radius: 3)
                                    .bold()
                                AsyncImage(url: URL(string: cardToShow!.cardImage)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 520)
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
                                Text("Value: \(String(format: "%.2f", cardToShow!.value))")
                                    .font(.system(size: 23))
                                    .foregroundColor(.white)
                                    .bold(true)
                                    .shadow(radius: 3)
                            }
                        }
                        Button(action: {
                            showLargeImage.toggle()
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
                        Button(action: {
                            if !pulledCards.contains(where: { $0.id == cardToShow!.id }){
                                showLargeImage.toggle()
                                balance += cardToShow!.value
                                modelContext.delete(cardToShow!)
                                try? modelContext.save()
                            }
                        }) {
                            Text("Sell")
                                .font(.headline).bold(true)
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 10)
                                .background(Color.red)
                                .cornerRadius(25)
                                .shadow(radius: 3)
                                .bold(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading,30)
                        .padding(.top,690)
                    }
                }
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
                                .frame(width: 250, height: 100)
                                .cornerRadius(25)
                                .opacity(0.30)
                            Text("Refreshed\nDex Value")
                                .font(.system(size: 30))
                                .bold(true)
                                .shadow(radius: 3)
                                .foregroundColor(.white)
                                .padding(.leading,10)
                        }.padding(.bottom, 500)
                    }
                }
            }
        }
    }

    private func getCards() {
        print("trying to get cards")
        for card in pulledCards {
            dexValue += card.value
        }
        isOpeningPack = true
        balance -= 35
        gains = -35
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
            } catch {
                print("Error fetching cards: \(error)")
            }
            isOpeningPack = false
            
//            if let total = cardResponse?.totalValue {
//                balance += total
//                gains = total - 24
//            }
            
            pulledCards.removeAll()
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
                refreshedView = true
            } catch {
                print("Failed to fetch DBCard objects: \(error)")
            }
        }
    }
}
func colorForRarity(_ rarity: String) -> Color {
    switch rarity {
    case "Common", "Uncommon":
        return .white
    case "Rare":
        return .green
    case "Rare Holo","Amazing Rare":
        return .purple
    case "Rare Holo LV.X", "Rare Holo GX", "Rare Holo EX", "Promo", "Illustration Rare":
        return .orange
    case "Rare Secret", "Rare Ultra", "Rare Shiny", "Rare Shiny GX":
        return .red
    case "Rare Rainbow":
        return .pink
    case "Rare Holo Star", "Rare Prism Star":
        return .yellow
    case "LEGEND":
        return .mint
    default:
        return .primary
    }
}

func colorForBalance(_ balance: Double) -> Color {
    if balance < 25 {
        return .red
    }
    if balance > 50{
        return .blue
    }
    return .white
}


#Preview {
    ContentView()
}

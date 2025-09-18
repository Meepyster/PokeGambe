//
//  DexView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/3/25.
//
import SwiftUI
import SwiftData
struct DexView: View {
    @Environment(GameStateModel.self) private var model
    
    let action: () -> Void
    
    // SwiftData query
    @Environment(\.modelContext) var modelContext
    @Query var savedCards: [DBCard]
    
    var body: some View {
        ZStack{
            BackgroundView()
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
                
                Text("\(String(format: "%.2f", model.dexValue))")
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
                                model.showLargeImage.toggle()
                                model.cardToShow = card
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
            }.onAppear {
                print("Dex loaded with \(savedCards.count) cards")
                for card in savedCards {
                    print("Card: \(card.cardTitle)")
                }
            }
            Button(action: {
                model.showDex = false
                model.showHistDex = false
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
                    model.showConfirm.toggle()
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
                // 🔥 Scan QR Button
                Button(action: {
                    model.showScanner = true
                }) {
                    Text("Scan QR")
                        .font(.headline).bold(true)
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.green)
                        .cornerRadius(25)
                        .shadow(radius: 3)
                }
                Button(action: {
                    model.showHistDex.toggle()
                    model.showDex.toggle()
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
            
            
            if model.showConfirm {
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
                        sellDex()
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
                        model.showConfirm.toggle()
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
            if model.showLargeTradeImage {
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .opacity(0.70)
                    VStack{
                        Text(model.tradeToShow!.cardTitle)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(colorForRarity(model.tradeToShow!.rarity))
                            .shadow(color: .black ,radius: 1)
                            .bold()
                            .multilineTextAlignment(.center)
                        AsyncImage(url: URL(string: model.tradeToShow!.cardImage)) { phase in
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
                        Text("$\(String(format: "%.2f", model.tradeToShow!.value))")
                            .font(.system(size: 23))
                            .foregroundColor(.white)
                            .bold(true)
                            .shadow(radius: 3)
                    }
                }
                Button(action: {
                    model.showLargeTradeImage.toggle()
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
            if model.showLargeImage {
                ZStack{
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.3, green: 0.3, blue: 0.7), Color(red: 0.5, green: 0.6, blue: 0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .opacity(0.70)
                    VStack{
                        Text(model.cardToShow!.cardTitle)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(colorForRarity(model.cardToShow!.rarity))
                            .shadow(color: .black ,radius: 1)
                            .bold()
                            .multilineTextAlignment(.center)
                            .multilineTextAlignment(.center)
                        AsyncImage(url: URL(string: model.cardToShow!.cardImage)) { phase in
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
                        Text("$\(String(format: "%.2f", model.cardToShow!.value))")
                            .font(.system(size: 23))
                            .foregroundColor(.white)
                            .bold(true)
                            .shadow(radius: 3)
                    }
                }
                Button(action: {
                    model.showLargeImage.toggle()
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
                        if !model.pulledCards.contains(where: { $0.id == model.cardToShow!.id }){
                            model.showLargeImage.toggle()
                            model.balance += model.cardToShow!.value
                            model.dexValue -= model.cardToShow!.value
                            model.dexValue = negZeroCheck(num: model.dexValue)
                            modelContext.delete(model.cardToShow!)
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
                    // 🔥 Trade Selected Card Button
                    Button(action: {
                        Task {
                            if let DBcard = model.cardToShow {
                                do {
                                    let response = try await CardService.postCardForTrade(DBcard)
                                    model.tradeQRCodeURL = response.qrCode
                                    let response2 = try await TradeService.createTrade(userA: model.IGN, cardA: DBcard.toCard())
                                    print(response2)
                                    model.showTradeQR = true
                                    model.isPolling = true
                                    action()
                                }
                                    catch {
                                    print("Trade failed: \(error)")
                                }
                            }
                        }
                    }) {
                        Text("Trade Selected")
                            .font(.headline).bold(true)
                            .foregroundColor(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(25)
                            .shadow(radius: 3)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading,30)
                .padding(.top,690)
            }
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

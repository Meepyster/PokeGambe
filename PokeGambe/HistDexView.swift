//
//  HistDexView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/3/25.
//
import SwiftUI
import SwiftData

struct HistDexView: View {
    @Environment(GameStateModel.self) private var model
    @Query var savedHistCards: [HistCard]
    var body: some View {
        ZStack{
            BackgroundView()
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
                                model.showLargeHistImage.toggle()
                                model.histCardToShow = card
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
                    model.showDex.toggle()
                    model.showHistDex.toggle()
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
            if model.showLargeHistImage {
                ZStack{
                    BackgroundView()
                        .opacity(0.70)
                    VStack{
                        Text(model.histCardToShow!.cardTitle)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(colorForRarity(model.histCardToShow!.rarity))
                            .shadow(color: .black ,radius: 1)
                            .bold()
                            .multilineTextAlignment(.center)
                        AsyncImage(url: URL(string: model.histCardToShow!.cardImage)) { phase in
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
                        Text("$\(String(format: "%.2f", model.histCardToShow!.value))")
                            .font(.system(size: 23))
                            .foregroundColor(.white)
                            .bold(true)
                            .shadow(radius: 3)
                    }
                }
                Button(action: {
                    model.showLargeHistImage.toggle()
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
}

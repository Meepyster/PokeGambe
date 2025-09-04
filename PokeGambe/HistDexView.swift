//
//  HistDexView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/3/25.
//
import SwiftUI
import SwiftData

struct HistDexView: View {
    @Query var savedHistCards: [HistCard]
    @Binding var showLargeHistImage: Bool
    @Binding var histCardToShow: HistCard?
    @Binding var showHistDex: Bool
    @Binding var showDex: Bool
    var body: some View {
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
                            .foregroundStyle(colorForRarity(histCardToShow!.rarity))
                            .shadow(color: .black ,radius: 1)
                            .bold()
                            .multilineTextAlignment(.center)
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
                        Text("$\(String(format: "%.2f", histCardToShow!.value))")
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
}

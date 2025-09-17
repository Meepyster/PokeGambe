//
//  PokeGambeApp.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/19/25.
//

import SwiftUI
import SwiftData

@main
struct PokeGambeApp: App {
    // Just store it normally here
    var gameState = GameStateModel()

    var body: some Scene {
        WindowGroup {
            ContentView(gameState: gameState) // inject into ContentView
        }
        .modelContainer(for: [DBCard.self, HistCard.self])
    }
}

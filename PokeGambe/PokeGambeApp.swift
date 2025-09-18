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
//    // Just store it normally here
//    @StateObject var gameState = GameStateModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(GameStateModel())
            // inject into ContentView
        }
        .modelContainer(for: [DBCard.self, HistCard.self])
    }
}

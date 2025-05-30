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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [DBCard.self, HistCard.self])
    }
}

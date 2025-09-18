//
//  BackgroundView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/17/25.
//
import SwiftUI
import SwiftData

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(red: 0.3, green: 0.4, blue: 0.9), Color(red: 0.6, green: 0.8, blue: 1.0)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

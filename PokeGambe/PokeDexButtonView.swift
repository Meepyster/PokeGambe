//
//  PokeDexButton.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/18/25.
//

import SwiftUI
import SwiftData

public struct PokeDexButtonView: View {
    @Environment(GameStateModel.self) private var model
    public var body: some View {
        Button(action: {
            model.showDex.toggle()
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
    }
}

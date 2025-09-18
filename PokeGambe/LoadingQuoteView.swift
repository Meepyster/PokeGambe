//
//  LoadingQuoteView.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/18/25.
//

import SwiftUI
import SwiftData

public struct LoadingQuoteView: View {
    @Environment(GameStateModel.self) private var model
    public var body: some View {
        VStack{
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text(model.currentQuote)
                .foregroundColor(.white)
                .bold(true)
                .shadow(radius: 3)
        }
    }
}

//
//  FetchCards.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/19/25.
//

import Foundation
class CardService{
    static func fetchCards() async throws -> CardResponse{
        let url = URL(string:"https://poke-app-comp590-140-25sp-forian.apps.unc.edu/get-10-cards")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(CardResponse.self, from: data)
        print("✅ Successfully connected to API:")
        print(decoded)
        return decoded
    }
}

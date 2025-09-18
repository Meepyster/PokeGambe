//
//  FetchCards.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/19/25.
//
//
//import Foundation
//class CardService{
//    static func fetchCards() async throws -> CardResponse{
//        let url = URL(string:"https://8fee510cbb12.ngrok-free.app")!
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let decoder = JSONDecoder()
//        let decoded = try decoder.decode(CardResponse.self, from: data)
//        print("✅ Successfully connected to API:")
//        print(decoded)
//        return decoded
//    }
//}


import Foundation

class CardService {
    static func fetchCards() async throws -> CardResponse {
        let url = URL(string: "https://6be15b0e9aed.ngrok-free.app/test-10-cards")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("true", forHTTPHeaderField: "ngrok-skip-browser-warning")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Debug print — see raw response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📥 Received response: \(jsonString)")
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(CardResponse.self, from: data)
        print("✅ Successfully connected to API:")
        print(decoded)
        return decoded
    }
    static func postCardForTrade(_ card: DBCard) async throws -> TradeResponse {
        guard let url = URL(string: "https://6be15b0e9aed.ngrok-free.app/postCard") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Map DBCard to the API request struct
        let tradeRequest = Card(
            id: card.id,
            cardTitle: card.cardTitle,
            name: card.name,
            baseExperience: card.baseExperience,
            cardImage: card.cardImage,
            rarity: card.rarity,
            subtypes: card.subtypes,
            value: card.value,
            realMarketValue: card.realMarketValue,
            discrepancyRatio: card.discrepancyRatio
        )

        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(tradeRequest)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            print("HTTP \(httpResponse.statusCode): \(String(data: data, encoding: .utf8) ?? "")")
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(TradeResponse.self, from: data)
    }
    static func fetchTradedCard(_ cardID: String) async throws -> Card {
        let url = URL(string: "https://6be15b0e9aed.ngrok-free.app/trade-cards/\(cardID)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Card.self, from: data)
    }
}

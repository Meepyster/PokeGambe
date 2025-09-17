//
//  Card.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/19/25.
//
import Foundation

struct CardResponse: Codable {
    let cards: [Card]
    let totalValue: Double
    let realworldTotalValue: Double

    enum CodingKeys: String, CodingKey {
        case cards
        case totalValue = "total_value"
        case realworldTotalValue = "realworld_total_value"
    }
}

struct Card: Codable, Identifiable {
    let id: UUID
    let cardTitle: String
    let name: String
    let baseExperience: Int
    let cardImage: String
    let rarity: String
    let subtypes: [String]
    let value: Double
    let realMarketValue: Double
    let discrepancyRatio: Double

    enum CodingKeys: String, CodingKey {
        case id
        case cardTitle = "card_title"
        case name
        case baseExperience = "base_experience"
        case cardImage = "card_image"
        case rarity
        case subtypes
        case value
        case realMarketValue = "real_market_value"
        case discrepancyRatio = "discrepancy_ratio"
    }
}

struct TradeResponse: Codable {
    let qrCode: URL?

    enum CodingKeys: String, CodingKey {
        case qrCode = "qr_code"
    }
}

//struct CardTradeRequest: Codable {
//    let id: String
//    let card_title: String
//    let name: String
//    let base_experience: Int
//    let card_image: String
//    let rarity: String
//    let subtypes: [String]
//    let value: Double
//    let real_market_value: Double
//    let discrepancy_ratio: Double
//}

struct Trade: Codable, Identifiable {
    var id: UUID                        // Trade ID (same as Player A’s card id)
    var userA: String                     // Person starting trade
    var userB: String?                    // Player joining trade
    var cardA: Card                       // Card offered by Player A
    var cardB: Card?                      // Card offered by Player B (nil until offered)
    var status: String                    // "pending", "joined", "awaiting_confirmations", "completed"
    var confirmations: [String: Bool]     // { "userA": true, "userB": false }

    enum CodingKeys: String, CodingKey {
        case id
        case userA
        case userB
        case cardA
        case cardB
        case status
        case confirmations
    }
}

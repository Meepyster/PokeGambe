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
    let id = UUID()
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
        case cardTitle = "card_title"
        case name
        case baseExperience = "base_experience"
        case cardImage = "card_image"
        case rarity
        case subtypes
        case value
        case realMarketValue = "real-market-value"
        case discrepancyRatio = "discrepancy-ratio"
    }
}



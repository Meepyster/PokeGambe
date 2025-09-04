//
//  PokeDexDB.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 4/20/25.
//
import Foundation
import SwiftData

@Model
class DBCard{
    var id: UUID
    var cardTitle: String
    var name: String
    var baseExperience: Int
    var cardImage: String
    var rarity: String
    var value: Double
    var realMarketValue: Double
    var discrepancyRatio: Double
    var subtypes: [String]

    init(
        id: UUID,
        cardTitle: String,
        name: String,
        baseExperience: Int,
        cardImage: String,
        rarity: String,
        value: Double,
        realMarketValue: Double,
        discrepancyRatio: Double,
        subtypes: [String]
    ) {
        self.id = id
        self.cardTitle = cardTitle
        self.name = name
        self.baseExperience = baseExperience
        self.cardImage = cardImage
        self.rarity = rarity
        self.value = value
        self.realMarketValue = realMarketValue
        self.discrepancyRatio = discrepancyRatio
        self.subtypes = subtypes
    }
}

@Model
class HistCard: Identifiable{
    var id: UUID
    var cardTitle: String
    var name: String
    var baseExperience: Int
    var cardImage: String
    var rarity: String
    var value: Double
    var realMarketValue: Double
    var discrepancyRatio: Double
    var subtypes: [String]

    init(
        id: UUID,
        cardTitle: String,
        name: String,
        baseExperience: Int,
        cardImage: String,
        rarity: String,
        value: Double,
        realMarketValue: Double,
        discrepancyRatio: Double,
        subtypes: [String]
    ) {
        self.id = id
        self.cardTitle = cardTitle
        self.name = name
        self.baseExperience = baseExperience
        self.cardImage = cardImage
        self.rarity = rarity
        self.value = value
        self.realMarketValue = realMarketValue
        self.discrepancyRatio = discrepancyRatio
        self.subtypes = subtypes
    }
}



//
//  HelperFunctions.swift
//  PokeGambe
//
//  Created by Ian Forlemu on 9/3/25.
//

extension DBCard {
    /// Create a DBCard from a normal Card
    convenience init(from card: Card) {
        self.init(
            id: card.id,  // same UUID
            cardTitle: card.cardTitle,
            name: card.name,
            baseExperience: card.baseExperience,
            cardImage: card.cardImage,
            rarity: card.rarity,
            value: card.value,
            realMarketValue: card.realMarketValue,
            discrepancyRatio: card.discrepancyRatio,
            subtypes: card.subtypes
        )
    }
    
    /// Convert a DBCard back to a normal Card
    func toCard() -> Card {
        Card(
            id: self.id,
            cardTitle: self.cardTitle,
            name: self.name,
            baseExperience: self.baseExperience,
            cardImage: self.cardImage,
            rarity: self.rarity,
            subtypes: self.subtypes,
            value: self.value,
            realMarketValue: self.realMarketValue,
            discrepancyRatio: self.discrepancyRatio
            
        )
    }
}

extension Card {
    /// Convert a Card to a DBCard
    func toDBCard() -> DBCard {
        DBCard(from: self)
    }
}

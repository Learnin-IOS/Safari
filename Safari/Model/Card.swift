//
//  Card.swift
//  Safari
//
//  Created by Le Bon B' Bauma on 05/12/2022.
//

import SwiftUI


// MARK: - Card Model With Smaple Cards


struct Card: Identifiable{
    var id: UUID = .init()
    var cardImage: String
}


var sampleCard: [Card] = [
    .init(cardImage: "card1"),
    .init(cardImage: "card2"),
    .init(cardImage: "card3"),
    .init(cardImage: "card4"),
    .init(cardImage: "card5"),
    .init(cardImage: "card6"),
    .init(cardImage: "card7"),
    .init(cardImage: "card8"),
    .init(cardImage: "card9"),
    .init(cardImage: "card10"),

]
    


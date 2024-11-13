//
//  Card.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/9/24.
//

import Foundation
import SwiftUI

struct Card: Codable, Hashable {
    var value: CardValue
    var suit: CardSuit
    var description: String { self.value.rawValue + " of " + self.suit.rawValue }
    
    var color: Color { return suit.color }
    
    var text: String {
        switch self.value {
        case .ace:
            "A"
        case .two:
            "2"
        case .three:
            "3"
        case .four:
            "4"
        case .five:
            "5"
        case .six:
            "6"
        case .seven:
            "7"
        case .eight:
            "8"
        case .nine:
            "9"
        case .ten:
            "10"
        case .jack:
            "J"
        case .queen:
            "Q"
        case .king:
            "K"
        }
    }
    
    var imageSystemName: String {
        switch self.suit {
        case .diamonds:
            "suit.diamond.fill"
        case .hearts:
            "suit.heart.fill"
        case .spades:
            "suit.spade.fill"
        case .clubs:
            "suit.club.fill"
        }
    }
}

extension Card {
    static var sortedDeck: [Card] {
        var returnDeck: [Card] = []
        
        for suit in CardSuit.allCases {
            for value in CardValue.allCases {
                returnDeck.append(Card(value: value, suit: suit))
            }
        }
        
        return returnDeck
    }
    
    static var shuffledDeck: [Card] { Card.sortedDeck.shuffled() }
}

//
//  Card.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/9/24.
//

import Foundation
import SwiftUI

enum CardSuit: String, Codable, CaseIterable, Identifiable {
    case diamonds, hearts, spades, clubs
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .diamonds, .hearts:
            Color.red
        case .spades, .clubs:
            Color.black
        }
    }
    
    var imageString: String {
        switch self {
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

enum CardValue: String, Codable, CaseIterable, Identifiable {
    case ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
    
    var id: String { self.rawValue }
    
    var int: Int {
        switch self {
        case .ace:
            14
        case .two:
            2
        case .three:
            3
        case .four:
            4
        case .five:
            5
        case .six:
            6
        case .seven:
            7
        case .eight:
            8
        case .nine:
            9
        case .ten:
            10
        case .jack:
            11
        case .queen:
            12
        case .king:
            13
        }
    }
}

struct Card: Codable, Hashable {
    var value: CardValue
    var suit: CardSuit
    
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

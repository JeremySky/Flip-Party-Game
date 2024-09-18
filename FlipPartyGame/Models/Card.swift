//
//  Card.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/9/24.
//

import Foundation
import SwiftUI

enum SuitColor: Codable {
    case red, black
}

enum CardSuit: String, Codable, CaseIterable, Identifiable {
    case diamonds, hearts, spades, clubs
    
    var id: String { self.rawValue }
    
    var color: SuitColor {
        switch self {
        case .diamonds, .hearts:
                .red
        case .spades, .clubs:
                .black
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

struct Card: Codable {
    var value: CardValue
    var suit: CardSuit
    var color: SuitColor { return suit.color}
    
    func getText() -> String {
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
    
    func getSuit() -> String {
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
    
    func getColor() -> Color {
        switch self.color {
        case .red:
            return Color.red
        case .black:
            return Color.black
        }
    }
}

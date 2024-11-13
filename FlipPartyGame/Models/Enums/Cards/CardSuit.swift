//
//  CardSuit.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/30/24.
//

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

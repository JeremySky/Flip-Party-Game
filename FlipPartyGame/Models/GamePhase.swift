//
//  GamePhase.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import SwiftUI

enum GamePhase {
    case one, two, three, four
    
    var index: Int {
        switch self {
        case .one:
            0
        case .two:
            1
        case .three:
            2
        case .four:
            3
        }
    }
    
    var selections: [Selections] {
        switch self {
        case .one:
            [.red, .black]
        case .two:
            [.higher, .lower, .equal]
        case .three:
            [.inside, .outside, .equal]
        case .four:
            [.heart, .spade, .diamond, .club]
        }
    }
    
    enum Selections: String {
        case black, red, higher, lower, equal, inside, outside, heart, spade, diamond, club
        
        var isHeavy: Bool {
            switch self {
            case .equal, .inside, .outside:
                return true
            default:
                return false
            }
        }
        
        var color: Color {
            switch self {
            case .red, .heart, .diamond:
                    .red
            default:
                    .black
            }
        }
        
        var imageString: String? {
            switch self {
            case .higher:
                "arrowshape.up.fill"
            case .lower:
                "arrowshape.down.fill"
            case .equal:
                "equal"
            case .inside:
                "arrow.down.right.and.arrow.up.left"
            case .outside:
                "arrow.up.left.and.arrow.down.right"
            case .heart:
                "suit.heart.fill"
            case .spade:
                "suit.spade.fill"
            case .diamond:
                "suit.diamond.fill"
            case .club:
                "suit.club.fill"
            default:
                nil
            }
        }
    }
}

//
//  Selection.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/18/24.
//

import SwiftUI

enum ChoiceSelection: String {
    case black, red, higher, lower, equal, inside, outside, heart, spade, diamond, club
    
    
    static let padding: CGFloat = 18
    static let frame: CGFloat = 70
    
    static let sticker1Offset: CGSize = CGSize(width: ChoiceSelection.red.offset, height: 240)
    static let sticker2Offset: CGSize = CGSize(width: ChoiceSelection.black.offset, height: 240)
    
    var offset: CGFloat {
        var cgFloat: CGFloat = 0
        
        switch self {
        case .black, .spade:
            cgFloat = CGFloat((ChoiceSelection.frame + ChoiceSelection.padding) / 2)
        case .red, .diamond:
            cgFloat = CGFloat(-(ChoiceSelection.frame + ChoiceSelection.padding) / 2)
        case .higher, .inside:
            cgFloat = CGFloat(ChoiceSelection.frame + ChoiceSelection.padding)
        case .lower, .outside:
            cgFloat = CGFloat(0)
        case .equal:
            cgFloat = CGFloat(-(ChoiceSelection.frame + ChoiceSelection.padding))
        case.heart:
            cgFloat = CGFloat(((ChoiceSelection.frame + ChoiceSelection.padding) / 2) + ChoiceSelection.frame + ChoiceSelection.padding)
        case .club:
            cgFloat = CGFloat(-((((ChoiceSelection.frame + ChoiceSelection.padding) / 2) + ChoiceSelection.frame + ChoiceSelection.padding)))
        }
        
        return cgFloat
    }
    
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

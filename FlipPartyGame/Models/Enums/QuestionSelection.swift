//
//  Selection.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/18/24.
//

import SwiftUI

enum QuestionSelection: String {
    case black, red, higher, lower, equal, inside, outside, heart, spade, diamond, club
    
    
    static let padding: CGFloat = 18
    static let frame: CGFloat = 70
    
    static let sticker1Offset: CGSize = CGSize(width: QuestionSelection.red.offset, height: 240)
    static let sticker2Offset: CGSize = CGSize(width: QuestionSelection.black.offset, height: 240)
    
    var offset: CGFloat {
        var cgFloat: CGFloat = 0
        
        switch self {
        case .black, .spade:
            cgFloat = CGFloat((QuestionSelection.frame + QuestionSelection.padding) / 2)
        case .red, .diamond:
            cgFloat = CGFloat(-(QuestionSelection.frame + QuestionSelection.padding) / 2)
        case .higher, .inside:
            cgFloat = CGFloat(QuestionSelection.frame + QuestionSelection.padding)
        case .lower, .outside:
            cgFloat = CGFloat(0)
        case .equal:
            cgFloat = CGFloat(-(QuestionSelection.frame + QuestionSelection.padding))
        case.heart:
            cgFloat = CGFloat(((QuestionSelection.frame + QuestionSelection.padding) / 2) + QuestionSelection.frame + QuestionSelection.padding)
        case .club:
            cgFloat = CGFloat(-((((QuestionSelection.frame + QuestionSelection.padding) / 2) + QuestionSelection.frame + QuestionSelection.padding)))
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

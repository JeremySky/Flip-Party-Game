//
//  Question.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import SwiftUI

enum Question: CaseIterable {
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
    
    var selections: [QuestionSelection] {
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
}

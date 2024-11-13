//
//  CardValue.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/30/24.
//

import Foundation

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

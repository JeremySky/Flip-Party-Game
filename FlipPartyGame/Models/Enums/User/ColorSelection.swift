//
//  ColorSelection.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/30/24.
//

import SwiftUI

enum ColorSelection: CaseIterable {
    case red, pink, orange, yellow, green, mint, teal, cyan, blue, purple, indigo, brown, black
    
    var value: Color {
        switch self {
        case .red:
            Color.red
        case .pink:
            Color.pink
        case .orange:
            Color.orange
        case .yellow:
            Color.yellow
        case .green:
            Color.green
        case .mint:
            Color.mint
        case .teal:
            Color.teal
        case .cyan:
            Color.cyan
        case .blue:
            Color.blue
        case .purple:
            Color.purple
        case .indigo:
            Color.indigo
        case .brown:
            Color.brown
        case .black:
            Color.black
        }
    }
    
    static var collection: [ItemType] {
        
            var arr: [ItemType] = []
            
            for color in ColorSelection.allCases {
                arr.append(.color(color.value))
            }
            
            return arr
    }
}

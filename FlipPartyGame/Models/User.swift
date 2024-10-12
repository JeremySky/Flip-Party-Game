//
//  User.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/18/24.
//

import Foundation
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

enum IconSelection: CaseIterable {
    case beerBlue, beerRed, beerPurple, beerCan, beerPong, cocktailPink, cocktailGreen, strong, iceBucket, barrel
    
    var string: String {
        switch self {
        case .beerBlue:
            "beer-blue"
        case .beerRed:
            "beer-red"
        case .beerPurple:
            "beer-purple"
        case .beerCan:
            "beer-can"
        case .beerPong:
            "beer-pong"
        case .cocktailPink:
            "cocktail-pink"
        case .cocktailGreen:
            "cocktail-green"
        case .strong:
            "strong"
        case .iceBucket:
            "ice-bucket"
        case .barrel:
            "barrel"
        }
    }
    
    static var collection: [ItemType] {
        
            var arr: [ItemType] = []
            
            for image in IconSelection.allCases {
                arr.append(.image(image.string))
            }
            
            return arr
    }
}


struct User: Identifiable, Hashable {
    let id: UUID
    var name: String
    var icon: IconSelection
    var color: ColorSelection
    
    init(id: UUID = UUID(), name: String, icon: IconSelection, color: ColorSelection) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
    }
    
    static var test1 = User(name: "Jeremy", icon: .cocktailGreen, color: .green)
    static var test2 = User(name: "Sam", icon: .barrel, color: .blue)
    static var test3 = User(name: "Trevor", icon: .cocktailPink, color: .black)
    static var test4 = User(name: "Balto", icon: .beerCan, color: .red)
    
    static var testDic: [Int:User?] = [
        1:.test1,
        2:.test2,
        3:.test3,
        4:.test4
    ]
    
    static var testArr: [User] = [.test1, .test2, .test3, .test4]
}

//
//  IconSelection.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/30/24.
//

import Foundation

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

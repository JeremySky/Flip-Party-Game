//
//  Sticker.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/30/24.
//

import Foundation

enum Sticker: String, RawRepresentable, CaseIterable {
    case give, take
    
    var offset: CGSize {
        switch self {
        case .give:
            return CGSize(width: -42, height: 0)
        case .take:
            return CGSize(width: 42, height: 0)
        }
    }
}

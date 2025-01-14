//
//  Phase.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/30/24.
//

import Foundation


enum GamePhase: Equatable {
    case waiting, question(_ question: Question), giveTake(_ remainingSticker: [Sticker]), results
    
    var question: Question? {
        switch self {
        case .question(let question):
            return question
        default:
            return nil
        }
    }
    
    var remainingStickers: [Sticker]? {
        switch self {
        case .giveTake(let remainingSticker):
            return remainingSticker
        default:
            return nil
        }
    }
}

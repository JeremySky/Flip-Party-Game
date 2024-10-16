//
//  GuessingViewModel.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import SwiftUI

class GuessingViewModel: ObservableObject {
    @Published var gameManager: GameManager
    @Published var isFlipped = false
    @Published var selection: GamePhase.Selections?
    @Published var isCorrect: Bool?
    let phase: GamePhase
    
    init(gameManager: GameManager, isFlipped: Bool = false, selection: GamePhase.Selections? = nil, isCorrect: Bool? = nil) {
        self.gameManager = gameManager
        self.isFlipped = isFlipped
        self.selection = selection
        self.isCorrect = isCorrect
        self.phase = gameManager.phase
    }
    
    func getHandCount() -> Int { gameManager.hand.count }
    
    func getCurrentCard() -> Card { gameManager.hand[gameManager.phase.index] }
    
    func getCurrentPlayer() -> User { gameManager.currentPlayer }
    
    func flipCard() {
        isCorrect = getResult()
        
        isFlipped = true
        // check answer
        // send data
    }
    
    
    func getResult() -> Bool {
        let hand = gameManager.hand
        
        switch selection {
        case .black:
            return hand[0].color == .black
        case .red:
            return hand[0].color == .red
        case .higher:
            return hand[1].value.int > hand[0].value.int
        case .lower:
            return hand[1].value.int < hand[0].value.int
        case .equal:
            
            if gameManager.phase == .two {
                return hand[1].value.int == hand[0].value.int
            } else {
                return hand[2].value.int == hand[1].value.int || hand[2].value.int == hand[0].value.int
            }
            
        case .inside:
            return hand[2].value.int > [hand[0].value.int, hand[1].value.int].min()! && hand[2].value.int > [hand[0].value.int, hand[1].value.int].max()!
        case .outside:
            return hand[2].value.int < [hand[0].value.int, hand[1].value.int].min()! && hand[2].value.int > [hand[0].value.int, hand[1].value.int].max()!
        case .heart:
            return hand[3].suit == .hearts
        case .spade:
            return hand[3].suit == .spades
        case .diamond:
            return hand[3].suit == .diamonds
        case .club:
            return hand[3].suit == .clubs
        default:
            print("GuessingViewModel.getResult() -- ERROR switch resulted in default...")
            return false
        }
    }
}

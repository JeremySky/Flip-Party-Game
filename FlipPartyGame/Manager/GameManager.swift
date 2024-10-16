//
//  GameManager.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var phase: GamePhase
    @Published var currentPlayer: User = User.test1
    @Published var deck: [Card]
    @Published var deckIndex: Int
    @Published var hand: [Card]
    
    init(phase: GamePhase, currentPlayer: User, deck: [Card], deckIndex: Int, hand: [Card]) {
        self.phase = phase
        self.currentPlayer = currentPlayer
        self.deck = deck
        self.deckIndex = deckIndex
        self.hand = hand
    }
}

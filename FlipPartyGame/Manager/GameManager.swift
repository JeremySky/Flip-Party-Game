//
//  GameManager.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var players: [User]
    @Published var currentPlayer: User
    @Published var deck: [Card]
    @Published var currentCardIndex: Int
    @Published var hands: [UUID:[Card]]
    @Published var question: Question?
    
    //question phase data...
    @Published var selected: Selection?
    @Published var result: Bool?
    
    init(players: [User], currentPlayer: User, deck: [Card], currentCardIndex: Int, hands: [UUID : [Card]], question: Question?, selected: Selection? = nil, result: Bool? = nil) {
        self.players = players
        self.currentPlayer = currentPlayer
        self.deck = deck
        self.currentCardIndex = currentCardIndex
        self.hands = hands
        self.question = question
        self.selected = selected
        self.result = result
    }
    
    func getCurrentCard() -> Card { deck[currentCardIndex] }
    
    func updateStandbyView(selected: Selection, result: Bool) {
        self.selected = selected
        self.result = result
    }
}

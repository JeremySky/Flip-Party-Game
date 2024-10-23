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


extension GameManager {
    
    static var preview: GameManager {
        
        
        let currentCardIndex = 12
        
        
        let players = User.testArr
        let deck = Card.shuffledDeck
        
        let currentPlayer = players[currentCardIndex % players.count]
        
        var question: Question? {
            for question in Question.allCases {
                let questionIndex = (currentCardIndex / players.count)
                if question.index == questionIndex { return question }
            }
            
            return nil
        }
        
        var hands: [UUID:[Card]] {
            var data: [UUID:[Card]] = Dictionary(uniqueKeysWithValues: players.map { ($0.id, []) })
            var cardIndex = 0
            var playerIndex = 0
            
            while cardIndex <= currentCardIndex {
                
                let id = players[playerIndex].id
                
                if data[id] != nil {
                    data[id]!.append(deck[cardIndex])
                }
                
                playerIndex = (playerIndex + 1) % players.count
                cardIndex += 1
            }
            
            return data
        }
        
        let gameManager = GameManager(players: players, currentPlayer: currentPlayer, deck: deck, currentCardIndex: currentCardIndex, hands: hands, question: question!)
        
        return gameManager
    }
}

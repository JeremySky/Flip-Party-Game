//
//  GameManager.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import Foundation

class GameManager: ObservableObject {
    
    let host: User
    
    @Published var players: [User]
    @Published var currentPlayer: User
    @Published var deck: [Card]
    @Published var currentCardIndex: Int
    @Published var hands: [UUID:[Card]]
    @Published var phase: GamePhase
    
    //question phase data...
    @Published var questionSelection: QuestionSelection?
    @Published var result: Bool?
    
    //give-take phase data...
    @Published var giveTakeSelection: (choice1: Sticker?, choice2: Sticker?)
    
    init(host: User, players: [User], currentPlayer: User, deck: [Card], currentCardIndex: Int, hands: [UUID : [Card]], selected: QuestionSelection? = nil, result: Bool? = nil, phase: GamePhase) {
        self.host = host
        self.players = players
        self.currentPlayer = currentPlayer
        self.deck = deck
        self.currentCardIndex = currentCardIndex
        self.hands = hands
        self.questionSelection = selected
        self.result = result
        self.phase = phase
    }
    
    init(host: User) {
        self.host = host
        self.players = [host]
        self.currentPlayer = User()
        self.deck = []
        self.currentCardIndex = 0
        self.hands = [:]
        self.questionSelection = nil
        self.result = nil
        self.phase = .question(.one)
    }
    
    func getCurrentCard() -> Card { deck[currentCardIndex] }
    
    func updateStandbyView(selected: QuestionSelection, result: Bool) {
        self.questionSelection = selected
        self.result = result
    }
}
















extension GameManager {
    
    static func preview(cardIndex: Int) -> GameManager {
        
        let currentCardIndex = cardIndex
        let players = User.testArr
        let deck = Card.shuffledDeck
        var currentPlayer: User {
            let playerCount = players.count
            let firstPhaseTurns = 4 * playerCount
            
            if currentCardIndex < firstPhaseTurns {
                // Phase 1: Each player gets 1 card per turn
                return players[currentCardIndex % playerCount]
            } else {
                // Phase 2: Each player gets 2 cards per turn
                // Calculate the adjusted index by subtracting the first phase turns
                let phaseTwoTurn = currentCardIndex - firstPhaseTurns
                return players[(phaseTwoTurn / 2) % playerCount]
            }
        }
        
        
        var phase: GamePhase {
            if currentCardIndex < 4 * players.count {
                let questionIndex = currentCardIndex % 4
                let question: Question = Question.allCases.first(where: { $0.index == questionIndex })!
                return .question(question)
            } else {
                let remainingStickers: [Sticker] = (currentCardIndex % 2) == 0 ? Sticker.allCases : [Sticker.allCases.randomElement()!]
                return .giveTake(remainingStickers)
            }
        }
        
        var hands: [UUID:[Card]] {
            var data: [UUID:[Card]] = Dictionary(uniqueKeysWithValues: players.map { ($0.id, []) })
            var cardIndex = 0
            var playerIndex = 0
            
            while cardIndex <= currentCardIndex {
                
                let id = players[playerIndex].id
                
                if let hand = data[id], hand.count < 4 {
                    data[id]!.append(deck[cardIndex])
                }
                
                playerIndex = (playerIndex + 1) % players.count
                cardIndex += 1
            }
            
            return data
        }
        
        return GameManager(host: players[0], players: players, currentPlayer: currentPlayer, deck: deck, currentCardIndex: currentCardIndex, hands: hands, phase: phase)
    }
    
    
    
    
    
    
    
    
    static var preview: GameManager {
        
        let currentCardIndex = 0
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
        
        let gameManager = GameManager(host: players[0], players: players, currentPlayer: currentPlayer, deck: deck, currentCardIndex: currentCardIndex, hands: hands, phase: .question(.one))
        
        return gameManager
    }
}

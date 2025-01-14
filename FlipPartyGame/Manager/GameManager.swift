//
//  GameManager.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import Foundation

class GameManager: ObservableObject {
    
    let host: User
    @Published var userList: [User]
    @Published var players: [UUID:Player]
    @Published var turnTaken: Bool
    @Published var currentPlayer: Player
    @Published var actionList: Set<Player>
    
    var deck: [Card]
    @Published var currentCardIndex: Int
    @Published var hands: [UUID:[Card]]
    @Published var phase: GamePhase
    
    //question phase data...
    @Published var selectedGuess: ChoiceSelection?
    @Published var result: Bool?
    
    //give-take phase data...
    @Published var giveTakeSelection: (choice1: Sticker?, choice2: Sticker?)
    
    init(host: User, userList: [User], players: [UUID:Player], turnTaken: Bool, currentPlayer: Player, actionList: Set<Player>, deck: [Card], currentCardIndex: Int, hands: [UUID : [Card]], selectedGuess: ChoiceSelection? = nil, result: Bool? = nil, phase: GamePhase) {
        self.host = host
        self.userList = userList
        self.players = players
        self.turnTaken = turnTaken
        self.currentPlayer = currentPlayer
        self.actionList = actionList
        self.deck = deck
        self.currentCardIndex = currentCardIndex
        self.hands = hands
        self.selectedGuess = selectedGuess
        self.result = result
        self.phase = phase
    }
    
    init(host: User) {
        self.host = host
        self.userList = [host]
        self.players = [host.id:Player(user: host)]
        self.turnTaken = false
        self.currentPlayer = Player(user: host)
        self.actionList = Set<Player>()
        self.deck = []
        self.currentCardIndex = 0
        self.hands = [:]
        self.selectedGuess = nil
        self.result = nil
        self.phase = .question(.one)
    }
    
    func getCurrentCard() -> Card { deck[currentCardIndex] }
    
    func updateStandbyView(selected: ChoiceSelection, result: Bool) {
        self.selectedGuess = selected
        self.result = result
    }
    
    func checkPlayerPoints(for user: User) -> Bool {
        if players[user.id]?.points != 0 {
            return true
        }
        return false
    }
    
    func checkPlayerPenalties(for user: User) -> Bool {
        if players[user.id]?.penalties != 0 {
            return true
        }
        return false
    }
}
















extension GameManager {
    
    static func preview(cardIndex: Int) -> GameManager {
        
        let currentCardIndex = cardIndex
        let userList: [User] = User.testArr
        let players: [UUID:Player] = Dictionary(uniqueKeysWithValues: userList.map{ ($0.id, Player(user: $0)) })
        
        
        var currentPlayer: Player {
            
            let playerCount = userList.count
            let firstPhaseTurns = 4 * playerCount
            
            if currentCardIndex < firstPhaseTurns {
                // Phase 1: Each player gets 1 card per turn
                
                return Player(user: userList[currentCardIndex % playerCount])
            } else {
                // Phase 2: Each player gets 2 cards per turn
                // Calculate the adjusted index by subtracting the first phase turns
                let phaseTwoTurn = currentCardIndex - firstPhaseTurns
                return Player(user: userList[(phaseTwoTurn / 2) % playerCount])
            }
        }
        
        let deck = Card.shuffledDeck
        
        
        
        
        var phase: GamePhase {
            if currentCardIndex < 4 * userList.count {
                let questionIndex = currentCardIndex % 4
                let question: Question = Question.allCases.first(where: { $0.index == questionIndex })!
                return .question(question)
            } else {
                let remainingStickers: [Sticker] = (currentCardIndex % 2) == 0 ? Sticker.allCases : [Sticker.allCases.randomElement()!]
                return .giveTake(remainingStickers)
            }
        }
        
        var hands: [UUID:[Card]] {
            var data: [UUID:[Card]] = Dictionary(uniqueKeysWithValues: userList.map { ($0.id, []) })
            var cardIndex = 0
            var playerIndex = 0
            
            while cardIndex <= currentCardIndex {
                
                let id = userList[playerIndex].id
                
                if let hand = data[id], hand.count < 4 {
                    data[id]!.append(deck[cardIndex])
                }
                
                playerIndex = (playerIndex + 1) % userList.count
                cardIndex += 1
            }
            
            return data
        }
        
        return GameManager(host: userList[0], userList: userList, players: players, turnTaken: false, currentPlayer: currentPlayer, actionList: Set<Player>(), deck: deck, currentCardIndex: currentCardIndex, hands: hands, phase: phase)
    }
    
    
    
    
    
    
    
    
    static var preview: GameManager {
        
        let currentCardIndex = 0
        let userList = User.testArr
        let players: [UUID:Player] = Dictionary(uniqueKeysWithValues: userList.map{ ($0.id, Player(user: $0)) })
        let deck = Card.shuffledDeck
        
        var question: Question? {
            for question in Question.allCases {
                let questionIndex = (currentCardIndex / userList.count)
                if question.index == questionIndex { return question }
            }
            
            return nil
        }
        
        var hands: [UUID:[Card]] {
            var data: [UUID:[Card]] = Dictionary(uniqueKeysWithValues: userList.map { ($0.id, []) })
            var cardIndex = 0
            var playerIndex = 0
            
            while cardIndex <= currentCardIndex {
                
                let id = userList[playerIndex].id
                
                if data[id] != nil {
                    data[id]!.append(deck[cardIndex])
                }
                
                playerIndex = (playerIndex + 1) % userList.count
                cardIndex += 1
            }
            
            return data
        }
        
        let gameManager = GameManager(host: userList[0], userList: userList, players: players, turnTaken: false, currentPlayer: Player(user: userList[0]), actionList: Set<Player>(), deck: deck, currentCardIndex: currentCardIndex, hands: hands, phase: .question(.one))
        
        return gameManager
    }
}

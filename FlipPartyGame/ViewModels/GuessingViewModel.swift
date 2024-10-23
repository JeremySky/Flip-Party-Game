//
//  GuessingViewModel.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import SwiftUI

class GuessingViewModel: ObservableObject {
    @Published var isFlipped = false
    @Published var selection: Selection?
    @Published var isCorrect: Bool?
    
    let hand: [Card]
    let question: Question
    let currentCard: Card
    let currentPlayer: User
    
    init(isFlipped: Bool = false, selection: Selection? = nil, isCorrect: Bool? = nil, hand: [Card], question: Question, currentCard: Card, currentPlayer: User) {
        self.isFlipped = isFlipped
        self.selection = selection
        self.isCorrect = isCorrect
        self.hand = hand
        self.question = question
        self.currentCard = currentCard
        self.currentPlayer = currentPlayer
    }
    
    init(gameManager: GameManager, user: User) {
        guard let hand = gameManager.hands[user.id] else {
            fatalError("Hand for user \(user.id) should not be nil")
        }
        guard let question = gameManager.question else {
            fatalError("Question should not be nil")
        }
        self.isFlipped = false
        self.selection = nil
        self.isCorrect = nil
        self.hand = hand
        self.question = question
        self.currentCard = gameManager.getCurrentCard()
        self.currentPlayer = gameManager.currentPlayer
    }
    
    
    func flipCard() {
        isCorrect = getResult()
        
        isFlipped = true
        // check answer
        // send data
    }
    
    
    func getResult() -> Bool {
        
        switch selection {
            
        //QUESTION 1...
        case .black:
            return hand[0].color == .black
        case .red:
            return hand[0].color == .red
            
        //QUESTION 2...
        case .higher:
            return hand[1].value.int > hand[0].value.int
        case .lower:
            return hand[1].value.int < hand[0].value.int
            
        case .equal:
            
            if question == .two {
                return hand[1].value.int == hand[0].value.int
            } else {
                return hand[2].value.int == hand[1].value.int || hand[2].value.int == hand[0].value.int
            }
            
        //QUESTION 3...
        case .inside:
            return hand[2].value.int > [hand[0].value.int, hand[1].value.int].min()! && hand[2].value.int < [hand[0].value.int, hand[1].value.int].max()!
        case .outside:
            return hand[2].value.int < [hand[0].value.int, hand[1].value.int].min()! || hand[2].value.int > [hand[0].value.int, hand[1].value.int].max()!
            
            
        //QUESTION 4...
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

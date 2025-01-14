//
//  GuessingViewModel.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import SwiftUI

@MainActor
class GuessingViewModel: ObservableObject {
    @Published var isFlipped: Bool
    @Published var selectedAnswer: ChoiceSelection?
    @Published var isCorrect: Bool?
    
    let hand: [Card]
    let question: Question
    let currentCard: Card
    
    init(isFlipped: Bool = false, selectedAnswer: ChoiceSelection? = nil, isCorrect: Bool? = nil, hand: [Card], question: Question, currentCard: Card, currentPlayer: User) {
        self.isFlipped = isFlipped
        self.selectedAnswer = selectedAnswer
        self.isCorrect = isCorrect
        self.hand = hand
        self.question = question
        self.currentCard = currentCard
    }
    
    init(gameManager: GameManager) {
        let user = gameManager.currentPlayer
        guard let hand = gameManager.hands[user.id] else { fatalError("Hand for user \(user.id) should not be nil") }
        guard let question = gameManager.phase.question else { fatalError("Question should not be nil") }
            
        self.isFlipped = false
        self.selectedAnswer = nil
        self.isCorrect = nil
        self.hand = hand
        self.question = question
        self.currentCard = gameManager.getCurrentCard()
    }
    
    
    func flipCard() {
        isCorrect = getResult()
        
        isFlipped = true
        // check answer
        // send data
    }
    
    
    func getResult() -> Bool {
        
        switch selectedAnswer {
            
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

//
//  GiveTakeSelectionViewModel.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 11/7/24.
//

import Foundation

@MainActor
class GiveTakeSelectionViewModel: ObservableObject {
    
    @Published var selectedSticker: Sticker?
    
    let remainingStickers: [Sticker]
    let card: Card
    let hand: [Card]
    
    
    
    init(selectedSticker: Sticker? = nil, remainingStickers: [Sticker], card: Card, hand: [Card]) {
        self.selectedSticker = selectedSticker
        self.remainingStickers = remainingStickers
        self.card = card
        self.hand = hand
    }
    
    init(gameManager: GameManager, remainingStickers: [Sticker], user: User) {
        guard let hand = gameManager.hands[user.id] else { fatalError("Hand for user \(user.id) should not be nil") }
        
        self.selectedSticker = nil
        self.remainingStickers = remainingStickers
        self.card = gameManager.getCurrentCard()
        self.hand = hand
    }
    
    
    
    func selectSticker(_ sticker: Sticker) {
        self.selectedSticker = sticker
    }
}

//
//  GameView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/6/24.
//

import SwiftUI

enum GameState {
    case standby, playerTurn, give, take
}

struct GameView: View {
    @StateObject var gameManager: GameManager = GameManager.preview(cardIndex: 2)
    @State var gameState: GameState = .standby
    
    var body: some View {
        ZStack {
            switch gameState {
            case .standby:
                StandbyView()
            case .playerTurn:
                switch gameManager.phase {
                case .question:
                    GuessingView(viewModel: GuessingViewModel(gameManager: gameManager, user: gameManager.currentPlayer))
                case .giveTake(let remainingStickers):
                    GiveTakeSelectionView(viewModel: GiveTakeSelectionViewModel(gameManager: gameManager, remainingStickers: remainingStickers, user: gameManager.currentPlayer), user: gameManager.currentPlayer)
                }
            case .give:
                GiveView()
            case .take:
                TakeView()
            }
        }
        .environmentObject(gameManager)
    }
}

#Preview {
    GameView()
}

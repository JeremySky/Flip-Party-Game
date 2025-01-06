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
    @StateObject var gameManager: GameManager = GameManager.preview(cardIndex: 51)
    @State var gameState: GameState = .playerTurn
    
    var body: some View {
        ZStack {
            switch gameState {
            case .standby:
                StandbyView(viewModel: StandbyViewModel(gameManager: gameManager), selectedPlayer: gameManager.currentPlayer)
            case .playerTurn:
                switch gameManager.phase {
                case .question:
                    GuessingView(viewModel: GuessingViewModel(gameManager: gameManager, user: gameManager.currentPlayer))
                case .giveTake(let remainingStickers):
                    GiveTakeSelectionView(viewModel: GiveTakeSelectionViewModel(gameManager: gameManager, remainingStickers: remainingStickers, user: gameManager.currentPlayer), user: gameManager.currentPlayer, stickerViewPropertiesArr: remainingStickers.map({ ($0, remainingStickers.count == 2 ? $0.offset : .zero , 1, 1) }))
                }
            case .give:
                GiveView()
            case .take:
                TakeView()
            }
        }
    }
}

#Preview {
    GameView()
}

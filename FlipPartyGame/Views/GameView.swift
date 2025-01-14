//
//  GameView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/6/24.
//

import SwiftUI

enum PlayersGameState {
    case waiting, standby, playerTurn, give, take, results
}

@MainActor
class GameViewModel: ObservableObject {
    @Published var gameState: PlayersGameState
    let user: User
    
    init(gameState: PlayersGameState, user: User) {
        self.gameState = gameState
        self.user = user
    }
    
    init(user: User) {
        self.gameState = .waiting
        self.user = user
    }
    
    func updateGameStateAfterEvent(gameManager: GameManager) {
        if gameState == .waiting {
            gameState = .standby
            return
        }
        if gameManager.phase == .results {
            gameState = .results
            return
        }
        switch gameManager.turnTaken {
        case false:
            if gameManager.currentPlayer.id == user.id {
                gameState = .playerTurn
                return
            }
            return
        case true:
            if gameManager.checkPlayerPoints(for: user) {
                gameState = .give
                return
            }
            if gameManager.checkPlayerPenalties(for: user) {
                gameState = .take
                return
            }
        }
    }
}

struct GameView: View {
    @StateObject var gameManager: GameManager
    @StateObject var viewModel: GameViewModel
    @State var user = User.test2
    
    var body: some View {
        ZStack {
            switch viewModel.gameState {
            case .waiting:
                WaitingRoomView()
                
            case .standby:
                StandbyView() { viewModel.updateGameStateAfterEvent(gameManager: gameManager) }
                
            case .playerTurn:
                playerTurnView
                
            case .give:
                GiveView()
                
            case .take:
                TakeView()
                
            case .results:
                Text("Results View")
            }
            
        }
        .environmentObject(gameManager)
        .environment(\.user, user)
    }
    
    
    
    
    private var playerTurnView: some View {
        Group {
            switch gameManager.phase {
            case .question:
                GuessingView(viewModel: GuessingViewModel(gameManager: gameManager))
            case .giveTake:
                GiveTakeSelectionView(viewModel: GiveTakeSelectionViewModel(gameManager: gameManager))
            default:
                Text("Unknown Phase")
            }
        }
    }
}

#Preview {
    @State var gameManager = GameManager.preview
    let user = User.test2
    @State var viewModel = GameViewModel(user: user)
    
    return ZStack {
        GameView(gameManager: gameManager, viewModel: viewModel)
        
        VStack {
            Spacer()
            Button("Update") {
                //                gameManager.players[user.id]?.points = 12
                viewModel.updateGameStateAfterEvent(gameManager: gameManager)
            }
            Button("Add") {
                                gameManager.players[user.id]?.penalties = 12
//                viewModel.updateGameStateAfterEvent(gameManager: gameManager)
            }
            Button("Take Turn") {
                                gameManager.turnTaken = true
//                viewModel.updateGameStateAfterEvent(gameManager: gameManager)
            }
        }
    }
}

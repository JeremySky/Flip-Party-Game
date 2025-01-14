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


struct GameView: View {
    @StateObject var gameManager: GameManager
    @State var gameState: PlayersGameState = .waiting
    @State var user = User.test1
    
    var body: some View {
        ZStack {
            switch gameState {
            case .waiting:
                WaitingRoomView()
                
            case .standby:
                StandbyView()
                
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
    GameView(gameManager: GameManager.preview)
}

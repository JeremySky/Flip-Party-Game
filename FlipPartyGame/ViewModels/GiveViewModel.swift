//
//  GiveViewModel.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/11/24.
//

import Foundation

@MainActor
class GiveViewModel: ObservableObject {
    let players: [User]
    let pointsReference: Int
    @Published var pointsRemaining: Int
    @Published var playerPoints: [UUID:Int]
    @Published var selectedQueue: [UUID]
    @Published var isQuickDistribute: Bool
    
    @Published var error: GiveError?
    
//    init(list: [(user: User, points: Int, isSelected: Bool)]) {
//        self.list = list
//    }
    init() {
        self.players = User.testArr
        self.pointsReference = 10
        self.pointsRemaining = 10
        self.playerPoints = Dictionary(uniqueKeysWithValues: User.testArr.map {( $0.id, 0 )})
        self.selectedQueue = []
        self.isQuickDistribute = false
    }
    
    func handlePlayerSelectAction(_ player: User) {
        
        switch isQuickDistribute {
        case true:
            if selectedQueue.contains(where: { $0 == player.id }) {
                // filter out player
                selectedQueue = selectedQueue.filter { $0 != player.id }
            } else {
                // dequeue if points cannot be split
                if selectedQueue.count != 0 && selectedQueue.count == pointsRemaining { selectedQueue.removeFirst() }
                selectedQueue.append(player.id)
            }
            
        case false:
            selectedQueue = selectedQueue.contains(where: { $0 == player.id }) ? [] : [player.id]
        }
        
        
        
    }
    
    func addPoint() {
        guard pointsRemaining != 0 else { return error = .noPointsToGive }
        guard let playerId = selectedQueue.first else { return error = .noPlayerSelected }
        guard playerPoints[playerId] != nil else { return error = .playersPointsNotFound }
        
        playerPoints[playerId]! += 1
        pointsRemaining -= 1
    }
    
    func subtractPoint() {
        guard let playerId = selectedQueue.first else { return error = .noPlayerSelected}
        guard playerPoints[playerId] != nil else { return error = .playersPointsNotFound }
        guard playerPoints[playerId]! > 0 else { return error = .noPointsToRemove }
        
        playerPoints[playerId]! -= 1
        pointsRemaining += 1
    }
    
    func removeAllPointsFromSelectedPlayers() {
        guard !selectedQueue.isEmpty else { return error = .noPlayerSelected }
        
        var returnPoints = 0
        
        for playerId in selectedQueue {
            guard playerPoints[playerId] != nil else { return error = .playersPointsNotFound }
            
            returnPoints += playerPoints[playerId]!
            playerPoints[playerId] = 0
            
        }
        
        pointsRemaining += returnPoints
        selectedQueue = []
        isQuickDistribute = false
    }
    
    func quickDistributePoints() {
        guard pointsRemaining != 0 else { return error = .noPointsToGive }
        guard !selectedQueue.isEmpty else { return error = .noPlayerSelected}
        
        let pointsSplit = pointsRemaining / selectedQueue.count
        
        for playerId in selectedQueue {
            guard playerPoints[playerId] != nil else { return error = .playersPointsNotFound }
            
            playerPoints[playerId]! += pointsSplit
        }
        
        pointsRemaining = pointsRemaining % selectedQueue.count
        selectedQueue = []
        isQuickDistribute = false
    }
}

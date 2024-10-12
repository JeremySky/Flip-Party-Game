//
//  CustomError.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/11/24.
//

import Foundation

enum GiveError: Error, LocalizedError {
    case noPlayerSelected, noPointsToGive, noPointsToRemove, playersPointsNotFound, unknown
    
    var errorDescription: String? {
        switch self {
        case .noPlayerSelected:
            "Select a player first..."
        case .noPointsToGive:
            "No points to give..."
        case .noPointsToRemove:
            "Player has no points!"
        case .playersPointsNotFound:
            "Player's points not found..."
        case .unknown:
            "An unknown error has occurred..."
        }
    }
}

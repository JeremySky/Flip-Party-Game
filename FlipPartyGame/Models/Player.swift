//
//  Player.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 1/13/25.
//

import Foundation
import SwiftUI

struct Player: Identifiable, Hashable {
    let user: User
    var id: UUID { user.id }
    var name: String { user.name }
    var iconString: String { user.icon.string }
    var color: Color { user.color.value }
    
    var points: Int
    var penalties: Int
    
    init(user: User, points: Int, penalties: Int) {
        self.user = user
        self.points = points
        self.penalties = penalties
    }
    
    init(user: User) {
        self.user = user
        self.points = 0
        self.penalties = 0
    }
}

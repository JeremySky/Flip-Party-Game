//
//  FlipPartyGame.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/6/24.
//

import SwiftUI

@main
struct FlipPartyGame: App {
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.red.opacity(0.85).ignoresSafeArea()
                RoomIDTextField()
            }
        }
    }
}

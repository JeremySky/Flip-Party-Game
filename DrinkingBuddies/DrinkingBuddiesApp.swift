//
//  DrinkingBuddiesApp.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/6/24.
//

import SwiftUI

@main
struct DrinkingBuddiesApp: App {
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.red.opacity(0.85).ignoresSafeArea()
                RoomIDTextField()
            }
        }
    }
}

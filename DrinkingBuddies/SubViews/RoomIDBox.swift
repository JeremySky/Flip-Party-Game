//
//  RoomIDBox.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI



struct RoomIDBox: View {
    
    let character: Character
    @Binding var isFocused: Bool
    
    init(_ character: Character, _ isFocused: Binding<Bool>) {
        self.character = character
        self._isFocused = isFocused
    }
    
    var body: some View {
        ZStack {
            Text(String(character))
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .opacity(isFocused ? 0.8 : 1)
                .cardStyle(customWidth: 60, customHeight: 80, border: false)
                .shadow(color: .white, radius: isFocused ? 10 : 0)
        }
    }
}

//
//  MiniFrontView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI

struct MiniFrontView: View {
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            Color.white
            Image(systemName: card.imageSystemName)
                .resizable()
                .scaledToFit()
                .padding(card.suit == .diamonds ? 6 : 7)
                .foregroundStyle(card.color)
            Text(card.text)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundStyle(.white)
        }
        .cardStyle(size: .mini)
    }
}

#Preview {
    MiniFrontView(Card(value: .king, suit: .diamonds))
}

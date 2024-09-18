//
//  MiniFrontView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI

struct MiniFrontView: View {
    let card: Card
    
    var cardColor: Color { card.getColor() }
    var suitImageString: String { card.getSuit() }
    var cardValueString: String { card.getText() }
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            Image(systemName: suitImageString)
                .resizable()
                .scaledToFit()
                .padding(9)
                .foregroundStyle(cardColor)
            Text(cardValueString)
                .font(.system(size: 25, weight: .black, design: .rounded))
                .foregroundStyle(.white)
        }
        .cardStyle(size: .mini)
    }
}

#Preview {
    MiniFrontView(Card(value: .king, suit: .spades))
}

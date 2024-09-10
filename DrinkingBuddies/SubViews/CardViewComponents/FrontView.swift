//
//  FrontView.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI

struct FrontView: View {
    let card: Card
    
    var cardColor: Color { card.getColor() }
    var suitImageString: String { card.getSuit() }
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            
            // Card Border...
            VStack(spacing: 0) {
                Text(card.getText())
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(cardColor)
                Image(systemName: suitImageString)
                    .suitFormat(color: cardColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.vertical, 2)
            .padding(.leading, card.value != .ten ? 9 : 6)
            .copyAndRotate()
            
            // Main Body...
            CardCenter(card)
            
            
        }
        .cardStyle(size: .standard)
    }
}

extension FrontView {
    struct CardCenter: View {
        
        let card: Card
        
        var cardValueString: String { card.getText() }
        var suitImageString: String { card.getSuit() }
        var cardColor: Color { card.getColor() }
        
        init(_ card: Card) {
            self.card = card
        }
        
        var body: some View {
            ZStack {
                switch card.value {
                    
                case .ace:
                    ZStack {
                        Image(systemName: suitImageString)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 104)
                            .foregroundStyle(cardColor)
                        Text(cardValueString)
                            .font(.system(size: 60, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    
                case .jack, .queen, .king:
                    ZStack {
                        Image(systemName: suitImageString)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .foregroundStyle(cardColor)
                        Image(systemName: "crown.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55)
                            .foregroundStyle(Color.yellow)
                            .offset(y: -75)
                        Text(cardValueString)
                            .font(.system(size: 70, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .offset(x: card.value == .jack ? -4 : 0)
                    }
                    .offset(y: 10)
                    
                case .two:
                    VStack(spacing: 100) {
                        getSuitImage(row: 2, column: 1)
                    }
                    
                case .three:
                    VStack(spacing: 40) {
                        getSuitImage(row: 3, column: 1)
                    }
                    
                case .four, .five:
                    ZStack {
                        VStack(spacing: 100) {
                            getSuitImage(row: 2, column: 2)
                        }
                        if card.value == .five {
                            Image(systemName: suitImageString)
                                .suitFormat(color: cardColor)
                        }
                    }
                    
                case .six, .seven:
                    ZStack {
                        VStack(spacing: 40) {
                            getSuitImage(row: 3, column: 2)
                        }
                        if card.value == .seven {
                            VStack(spacing: 44) {
                                Image(systemName: suitImageString)
                                    .suitFormat(color: cardColor)
                                Spacer().frame(height: 28)
                            }
                        }
                    }
                    
                case .eight, .nine, .ten:
                    ZStack {
                        VStack(spacing: 25) {
                            getSuitImage(row: 4, column: 2)
                        }
                        if card.value != .eight {
                            VStack(spacing: 84) {
                                Image(systemName: suitImageString)
                                    .suitFormat(color: cardColor)
                                Image(systemName: suitImageString)
                                    .suitFormat(color: cardColor)
                                    .opacity(card.value == .ten ? 1 : 0)
                            }
                        }
                    }
                    
                }
            }
            .frame(width: 125, height: 250)
            .border(Color.blue.opacity(0.3), width: 3)
        }
        
        
        func getSuitImage(row: Int, column: Int) -> some View {
            ForEach(0..<row, id: \.self) { iRow in
                HStack(spacing: 40) {
                    Image(systemName: suitImageString)
                        .suitFormat(color: cardColor)
                    if column > 1 {
                        Image(systemName: suitImageString)
                            .suitFormat(color: cardColor)
                    }
                }
            }
        }
    }
}

#Preview {
    FrontView(Card(value: .ten, suit: .hearts))
}

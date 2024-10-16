//
//  FrontView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI

struct FrontView: View {
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            
            // Card Border...
            VStack(spacing: 0) {
                Text(card.text)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(card.color)
                Image(systemName: card.imageSystemName)
                    .suitFormat(color: card.color)
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
        
        init(_ card: Card) {
            self.card = card
        }
        
        var body: some View {
            ZStack {
                switch card.value {
                    
                case .ace:
                    ZStack {
                        Image(systemName: card.imageSystemName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 104)
                            .foregroundStyle(card.color)
                        Text(card.text)
                            .font(.system(size: 60, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                            .offset(
                                y: card.suit == .clubs ? 2 : 0
                            )
                    }
                    
                case .jack, .queen, .king:
                    ZStack {
                        Image(systemName: card.imageSystemName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: card.suit == .clubs ? 110 : 100)
                            .foregroundStyle(card.color)
                        Image(systemName: "crown.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55)
                            .foregroundStyle(Color.yellow)
                            .offset(y: -75)
                        Text(card.text)
                            .font(.system(size: 70, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .offset(
                                x: card.value == .jack ? -4 : 0,
                                y: card.suit == .clubs ? 2 : 0
                            )
                            .offset(
                                x: card.suit == .clubs && card.value == .king ? 2 : 0,
                                y: card.suit == .clubs && card.value == .king ? 2 : 0
                            )
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
                            Image(systemName: card.imageSystemName)
                                .suitFormat(color: card.color)
                        }
                    }
                    
                case .six, .seven:
                    ZStack {
                        VStack(spacing: 40) {
                            getSuitImage(row: 3, column: 2)
                        }
                        if card.value == .seven {
                            VStack(spacing: 44) {
                                Image(systemName: card.imageSystemName)
                                    .suitFormat(color: card.color)
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
                                Image(systemName: card.imageSystemName)
                                    .suitFormat(color: card.color)
                                Image(systemName: card.imageSystemName)
                                    .suitFormat(color: card.color)
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
                    Image(systemName: card.imageSystemName)
                        .suitFormat(color: card.color)
                    if column > 1 {
                        Image(systemName: card.imageSystemName)
                            .suitFormat(color: card.color)
                    }
                }
            }
        }
    }
}

#Preview {
    struct Preview: View {
        @State var selectedSuit: CardSuit = .diamonds
        @State var selectedValue: CardValue = .ace
        
        func selectValue(_ value: CardValue) { selectedValue = value }
        
        var body: some View {
            TabView(selection: $selectedSuit) {
                ForEach(CardSuit.allCases) { suit in
                    VStack {
                        HStack(spacing: 10) {
                            Button(action: { selectValue(.ace) }) {
                                MiniFrontView(Card(value: .ace, suit: suit))
                            }
                            Button(action: { selectValue(.two) }) {
                                MiniFrontView(Card(value: .two, suit: suit))
                            }
                            Button(action: { selectValue(.ten) }) {
                                MiniFrontView(Card(value: .ten, suit: suit))
                            }
                            Button(action: { selectValue(.jack) }) {
                                MiniFrontView(Card(value: .jack, suit: suit))
                            }
                        }
                        TabView(selection: $selectedValue) {
                            ForEach(CardValue.allCases) { value in
                                FrontView(Card(value: value, suit: suit))
                                    .tag(value)
                            }
                        }
                    }
                    .tabItem { Image(systemName: suit.imageString) }
                    .tabViewStyle(.page)
                }
            }
        }
    }
    
    return Preview()
}

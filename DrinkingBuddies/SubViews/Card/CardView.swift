//
//  CardView.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/9/24.
//

import SwiftUI

enum CardSize {
    case standard, mini
}

struct CardView: View {
    let card: Card
    let style: CardSize
    @State var isFlipped: Bool
    
    
    // For Animation...
    @State var frontDegree: CGFloat = 90
    @State var backDegree: CGFloat = 0
    let durationAndDelay: CGFloat = 0.3
    
    init(card: Card, style: CardSize, isFlipped: Bool = false) {
        self.card = card
        self.style = style
        self.isFlipped = isFlipped
    }
    
    
    
    var body: some View {
        ZStack {
            
            switch style {
                
            case .standard:
                FrontView(card)
                    .rotation3DEffect(
                        .degrees(frontDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                BackView(color: Color.red, cardSize: .standard)
                    .rotation3DEffect(
                        .degrees(backDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                
                
            case .mini:
                MiniFrontView(card)
                    .rotation3DEffect(
                        .degrees(frontDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                BackView(color: Color.red, cardSize: .mini)
                    .rotation3DEffect(
                        .degrees(backDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
            }
        }
        .onTapGesture { if !isFlipped { flipCard() } }
    }
    
    
    
    func flipCard() {
        isFlipped = true
        withAnimation(.linear(duration: durationAndDelay)) {
            backDegree = -90
        }
        withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
            frontDegree = 0
        }
    }
}




#Preview {
    let value = CardValue.allCases.randomElement()!
    let suit = CardSuit.allCases.randomElement()!
    
    return VStack {
        CardView(card: Card(value: value, suit: suit), style: .standard)
            .padding()
        CardView(card: Card(value: value, suit: suit), style: .mini)
            .padding()
    }
}


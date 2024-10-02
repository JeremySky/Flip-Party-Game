//
//  CardView.swift
//  FlipPartyGame
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
    @Binding var isFlipped: Bool
    
    
    // For Animation...
    @State var frontDegree: CGFloat = 90
    @State var backDegree: CGFloat = 0
    let durationAndDelay: CGFloat = 0.2
    
    init(card: Card, style: CardSize, isFlipped: Binding<Bool>) {
        self.card = card
        self.style = style
        self._isFlipped = isFlipped
    }
    
    
    
    var body: some View {
        ZStack {
            
            switch style {
                
            case .standard:
                FrontView(card)
                    .rotation3DEffect(
                        .degrees(frontDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                BackView(cardSize: .standard)
                    .rotation3DEffect(
                        .degrees(backDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                
                
            case .mini:
                MiniFrontView(card)
                    .rotation3DEffect(
                        .degrees(frontDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                BackView(cardSize: .mini)
                    .rotation3DEffect(
                        .degrees(backDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
            }
        }
        .onChange(of: isFlipped) { oldValue, newValue in
            if newValue == true {
                frontDegree = 90
                withAnimation(.linear(duration: durationAndDelay)) {
                    backDegree = -90
                }
                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                    frontDegree = 0
                }
            } else {
                backDegree = 90
                withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                    backDegree = 0
                }
                withAnimation(.linear(duration: durationAndDelay)) {
                    frontDegree = -90
                }
            }
        }
    }
}




#Preview {
    struct CardViewPreview: View {
        
        let value = CardValue.allCases.randomElement()!
        let suit = CardSuit.allCases.randomElement()!
        
        @State var isFlippedStandard = false
        @State var isFlippedMini = false
        
        
        var body: some View {
            VStack {
                CardView(card: Card(value: value, suit: suit), style: .standard, isFlipped: $isFlippedStandard)
                    .onTapGesture { isFlippedStandard.toggle() }
                    .padding()
                CardView(card: Card(value: value, suit: suit), style: .mini, isFlipped: $isFlippedMini)
                    .onTapGesture { isFlippedMini.toggle() }
                    .padding()
            }
        }
    }
    
    return CardViewPreview()
}


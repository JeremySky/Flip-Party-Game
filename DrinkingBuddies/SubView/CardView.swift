//
//  CardView.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/9/24.
//

import SwiftUI

enum CardSize {
    case standard, mini
    
    var width: CGFloat {
        switch self {
        case .standard:
            200
        case .mini:
            80
        }
    }
    
    var height: CGFloat {
        switch self {
        case .standard:
            333
        case .mini:
            100
        }
    }
    
    var innerPadding: CGFloat {
        switch self {
        case .standard:
            10
        case .mini:
            6
        }
    }
}

extension View {
    func cardStyle(width: CGFloat, height: CGFloat) -> some View {
        self
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .stroke(Color.gray, lineWidth: 4)
            )
    }
    
    func copyAndRotate() -> some View {
        ZStack {
            self
            self.rotationEffect(.degrees(180))
        }
    }
}

extension Image {
    func suitFormat(color: Color) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 28)
            .foregroundStyle(color)
    }
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
                StandardFront(card)
                    .rotation3DEffect(
                        .degrees(frontDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                CardBack(color: Color.red, cardSize: .standard)
                    .rotation3DEffect(
                        .degrees(backDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
            case .mini:
                MiniFront(card)
                    .rotation3DEffect(
                        .degrees(frontDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                CardBack(color: Color.red, cardSize: .mini)
                    .rotation3DEffect(
                        .degrees(backDegree), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
            }
        }
        .onTapGesture { flipCard() }
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


extension CardView {
    
    struct StandardFront: View {
        let card: Card
        var color: Color { card.getColor() }
        
        init(_ card: Card) {
            self.card = card
        }
        
        var body: some View {
            ZStack {
                
                // Card Border...
                VStack(spacing: 0) {
                    Text(card.getText())
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(color)
                    Image(systemName: card.getSuit())
                        .suitFormat(color: color)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.vertical, 2)
                .padding(.leading, card.value != .ten ? 6 : 2)
                .copyAndRotate()
                
                
                CardCenter(card)
            }
            .cardStyle(width: CardSize.standard.width, height: CardSize.standard.height)
        }
    }
    
    struct CardCenter: View {
        let card: Card
        var text: String { card.getText() }
        var suit: String { card.getSuit() }
        var color: Color { card.getColor() }
        
        init(_ card: Card) {
            self.card = card
        }
        
        var body: some View {
            ZStack {
                switch card.value {
                    
                case .ace:
                    ZStack {
                        Image(systemName: suit)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 104)
                            .foregroundStyle(color)
                        Text(text)
                            .font(.system(size: 60, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                    }
                    
                case .jack, .queen, .king:
                    ZStack {
                        Image(systemName: suit)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .foregroundStyle(color)
                        Image(systemName: "crown.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .foregroundStyle(Color.yellow)
                            .offset(y: -80)
                        Text(text)
                            .font(.system(size: 70, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .offset(x: card.value == .jack ? -4 : 0)
                    }
                    
                case .two:
                    VStack(spacing: 100) {
                        Image(systemName: suit)
                            .suitFormat(color: color)
                        Image(systemName: suit)
                            .suitFormat(color: color)
                    }
                    
                case .three:
                    VStack(spacing: 40) {
                        Image(systemName: suit)
                            .suitFormat(color: color)
                        Image(systemName: suit)
                            .suitFormat(color: color)
                        Image(systemName: suit)
                            .suitFormat(color: color)
                    }
                    
                case .four, .five:
                    ZStack {
                        VStack(spacing: 100) {
                            HStack(spacing: 40) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                            }
                            HStack(spacing: 40) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                            }
                        }
                        if card.value == .five {
                            Image(systemName: suit)
                                .suitFormat(color: color)
                        }
                    }
                    
                case .six, .seven:
                    ZStack {
                        VStack(spacing: 40) {
                            HStack(spacing: 40) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                            }
                            HStack(spacing: 40) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                            }
                            HStack(spacing: 40) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                            }
                        }
                        if card.value == .seven {
                            VStack(spacing: 44) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Spacer().frame(height: 28)
                            }
                        }
                    }
                    
                case .eight, .nine, .ten:
                    ZStack {
                        VStack(spacing: 25) {
                            HStack(spacing: 40) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                            }
                            HStack(spacing: 40) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                            }
                            HStack(spacing: 40) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                            }
                            HStack(spacing: 40) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                            }
                        }
                        if card.value != .eight {
                            VStack(spacing: 84) {
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                Image(systemName: suit)
                                    .suitFormat(color: color)
                                    .opacity(card.value == .ten ? 1 : 0)
                            }
                        }
                    }
                    
                }
            }
            .frame(width: 120, height: 250)
            .border(Color.blue.opacity(0.3), width: 3)
        }
    }
    
    struct MiniFront: View {
        let card: Card
        
        init(_ card: Card) {
            self.card = card
        }
        
        var body: some View {
            ZStack {
                Image(systemName: card.getSuit())
                    .resizable()
                    .scaledToFit()
                    .padding(9)
                    .foregroundStyle(card.getColor())
                Text(card.getText())
                    .font(.system(size: 25, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
            .cardStyle(width: CardSize.mini.width, height: CardSize.mini.height)
        }
    }
    
    struct CardBack: View {
        
        let color: Color
        let cardSize: CardSize
        
        var body: some View {
            color
                .opacity(0.96)
                .clipShape(
                    RoundedRectangle(cornerRadius: 6)
                )
                .padding(cardSize.innerPadding)
                .cardStyle(width: cardSize.width, height: cardSize.height)
        }
    }
}



#Preview {
    
    return VStack {
//        CardView.StandardFront(Card(value: .king, suit: .diamonds))
        CardView(card: Card(value: .ace, suit: .hearts), style: .standard)
            .padding()
        CardView(card: Card(value: .ace, suit: .hearts), style: .mini)
            .padding()
        CardView.MiniFront(Card(value: .ace, suit: .spades))
    }
}


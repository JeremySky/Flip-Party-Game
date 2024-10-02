//
//  BackView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI

struct BackView: View {
    
    let cardSize: CardSize
    
    var body: some View {
        Color.red
            .opacity(0.96)
            .clipShape(
                RoundedRectangle(cornerRadius: 6)
            )
            .padding(getInnerPadding())
            .cardStyle(size: cardSize)
    }
    
    func getInnerPadding() -> CGFloat {
        switch cardSize {
        case .standard:
            10
        case .mini:
            6
        }
    }
}

#Preview {
    return VStack(spacing: 30) {
        BackView(cardSize: .standard)
        BackView(cardSize: .mini)
    }
}

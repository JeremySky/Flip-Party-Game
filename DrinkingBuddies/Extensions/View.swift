//
//  View.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI


extension View {
    
    func cardStyle(size: CardSize) -> some View {
        var width: CGFloat {
            switch size {
            case .standard:
                200
            case .mini:
                80
            }
        }
        var height: CGFloat {
            switch size {
            case .standard:
                333
            case .mini:
                100
            }
        }
        
        return self
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

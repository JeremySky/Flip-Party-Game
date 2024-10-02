//
//  View.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI


extension View {
    
    func cardStyle(size: CardSize? = nil, customWidth: CGFloat? = nil, customHeight: CGFloat? = nil, border: Bool = true) -> some View {
        var width: CGFloat {
            switch size {
            case .standard:
                215
            case .mini:
                60
            default:
                customWidth ?? 215
            }
        }
        var height: CGFloat {
            switch size {
            case .standard:
                338
            case .mini:
                60
            default:
                customHeight ?? 338
            }
        }
        var borderWidth: CGFloat {
            switch size {
            case .standard:
                4
            case .mini:
                3
            default:
                4
            }
        }
        
        return self
            .frame(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .stroke(Color.gray, lineWidth: border ? borderWidth : 0)
            )
    }
    
    func copyAndRotate() -> some View {
        ZStack {
            self
            self.rotationEffect(.degrees(180))
        }
    }
}

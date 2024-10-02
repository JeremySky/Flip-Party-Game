//
//  GuessingView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/30/24.
//

import SwiftUI

enum GamePhase {
    case one, two, three, four
    
    var selections: [Selections] {
        switch self {
        case .one:
            [.red, .black]
        case .two:
            [.higher, .lower, .equal]
        case .three:
            [.inside, .outside, .equal]
        case .four:
            [.heart, .spade, .diamond, .club]
        }
    }
    
    enum Selections: String {
        case black, red, higher, lower, equal, inside, outside, heart, spade, diamond, club
        
        var color: Color {
            switch self {
            case .red, .heart, .diamond:
                    .red
            default:
                    .black
            }
        }
        
        var imageString: String? {
            switch self {
            case .higher:
                "arrowshape.up.fill"
            case .lower:
                "arrowshape.down.fill"
            case .equal:
                "equal"
            case .inside:
                "arrow.down.right.and.arrow.up.left"
            case .outside:
                "arrow.up.left.and.arrow.down.right"
            case .heart:
                "suit.heart.fill"
            case .spade:
                "suit.spade.fill"
            case .diamond:
                "suit.diamond.fill"
            case .club:
                "suit.club.fill"
            default:
                nil
            }
        }
    }
}

struct GuessingView: View {
    
    var currentPlayer: User = User.test1
    var phase: GamePhase = .one
    @State var selection: String?
    
    
    var body: some View {
        VStack {
            
            Header(player: currentPlayer, type: .currentPlayer)
            
            
            CardView(card: Card(value: .eight, suit: .diamonds), style: .standard)
                .frame(maxHeight: .infinity)
            
            
            HStack(spacing: 20) {
                ForEach(phase.selections, id: \.self) { selection in
                    Button(action: { self.selection = selection.rawValue }, label: {
                        if let imageString = selection.imageString {
                            Image(systemName: imageString)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .foregroundStyle(selection.color)
                                .fontWeight(selection == .equal || selection == .inside || selection == .outside ? .heavy : .medium)
                        } else {
                            Text(selection.rawValue)
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(selection.color)
                        }
                    })
                    .cardStyle(customWidth: 75, customHeight: 75)
                }
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    GuessingView()
}

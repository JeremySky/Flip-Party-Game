//
//  Header.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/2/24.
//

import SwiftUI

enum HeaderType {
    case host(_ roomID: String), currentPlayer, take, give(_ points: Int)
    
    var rawValue: String {
        switch self {
        case .host:
            "Host"
        case .currentPlayer:
            "Current Turn"
        case .take:
            "Take"
        case .give:
            "Give"
        }
    }
    
    var height: CGFloat {
        switch self {
        case .host:
            190
        case .give:
            200
        default:
            170
        }
    }
}

struct Header: View {
    
    let player: User
    let type: HeaderType
    
    var body: some View {
        ZStack {
            player.color.value.ignoresSafeArea()
            LinearGradient(colors: [.black.opacity(0.4), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            .ignoresSafeArea()
            VStack {
                
                switch type {
                case .host(let roomID):
                    HStack {
                        ForEach(Array(roomID.enumerated()), id: \.element) { _, char in
                            Text("\(char)")
                                .font(.body.weight(.heavy))
                                .fontDesign(.rounded)
                                .opacity(0.85)
                                .cardStyle(customWidth: 40, customHeight: 40, border: false)
                        }
                    }
                default:
                    EmptyView()
                }
                
                switch type {
                case .give(let points):
                    //MARK: -- POINTS REMAINING...
                    ZStack {
                        VStack(spacing: -10) {
                            Text("\(points)")
                                .font(.system(size: 90, weight: .heavy, design: .rounded))
                            Text("Points")
                        }
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .circleBackground(diameter: 164, .white, true)
                    }
                    .padding(.bottom)
                default:
                    HStack {
                        Image(player.icon.string)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .padding(6)
                            .background( Circle().opacity(0.3))
                        VStack(alignment: .leading, spacing: 0) {
                            Text(type.rawValue)
                                .font(.caption.weight(.bold))
                                .fontDesign(.rounded)
                                .padding(.leading, 5)
                            Text(player.name)
                                .font(.largeTitle.weight(.bold))
                                .fontDesign(.rounded)
                        }
                        .padding(.trailing, 30)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10).opacity(0.2)
                    )
                }
            }
        }
        .frame(height: type.height)
    }
}

#Preview {
    return VStack {
        Header(player: User.test1, type: .host("AQ9D"))
//        Header(player: User.test2, type: .currentPlayer)
        Spacer()
    }
}

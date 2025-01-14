//
//  Header.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/2/24.
//

import SwiftUI

enum HeaderType {
    case waitingRoom(_ roomID: String?, _ host: User), currentPlayer(_ player: User), waitingOn(_ players: [User]), take, give(_ points: Int), guessing, giveTake
    
    var rawValue: String {
        switch self {
        case .waitingRoom:
            "Host"
        case .currentPlayer:
            "Current Turn"
        case .waitingOn:
            "Waiting On..."
        case .take:
            "Take"
        case .give:
            "Give"
        case .guessing:
            "Guessing"
        case .giveTake:
            "Give / Take"
        }
    }
    
    var height: CGFloat {
        switch self {
        case .waitingRoom:
            190
        case .give:
            200
        default:
            170
        }
    }
    
    var playerInfo: User? {
        switch self {
        case .waitingRoom(_, let host):
            return host
        case .currentPlayer(let player):
            return player
        default:
            return nil
        }
    }
}

struct Header: View {
    
    @Environment(\.user) var user
    let type: HeaderType
    
    var player: User { type.playerInfo ?? user }
    
    
    var body: some View {
        ZStack {
            player.color.value.ignoresSafeArea()
            LinearGradient(colors: [.black.opacity(0.4), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            .ignoresSafeArea()
            VStack {
                
                switch type {
                case .waitingRoom(let roomID, _):
                    if let roomID {
                        HStack {
                            ForEach(Array(roomID.enumerated()), id: \.element) { _, char in
                                Text("\(char)")
                                    .font(.body.weight(.heavy))
                                    .fontDesign(.rounded)
                                    .opacity(0.85)
                                    .cardStyle(customWidth: 40, customHeight: 40, border: false)
                            }
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
                case .waitingOn(let playersInfo):
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(playersInfo, id: \.self.id) { playerInfo in
                                
                                HStack {
                                    Image(playerInfo.icon.string)
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
                                        Text(playerInfo.name)
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
                        .padding(.horizontal)
                    }
                    .scrollIndicators(.hidden)
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
//        Header(type: .waitingRoom("AQ9D", User.test2))
//        Header(player: User.test2, type: .currentPlayer)
        Header(type: .waitingOn(User.testArr))
        Spacer()
    }
    .environmentObject(GameManager.preview)
}

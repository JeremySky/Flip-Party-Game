//
//  WaitingRoomView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/18/24.
//

import SwiftUI

struct WaitingRoomView: View {
    
    @EnvironmentObject var gameManager: GameManager
    @Environment(\.user) var user
    let roomID: String? = nil
    
    var host: User { gameManager.host }
    var isHost: Bool { gameManager.host.id == user.id }
    var users: [User] { gameManager.userList }
    var isValid: Bool { users.count >= 2 }
    
    let waitingText: String = "Waiting..."
    @State private var waveOffset: [CGFloat] = Array(repeating: 0, count: "Waiting...".count)
    
    
    
    var body: some View {
        VStack {
            
            //MARK: -- HEADER...
            Header(type: .waitingRoom(roomID, host))
            
            
            //MARK: -- PLAYERS...
            VStack(spacing: 25) {
                
                ForEach(users) { user in
                    if user != host {
                        HStack {
                            Image(user.icon.string)
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .background( Circle().foregroundStyle(.white).opacity(0.3) )
                                .padding(.vertical, 5)
                                .padding(.leading, -25)
                            Text(user.name)
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        }
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 6).foregroundStyle(user.color.value)
                        )
                        .padding(.horizontal)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            
            
            //MARK: ACTION BUTTON / WAITING TEXT...
            ZStack {
                if isHost {
                    Button("Start", action: {})
                        .buttonStyle(ColorBackground(isValid, user.color.value))
                        .padding(.horizontal, 40)
                } else {
                    
                    HStack(spacing: 3) {
                        ForEach(Array(waitingText.enumerated()), id: \.0) { i, char in
                            Text(String(char))
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundStyle(.gray)
                                .offset(y: waveOffset[i])
                        }
                    }
                    
                }
            }
            .frame(height: 100)
        }
        .onAppear{ startWaveAnimation() }
    }
    
    private func startWaveAnimation() {
        for index in waveOffset.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                    waveOffset[index] = -6
                }
            }
        }
    }
}

#Preview {
    @State var user = User.test2
    @State var gameManager = GameManager.preview
    
    return WaitingRoomView()
        .environmentObject(gameManager)
        .environment(\.user, user)
}

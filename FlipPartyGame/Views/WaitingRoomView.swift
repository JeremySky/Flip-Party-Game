//
//  WaitingRoomView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/18/24.
//

import SwiftUI

struct WaitingRoomView: View {
    
    @State var users: [User] = User.testArr
    @State var host: User = .test1
    let roomID: String = "B34R"
    var isHost = true
    
    let waitingText: String = "Waiting..."
    @State private var waveOffset: [CGFloat] = Array(repeating: 0, count: "Waiting...".count)
    
    
    var isValid: Bool { users.count >= 2 }
    
    var body: some View {
        VStack {
            
            //MARK: -- HEADER...
            Header(type: .waitingRoom(roomID, host))
            
            
            //MARK: -- PLAYERS...
            VStack(spacing: 25) {
                
                ForEach(users) { user in
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
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 6).foregroundStyle(user.color.value)
                    )
                    .padding(.horizontal)
                    
                }
            }
            .frame(maxHeight: .infinity)
            
            
            //MARK: ACTION BUTTON / WAITING TEXT...
            ZStack {
                if isHost {
                    Button(action: {}, label: {
                        ZStack {
                            Text("Start")
                                .font(.system(size: 45, weight: .black, design: .rounded))
                                .foregroundStyle(host.color.value)
                            Text("Start")
                                .font(.system(size: 45, weight: .black, design: .rounded))
                                .foregroundStyle(.black.opacity(0.2).gradient)
                        }
                    })
                    .buttonStyle(CustomAnimation())
                } else {
                    
                    HStack(spacing: 3) {
                        ForEach(Array(waitingText.enumerated()), id: \.0) { i, char in
                            Text(String(char))
                                .font(.system(size: 45, weight: .black, design: .rounded))
                                .foregroundStyle(.gray)
                                .offset(y: waveOffset[i])
                        }
                    }
                    
                }
            }
            .frame(height: 100)
        }
        .onAppear(perform: { startWaveAnimation() })
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
    WaitingRoomView()
        .environmentObject(GameManager.preview)
}

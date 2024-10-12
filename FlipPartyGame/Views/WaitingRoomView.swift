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
    @State var isHost = false
    
    
    var isValid: Bool { users.count >= 2 }
    
    var body: some View {
        VStack {
            Header(player: host, type: .host(roomID))
            
            VStack(spacing: 20) {
                
                ForEach(users) { user in
                    HStack {
                        Image(user.icon.string)
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            .background( Circle().foregroundStyle(.white).opacity(0.3) )
                            .padding(5)
                        Text(user.name)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .padding(.trailing, 30)
                    }
                    .frame(height: 70)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 6).foregroundStyle(user.color.value)
                    )
                    .padding(.horizontal)
                    
                }
            }
            .frame(maxHeight: .infinity)
            
            ZStack {
                Group {
                    host.color.value
                    LinearGradient(colors: [.white.opacity(0.2), .black.opacity(0.4)], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                }
                .ignoresSafeArea()
                
                if isHost {
                    Button("START", action: {})
                        .buttonStyle(WhiteBackground(isValid, host.color.value))
                        .disabled(!isValid)
                } else {
                    Text("Waiting...")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .frame(height: 100)
        }
    }
}

#Preview {
    WaitingRoomView()
}

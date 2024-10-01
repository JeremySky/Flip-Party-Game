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
    let roomID: [Character] = ["B", "3", "4", "R"]
    @State var isHost = false
    
    
    var isValid: Bool { users.count >= 2 }
    
    var body: some View {
        VStack {
            header()
                .frame(height: 190)
            
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
                            .font(.title2.weight(.bold))
                            .fontDesign(.rounded)
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
                    Color(.gray).opacity(0.15)
                }
                .ignoresSafeArea()
                
                if isHost {
                    Button("START", action: {})
                        .buttonStyle(CustomButtonStylePrimary(isValid, host.color.value))
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
    
    private func header() -> some View {
        ZStack {
            Group {
                host.color.value
                Color(.gray).opacity(0.15)
            }
                .ignoresSafeArea()
            VStack {
                HStack {
                    ForEach(roomID, id: \.self) { char in
                        Text("\(char)")
                            .font(.body.weight(.heavy))
                            .fontDesign(.rounded)
                            .opacity(0.85)
                            .cardStyle(customWidth: 40, customHeight: 40, border: false)
                    }
                }
                HStack {
                    Image(host.icon.string)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(6)
                        .background( Circle().opacity(0.3))
                    VStack(alignment: .leading, spacing: 0) {
                        Text("HOST")
                            .font(.caption.weight(.bold))
                            .fontDesign(.rounded)
                            .padding(.leading, 5)
                        Text(host.name)
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
}

#Preview {
    WaitingRoomView()
}

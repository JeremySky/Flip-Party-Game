//
//  JoinRoomView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/18/24.
//

import SwiftUI

struct JoinRoomView: View {
    
    @StateObject var viewModel = JoinRoomViewModel()
    
    var body: some View {
        VStack {
            
            //MARK: -- ROOM TEXT FIELD...
            RoomIDTextField(viewModel: viewModel)
            
            //MARK: -- ACTION BUTTON...
            Button("JOIN", action: {})
                .buttonStyle(WhiteBackground(viewModel.roomIdIsValid, .red))
                .padding(.horizontal, 40)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                Color.red.ignoresSafeArea()
                LinearGradient(colors: [.white.opacity(0.2), .black.opacity(0.4)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
        )
    }
}

#Preview {
    JoinRoomView()
}

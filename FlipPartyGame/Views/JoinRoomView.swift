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
        ZStack {
            Color.red.opacity(0.9).ignoresSafeArea()
            VStack {
                
                RoomIDTextField(viewModel: viewModel)
                
                Button(action: {}, label: {
                    Text("JOIN")
                        .font(.title2.weight(.heavy))
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.red)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                        )
                })
                .padding(.horizontal, 50)
                .disabled(!viewModel.roomIdIsValid)
                .opacity(viewModel.roomIdIsValid ? 1 : 0.4)
                
            }
        }
    }
}

#Preview {
    JoinRoomView()
}

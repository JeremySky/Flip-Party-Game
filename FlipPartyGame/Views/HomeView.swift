//
//  HomeView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/17/24.
//

import SwiftUI

struct HomeView: View {
    
    @State var name: String = ""
    @State var placeholder: String = "YOUR NAME"
    var isValid: Bool { !name.isEmpty }
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack {
            
            //MARK: -- TITLE...
            Image("flip")
                .renderingMode(.template)
                .foregroundColor(.white)
                .rotationEffect(.degrees(-3.0))
                .padding(.bottom, 20)
            
            //MARK: NAME FIELD...
            TextField(placeholder, text: $name)
                .multilineTextAlignment(.center)
                .font(.title.weight(.heavy))
                .fontDesign(.rounded)
                .frame(height: 55)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                )
                .padding()
                .padding(.bottom, 6)
                .focused($isFocused)
                .onChange(of: isFocused) { oldValue, newValue in
                    self.placeholder = newValue ? "" : "YOUR NAME"
                }
            
            
            //MARK: -- ACTION BUTTONS...
            Button("HOST", action: {})
                .buttonStyle(WhiteBackground(isValid, Color.red))
                .padding(.horizontal, 40)
                .padding(.bottom, 5)
            
            Button("JOIN", action: {})
                .buttonStyle(ColorBackground(isValid, Color.red))
                .padding(.horizontal, 40)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                Color.red.ignoresSafeArea()
                LinearGradient(colors: [.white.opacity(0.13), .black.opacity(0.35)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
        )
    }
}

#Preview {
    HomeView()
}

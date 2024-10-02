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
        ZStack {
            Color.red.ignoresSafeArea().opacity(0.88)
            VStack {
                Image("flip")
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(-3.0))
                    .padding(.bottom, 20)
                
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
                
                Group {
                    
                    Button("HOST", action: {})
                        .buttonStyle(WhiteBackground(isValid, Color.red))
                    
                    Button("JOIN", action: {})
                        .buttonStyle(ColorBackground(isValid, Color.red))
    
                }
                
                
            }
        }
    }
}

#Preview {
    HomeView()
}

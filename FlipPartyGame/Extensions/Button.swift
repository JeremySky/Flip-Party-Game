//
//  Button.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/18/24.
//

import SwiftUI

struct CustomButtonStylePrimary: ButtonStyle {
    var isValid: Bool // Pass in the `isValid` state to control the style
    var color: Color
    
    init(_ isValid: Bool, _ color: Color) {
        self.isValid = isValid
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2.weight(.heavy))
            .fontDesign(.rounded)
            .foregroundStyle(color.opacity(isValid ? 1 : 0.4))
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Optional: Add a press effect
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .padding(.horizontal, 50)
            .disabled(!isValid)
            .opacity(isValid ? 1 : 0.6)
    }
}

struct CustomButtonStyleSecondary: ButtonStyle {
    var isValid: Bool // Pass in the `isValid` state to control the style
    var color: Color
    
    init(_ isValid: Bool, _ color: Color) {
        self.isValid = isValid
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2.weight(.heavy))
            .fontDesign(.rounded)
            .foregroundStyle(color.opacity(isValid ? 1 : 0.4))
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Optional: Add a press effect
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .padding(.horizontal, 50)
            .disabled(!isValid)
            .opacity(isValid ? 1 : 0.6)
    }
}

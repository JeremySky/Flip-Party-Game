//
//  Image.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI

extension Image {
    func suitFormat(color: Color) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 28)
            .foregroundStyle(color)
    }
}

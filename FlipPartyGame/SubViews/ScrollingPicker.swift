//
//  ScrollingPicker.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/16/24.
//

import SwiftUI

enum ItemType { case color(Color), image(String) }


struct ScrollingPicker: View {
    
    @State var collection: [ItemType]
    
    let selectAction: (ItemType) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<collection.count, id: \.self) { index in
                    
                    buildItemView(for: collection[index])
                        .frame(width: 80, height: 80)
                    
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    
    @ViewBuilder
    private func buildItemView(for item: ItemType) -> some View {
        switch item {
        case .color(let color):
            Circle()
                .foregroundColor(color)
            
        case .image(let imageString):
            Image(imageString)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
        }
    }
}

#Preview {
    return VStack {
        ScrollingPicker(collection: ColorSelection.collection) { _ in }
        ScrollingPicker(collection: IconSelection.collection) { _ in }
    }
}

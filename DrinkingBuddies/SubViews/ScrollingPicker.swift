//
//  ScrollingPicker.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/16/24.
//

import SwiftUI

enum ItemType { case color(Color), image(String) }

enum ColorSelection: CaseIterable {
    case red, pink, orange, yellow, green, mint, teal, cyan, blue, purple, indigo, brown, black
    
    private var value: Color {
        switch self {
        case .red:
            Color.red
        case .pink:
            Color.pink
        case .orange:
            Color.orange
        case .yellow:
            Color.yellow
        case .green:
            Color.green
        case .mint:
            Color.mint
        case .teal:
            Color.teal
        case .cyan:
            Color.cyan
        case .blue:
            Color.blue
        case .purple:
            Color.purple
        case .indigo:
            Color.indigo
        case .brown:
            Color.brown
        case .black:
            Color.black
        }
    }
    
    static var collection: [ItemType] {
        
            var arr: [ItemType] = []
            
            for color in ColorSelection.allCases {
                arr.append(.color(color.value))
            }
            
            return arr
    }
}

enum ImageSelection: CaseIterable {
    case beerBlue, beerRed, beerPurple, beerCan, beerPong, cocktailPink, cocktailGreen, strong, iceBucket, barrel
    
    private var string: String {
        switch self {
        case .beerBlue:
            "beer-blue"
        case .beerRed:
            "beer-red"
        case .beerPurple:
            "beer-purple"
        case .beerCan:
            "beer-can"
        case .beerPong:
            "beer-pong"
        case .cocktailPink:
            "cocktail-pink"
        case .cocktailGreen:
            "cocktail-green"
        case .strong:
            "strong"
        case .iceBucket:
            "ice-bucket"
        case .barrel:
            "barrel"
        }
    }
    
    static var collection: [ItemType] {
        
            var arr: [ItemType] = []
            
            for image in ImageSelection.allCases {
                arr.append(.image(image.string))
            }
            
            return arr
    }
}


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
        ScrollingPicker(collection: ImageSelection.collection) { _ in }
    }
}

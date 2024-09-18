//
//  RoomIDTextField.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI

enum FocusField: CaseIterable {
    case one, two, three, four
    
    var index: Int {
        switch self {
        case .one:
            return 0
        case .two:
            return 1
        case .three:
            return 2
        case .four:
            return 3
        }
    }
    
    var next: FocusField {
        switch self {
        case .one:
                return .two
        case .two:
                return .three
        case .three:
                return .four
        case .four:
                return .four
        }
    }
    
    var previous: FocusField {
        switch self {
        case .one:
                return .one
        case .two:
                return .one
        case .three:
                return .two
        case .four:
                return .three
        }
    }
    
    static var count: Int { FocusField.allCases.count }
}

struct RoomIDTextField: View {
    
    @ObservedObject var viewModel: JoinRoomViewModel
    
    @FocusState var isFocused: Bool
    
    
    var body: some View {
        ZStack {
            TextField("", text: $viewModel.string)
                .frame(width: 0, height: 0).offset(y: 700) // HIDE
                .focused($isFocused).opacity(0)
                .onSubmit {
                    
                    if !viewModel.idStack.contains(where: { $0.char == nil }) {
//                        return submit(getID())
                    }
                    
                    if let unwrappedFocusField = viewModel.focusField {
                        let focusedChar = viewModel.idStack[unwrappedFocusField.index].char
                        viewModel.focusField = focusedChar != nil ? viewModel.focusField?.next : viewModel.focusField
                        isFocused = focusedChar != nil ? true : false
                    }
                }
                .autocorrectionDisabled()
            
            HStack(spacing: 15) {
                
                ForEach(0..<viewModel.idStack.count, id: \.self) { index in
                    ZStack {
                        Text(String(viewModel.idStack[index].char ?? "-"))
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .cardStyle(customWidth: 60, customHeight: 80, border: false)
                            .shadow(color: .white, radius: viewModel.isFieldFocused(at: index) ? 10 : 0)
                            .scaleEffect(viewModel.idStack[index].isAnimating ? (isFocused ? 0.97 : 0.8) : 1)
                            .onLongPressGesture(minimumDuration: .infinity, perform: {}) { inProgress in
                                withAnimation(.spring(duration: inProgress ? 0.13 : 0.2, bounce: inProgress ? 0.8 : 0.85)) {
                                    viewModel.choiceAnimation(selected: index, inProgress)
                                }
                                if !inProgress { viewModel.focusField =  viewModel.getFirstViableFocusField(selected: index) }
                                isFocused = true
                            }
                        
                        // Used to differentiate "zero" from letter "o" DO NOT DELETE
                        Text("/")
                            .font(.system(size: 40))
                            .opacity(viewModel.idStack[index].char == "0" ? 1 : 0)
                            .scaleEffect(viewModel.idStack[index].isAnimating ? (isFocused ? 0.95 : 0.8) : 1)
                            .offset(x: -0.5, y: -2.5)
                    }
                    
                }
                
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.black.opacity(0.1))
            }
            
        }
        .onChange(of: viewModel.string) { oldValue, newValue in
            viewModel.editIdStack(oldValue, newValue)
            withAnimation(.spring(duration: 0.13, bounce: 0.8)) { viewModel.editFocus() }
        }
        .onChange(of: isFocused) { viewModel.focusField = $1 ? viewModel.focusField : nil }
    }
}



#Preview {
    struct Preview: View {
        
        var body: some View {
            ZStack {
                Color
                    .red
                    .opacity(0.85)
                    .ignoresSafeArea()
                VStack {
                    RoomIDTextField(viewModel: JoinRoomViewModel())
                }
            }
        }
    }
    
    return Preview()
}

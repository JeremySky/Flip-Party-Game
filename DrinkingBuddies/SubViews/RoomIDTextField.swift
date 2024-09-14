//
//  RoomIDTextField.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI


struct RoomIDTextField: View {
    
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
    
    let submit: (String) -> Void = { _ in }
    
    @State var idStack: [(char: Character?, isAnimating: Bool)] = Array(repeating: (nil, false), count: FocusField.count)
    @State var string: String = "-"
    
    @FocusState var isFocused: Bool
    @State var focusField: FocusField?
    
    
    var body: some View {
        ZStack {
            TextField("", text: $string)
                .frame(width: 0, height: 0).offset(y: 700) // HIDE
                .focused($isFocused).opacity(0)
                .onSubmit {
                    if !idStack.contains(where: { $0.char == nil }) { return submit(getID()) }
                    
                    if let unwrappedFocusField = focusField {
                        focusField = idStack[unwrappedFocusField.index].char != nil ? unwrappedFocusField.next : focusField
                    }
                }
            
            HStack(spacing: 15) {
                
                ForEach(0..<idStack.count, id: \.self) { index in
                    ZStack {
                        Text(String(idStack[index].char ?? "-"))
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                            .cardStyle(customWidth: 60, customHeight: 80, border: false)
                            .shadow(color: .white, radius: isFieldFocused(at: index) ? 10 : 0)
                            .scaleEffect(idStack[index].isAnimating ? (isFocused ? 0.97 : 0.8) : 1)
                            .onLongPressGesture(minimumDuration: .infinity, perform: {}) { inProgress in
                                withAnimation(.spring(duration: inProgress ? 0.13 : 0.2, bounce: inProgress ? 0.8 : 0.85)) {
                                    choiceAnimation(selected: index, inProgress)
                                }
                                if !inProgress { focusField =  getFirstViableFocusField(selected: index) }
                                isFocused = true
                            }
                        Text("/")
                            .font(.system(size: 40))
                            .opacity(idStack[index].char == "0" ? 1 : 0)
                            .scaleEffect(idStack[index].isAnimating ? (isFocused ? 0.95 : 0.8) : 1)
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
        .onChange(of: string) { editIDStack($0, $1) }
    }
    private func getID() -> String {
        let arr = idStack.compactMap({ $0.char })
        let str = String(arr)
        
        print("ID to Submit: \(String(str.count == 4 ? str : "ERROR"))")
        return str.count == 4 ? str : "ERROR"
    }
    
    private func editIDStack(_ oldValue: String, _ newValue: String) {
        if newValue.isEmpty { return string = "-" }
        
        let isInput = newValue.count > oldValue.count
        let isDelete = newValue.count < oldValue.count
        
        if let focusField {
            
            
            if isDelete || newValue == "-" {
                if idStack[focusField.index].char != nil {
                    idStack[focusField.index].char = nil
                } else {
                    self.focusField = focusField.previous
                }
            } else if isInput && (newValue.last?.isNumber == true || newValue.last?.isLetter == true){
                idStack[focusField.index].char = newValue.uppercased().last
                self.focusField = focusField.next
            }
        
        }
    }
    
    private func isFieldFocused(at index: Int) -> Bool {
        if let fieldIndex = focusField?.index {
            return fieldIndex == index
        }
        return false
    }
    
    private func getFocusField(at index: Int) -> FocusField {
        switch index {
        case 0:
            FocusField.one
        case 1:
            FocusField.two
        case 2:
            FocusField.three
        default:
            FocusField.four
        }
    }
    
    private func getFirstViableFocusField(selected index: Int) -> FocusField {
        let firstViableIndex = idStack.filter({ $0.char != nil }).count
        
        if index > firstViableIndex {
            return getFocusField(at: firstViableIndex)
        }
        
        return getFocusField(at: index)
    }
    
    private func choiceAnimation(selected index: Int, _ isAnimating: Bool) {
        let firstViableIndex = idStack.filter({ $0.char != nil }).count
        
        if index > firstViableIndex {
            self.idStack = idStack.map({ ($0.char, isAnimating) })
        } else {
            self.idStack[index].isAnimating = isAnimating
        }
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
                    RoomIDTextField()
                }
            }
        }
    }
    
    return Preview()
}

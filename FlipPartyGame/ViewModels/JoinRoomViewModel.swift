//
//  JoinRoomViewModel.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/18/24.
//

import Foundation

@MainActor
class JoinRoomViewModel: ObservableObject {
    
    @Published var idStack: [(char: Character?, isAnimating: Bool)] = Array(repeating: (nil, false), count: FocusField.count)
    @Published var string: String = "-"
    @Published var focusField: FocusField?
    
    var roomIdIsValid: Bool {
        !idStack.contains(where: { $0.char == nil })
    }
    
    
    
    func isFieldFocused(at index: Int) -> Bool {
        if let fieldIndex = focusField?.index {
            return fieldIndex == index
        }
        return false
    }
    
    func editIdStack(_ oldValue: String, _ newValue: String) {
        
        if newValue.isEmpty { return string = "-" }
        
        let isInput = newValue.count > oldValue.count
        let isDelete = newValue.count < oldValue.count
        
        if let unwrappedField = focusField {
            
            
            if isDelete || newValue == "-" {
                if idStack[unwrappedField.index].char != nil {
                    idStack[unwrappedField.index].char = nil
                } else {
                    focusField = unwrappedField.previous
                }
            } else if isInput && (newValue.last?.isNumber == true || newValue.last?.isLetter == true){
                idStack[unwrappedField.index].char = newValue.uppercased().last
                focusField = unwrappedField.next
            }
        }
    }
    
    func editFocus() {
        
        if let unwrappedField = focusField {
            idStack[focusField?.index ?? unwrappedField.index].isAnimating = true
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.135) {
                self.idStack[self.focusField?.index ?? unwrappedField.index].isAnimating = false
            }
        }
    }
    
    
    func getId() -> String {
        let arr = idStack.compactMap({ $0.char })
        let str = String(arr)
        
        print("ID to Submit: \(String(str.count == 4 ? str : "ERROR"))")
        return str.count == 4 ? str : "ERROR"
    }
    
    func getFirstViableFocusField(selected index: Int) -> FocusField {
        let firstViableIndex = idStack.filter({ $0.char != nil }).count
        
        if index > firstViableIndex {
            return getFocusField(at: firstViableIndex)
        }
        
        return getFocusField(at: index)
    }
    
    func choiceAnimation(selected index: Int, _ isAnimating: Bool) {
        let firstViableIndex = idStack.filter({ $0.char != nil }).count
        
        if index > firstViableIndex {
            self.idStack = idStack.map({ ($0.char, isAnimating) })
        } else {
            self.idStack[index].isAnimating = isAnimating
        }
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
}

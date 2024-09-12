//
//  RoomIDTextField.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI

class RoomIDTextFieldViewModel: ObservableObject {
    
    @Published var roomID: String
    
    init(roomID: String = "") {
        self.roomID = roomID
    }
    
    
    private func textfieldIsMaxed() -> Bool { roomID.count >= 7 }
    
    func formatText(_ oldValue: String, _ newValue: String) {
        // Safely unwrap newChar
        guard let newChar = newValue.last else { return }
        // First character != "-"
        guard newChar != "-" || !oldValue.isEmpty else { return roomID = "" }
        // Guards against non-AlphaNumeric (excluding marker "-")
        guard newChar.isLetter || newChar.isNumber || newChar == "-" else { return roomID = oldValue /* with error */ }
        
        
        let isAddingChar = newValue.count > oldValue.count
        
        if isAddingChar {
            
            // Change Display Text
            if textfieldIsMaxed() {
                if newChar == "-" { return roomID = oldValue }
                var string = newValue
                
                //Remove all characters after startIndex
                let startIndex = string.index(string.startIndex, offsetBy: 6)
                string.removeSubrange(startIndex..<string.endIndex)
                
                self.roomID = string + String(newChar)
                
                
            } else if newChar != "-" {
                
                var newCharPrefixedWithMarker: String? = nil
                
                if oldValue.last != "-" && !oldValue.isEmpty { newCharPrefixedWithMarker = "-" + String(newChar)  }
                
                self.roomID = oldValue + (newCharPrefixedWithMarker ?? String(newChar))
                
                if self.roomID.count < 6 {
                    self.roomID += "-"
                }
                
                
                
            }
        }
        
    }
    
}

struct RoomIDTextField: View {
    
    @StateObject var viewModel = RoomIDTextFieldViewModel()
    @State var temp: String = "String"
    
    @State var isFocusedArray: [Bool] = Array(repeating: false, count: 4)
    @FocusState var isFocused: Bool
    @State var isTargetedTextFill: Bool = false
    
    @State var isLongPressArray: [Bool] = Array(repeating: false, count: 4)
    @State var scaleAll: Bool = false
    
    
    var body: some View {
        VStack {
            
            ZStack {
                
                // Hidden Textfield...
                Group {
                    TextField("Room ID", text: $viewModel.roomID)
                        .opacity(0)
                        .focused($isFocused)
                        .multilineTextAlignment(.center)
                        .frame(width: 150)
                }
                
                HStack(spacing: 15) {
                    ForEach(0..<4) { index in
                        RoomIDBox(getCharacter(at: index), $isFocusedArray[index])
                            .scaleEffect(isLongPressArray[index] ? 0.95 : 1)
                            .onLongPressGesture(minimumDuration: .infinity) {
                                withAnimation(.spring(duration: 0.13, bounce: 0.8)) {
                                    if index != 0 && index > (viewModel.roomID.count / 2) {
                                        scaleAll = true
                                    } else {
                                        isLongPressArray[index] = false
                                    }
                                }
                                
                            } onPressingChanged: { inProgress in
                                withAnimation(.spring(duration: inProgress ? 0.13 : 0.2, bounce: inProgress ? 0.8 : 0.85)) {
                                    if index != 0 && index > (viewModel.roomID.count / 2) {
                                        scaleAll = inProgress
                                    } else {
                                        isLongPressArray[index] = inProgress
                                    }
                                }
                                
                                if !inProgress {
                                    
                                    isFocused = true
                                    var newFocus: [Bool] = [false, false, false, false]
                                    var newFocusIndex: Int = (viewModel.roomID.count / 2)
                                    
                                    if viewModel.roomID.isEmpty {
                                        isFocusedArray[0] = true
                                    } else if index > newFocusIndex {
                                        newFocus[newFocusIndex] = true
                                        isFocusedArray = newFocus
                                    } else {
                                        newFocus[index] = true
                                        isFocusedArray = newFocus
                                    }
                                    
                                }
                            }
                    }
                }
                .scaleEffect(scaleAll ? 0.95 : 1)
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.black.opacity(0.1))
                }
            }
            
            Text(viewModel.roomID.isEmpty ? "TextField is Empty" : viewModel.roomID)
            Text(temp)
        }
        .onChange(of: isFocused) { oldValue, newValue in
            changeFocusAfterIsFocusEdit(oldValue, newValue)
        }
        .onChange(of: viewModel.roomID) { oldValue, newValue in
            viewModel.formatText(oldValue, newValue)
            changeFocusAfterTextEdit(oldValue, newValue)
        }
        .onChange(of: viewModel.roomID) { oldValue, newValue in
            temp = viewModel.roomID.isEmpty ? "String" : newValue.components(separatedBy: "-").joined()
        }
    }
    
    func getCharacter(at index: Int) -> Character {
        
        let idArray = viewModel.roomID.components(separatedBy: "-")
        let indexOutOfRange = idArray.count <= index
        if indexOutOfRange { return "-" }
        
        let char = idArray[index].first
        return char ?? "-"
    }
    
    func changeFocusAfterIsFocusEdit(_ oldValue: Bool, _ newValue: Bool) {
        
        var newFocus = [false, false, false, false]
        
        if newValue == true {
            switch viewModel.roomID.count {
            case 0:
                newFocus[0] = true
            case 1, 2:
                newFocus[1] = true
            case 3, 4:
                newFocus[2] = true
            case 5, 6:
                newFocus[3] = true
            default:
                newFocus[3] = true
            }
        }
        
        isFocusedArray = newFocus
        
    }
    
    func changeFocusAfterTextEdit(_ oldValue: String, _ newValue: String) {
        
        var newFocus = [false, false, false, false]
        
        if newValue.count > oldValue.count {
            // Change Focus
            switch newValue.count {
            case 0:
                newFocus[0] = true
            case 2:
                newFocus[1] = true
            case 4:
                newFocus[2] = true
            case 6:
                newFocus[3] = true
            default:
                newFocus[3] = true
            }
            
            
            
        } else {
            // Change Focus
            switch newValue.count {
            case 0, 1:
                newFocus[0] = true
            case 2, 3:
                newFocus[1] = true
            case 4, 5:
                newFocus[2] = true
            case 6, 7:
                newFocus[3] = true
            default:
                newFocus[3] = true
            }
        }
        
        isFocusedArray = newFocus
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

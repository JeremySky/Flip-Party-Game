//
//  RoomIDTextField.swift
//  DrinkingBuddies
//
//  Created by Jeremy Manlangit on 9/10/24.
//

import SwiftUI

struct RoomIDTextField: View {
    
    @State var roomID: String = ""
    @State var temp: String = "String"
    
    @State var isFocusedArray: [Bool] = [false, false, false, false]
    @FocusState var isFocused: Bool
    
    private func textfieldIsMaxed() -> Bool { roomID.count >= 7 }
    
    var body: some View {
        VStack {
            
            HStack(spacing: 15) {
                ForEach(0..<4) { index in
                    SingleBoxTextField(getCharacter(at: index), $isFocusedArray[index])
                }
            }
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.black.opacity(0.1))
            }
            
            TextField("Room ID", text: $roomID)
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .frame(width: 150)
                .onChange(of: isFocused, { oldValue, newValue in
                    
                    var newFocus = [false, false, false, false]
                    
                    if newValue == true {
                        switch roomID.count {
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
                    
                    
                })
                .onChange(of: roomID) { oldValue, newValue in
                    
                    // Safely unwrap newChar
                    guard let newChar = newValue.last else { return }
                    // First character != "-"
                    guard newChar != "-" || !oldValue.isEmpty else { return roomID = "" }
                    // Guards against non-AlphaNumeric (excluding marker "-")
                    guard newChar.isLetter || newChar.isNumber || newChar == "-" else { return roomID = oldValue /* with error */ }
                    
                    
                    var isAddingChar = newValue.count > oldValue.count
                    var newFocus = [false, false, false, false]
                    
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
            
            Text(temp)
        }
        .onChange(of: roomID) { oldValue, newValue in
            temp = roomID.isEmpty ? "String" : newValue.components(separatedBy: "-").joined()
        }
    }
    
    func getCharacter(at index: Int) -> Character {
        
        let idArray = roomID.components(separatedBy: "-")
        let indexOutOfRange = idArray.count <= index
        if indexOutOfRange { return "-" }
        
        let char = idArray[index].first
        return char ?? "-"
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

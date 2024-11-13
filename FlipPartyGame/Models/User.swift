//
//  User.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/18/24.
//

import Foundation
import SwiftUI


struct User: Identifiable, Hashable {
    let id: UUID
    var name: String
    var icon: IconSelection
    var color: ColorSelection
    
    init(id: UUID = UUID(), name: String, icon: IconSelection, color: ColorSelection) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
    }
    
    static var test1 = User(name: "Jeremy", icon: .cocktailGreen, color: .green)
    static var test2 = User(name: "Sam", icon: .barrel, color: .blue)
    static var test3 = User(name: "Trevor", icon: .cocktailPink, color: .black)
    static var test4 = User(name: "Balto", icon: .beerCan, color: .red)
    
    static var testDic: [Int:User?] = [
        1:.test1,
        2:.test2,
        3:.test3,
        4:.test4
    ]
    
    static var testArr: [User] = [.test1, .test2, .test3, .test4]
}

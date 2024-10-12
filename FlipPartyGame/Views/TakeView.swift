//
//  TakeView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/2/24.
//

import SwiftUI

struct TakeView: View {
    
    let user: User = .test1
    @State var count: Int = 10
    
    @State var degree: Double = 0
    private let durationAndDelay: Double = 0.19
    @State var countdownHasBegun: Bool = false
    
    var body: some View {
        VStack {
            Header(player: user, type: .take)
            Spacer()
            
            ZStack {
                Circle()
                    .frame(width: 215)
                    .foregroundStyle(user.color.value)
                    .overlay(Circle().foregroundStyle(.black.opacity(0.2)))
                Text("\(count)")
                    .font(.system(size: 140, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
            }
            .rotation3DEffect(.degrees(degree), axis: (x: 0.0, y: 1.0, z: 0.0))
            
            Spacer()
            ZStack {
                Button("Start", action: {
                    startCountdown()
                })
                .buttonStyle(ColorBackground(!countdownHasBegun, user.color.value))
                .opacity(countdownHasBegun ? 0 : 1)
                .zIndex(countdownHasBegun ? 0 : 1)
                
                Button("Continue", action: {
                    // Next
                })
                .buttonStyle(ColorBackground(count == 0, user.color.value))
                .zIndex(countdownHasBegun ? 1 : 0)
            }
        }
    }
    
    private func startCountdown() {
        countdownHasBegun = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdown(timer)
        }
    }
    
    private func countdown(_ timer: Timer) {
        guard count > 0 else {
            timer.invalidate()
            // Backend - count
            return
        }
        
        withAnimation(.linear(duration: durationAndDelay)) { degree = -90 }
        DispatchQueue.main.asyncAfter(deadline: (.now() + durationAndDelay)) {
            degree = 90
            count -= 1
            withAnimation(.linear(duration: durationAndDelay)) { degree = 0 }
        }
    }
}

#Preview {
    TakeView()
}

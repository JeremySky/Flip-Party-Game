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
    
    // ANIMATION PROPERTIES...
    @State var countdownHasBegun: Bool = false
    @State var degree: Double = 0
    private let durationAndDelay: Double = 0.19
    
    var body: some View {
        VStack {
            Header(player: user, type: .take)
            Spacer()
            
            ZStack {
                Circle()
                    .frame(width: 215)
                    .foregroundStyle(user.color.value)
                    .overlay(Circle().foregroundStyle(LinearGradient(colors: [.black.opacity(0.4), .clear], startPoint: .center, endPoint: .bottom))
                    )
                    .rotation3DEffect(.degrees(degree), axis: (x: 0.0, y: 1.0, z: 0.0))
                
                Text("\(count)")
                    .font(.system(size: 140, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .rotation3DEffect(.degrees(degree), axis: (x: 0.0, y: 1.0, z: 0.0))
            }
            
            Spacer()
            
            actionButtons()
                .padding(.horizontal, 40)
        }
    }
    
    @ViewBuilder
    private func actionButtons() -> some View {
        if countdownHasBegun {
            Button("Continue", action: {})
                .buttonStyle(ColorBackground(count == 0, user.color.value))
        } else {
            Button("Start", action: { startCountdown() })
                .buttonStyle(ColorBackground(!countdownHasBegun, user.color.value))
        }
    }
    
    private func startCountdown() {
        
        countdownHasBegun = true
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdown(timer)
        }
        
        func countdown(_ timer: Timer) {
            guard count > 0 else { return timer.invalidate() }
            
            withAnimation(.linear(duration: durationAndDelay)) { degree = -90 }
            
            DispatchQueue.main.asyncAfter(deadline: (.now() + durationAndDelay)) {
                degree = 90
                count -= 1
                withAnimation(.linear(duration: durationAndDelay)) { degree = 0 }
            }
        }
    }
    
}

#Preview {
    TakeView()
}

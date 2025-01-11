//
//  StandbyView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import SwiftUI

struct StandbyView: View {
    
    @EnvironmentObject var gameManager: GameManager
    
    // Animation Properties...
    @State var selectedPlayer: User
    @State var currentCardOpacity: (revealed: Double, hidden: Double) = (0, 1)
    @State var resultsOverviewOffset: (selected: CGFloat, result: CGFloat) = (90 , -90)

    
    var body: some View {
        VStack {
            
            //MARK: -- HEADER...
            Header(type: .currentPlayer(gameManager.currentPlayer))

            
            //MARK: -- PLAYERS OVERVIEW...
            VStack {
                ForEach(Array(gameManager.players.enumerated()), id: \.offset) { playerNum, player in
                    
                    Button(action: { selectedPlayer = player }) {
                        overview(of: player, playerNum)
                            .scaleEffect(player.id == selectedPlayer.id ? 1 : 0.9)
                    }
                    .buttonStyle(CustomAnimation())
                    .padding(.vertical, selectedPlayer == player ? 2 : 8)
                }
            }
            .frame(maxHeight: .infinity)
            
            
            //MARK: -- RESULTS OVERVIEW...
            HStack {
                selected()
                    .offset(x: resultsOverviewOffset.selected)
                    .frame(width: 70, height: 70)
                    .zIndex(1)
                currentCard()
                    .zIndex(1.1)
                result()
                    .offset(x: resultsOverviewOffset.result)
                    .frame(width: 70, height: 70)
                    .zIndex(1)
            }
        }
        .onChange(of: gameManager.result) { _, _ in
            
            withAnimation(.bouncy(duration: 0.5)) {
                selectedPlayer = gameManager.currentPlayer
                resultsOverviewOffset.selected = 0
            }
            withAnimation(.bouncy(duration: 0.5).delay(1)) {
                currentCardOpacity.hidden = 0
                currentCardOpacity.revealed = 1
            }
            withAnimation(.bouncy(duration: 0.8).delay(2)) {
                resultsOverviewOffset.result = 0
            }
        }
    }
    
    
    @ViewBuilder
    private func overview(of player: User, _ playerNum: Int) -> some View {
        HStack {
            Image(player.icon.string)
                .resizable()
                .scaledToFit()
                .padding(2)
                .background(
                    Circle().foregroundColor(.white.opacity(0.4))
                )
                .padding(.vertical, 6)
                .opacity(player.id == selectedPlayer.id ? 1 : 0.7)
            
            ForEach(0..<4) { cardPosition in
                let deckIndex: Int = playerNum + (cardPosition * 4)
                let card: Card = gameManager.deck[deckIndex]
                
                if deckIndex == gameManager.currentCardIndex {
                    
                    //MARK: CURRENT CARD...
                    ZStack {
                        //revealed...
                        MiniFrontView(card)
                            .opacity(currentCardOpacity.revealed)
                        //hidden...
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 10, dash: [5]))
                            .cardStyle(customWidth: 60, customHeight: 60, border: false)
                            .opacity(currentCardOpacity.hidden)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.yellow, lineWidth: 3)
                        )
                    .scaleEffect(1.1)
                    
                    
                } else if deckIndex < gameManager.currentCardIndex {
                    //MARK: FLIPPED CARDS...
                    MiniFrontView(card).opacity(player.id == selectedPlayer.id ? 1 : 0.7)
                    
                    
                } else {
                    //MARK: UNKNOWN CARDS...
                    BackView(cardSize: .mini)
                        .opacity(0.6)
                }
            }
        }
        .padding(.horizontal)
        .frame(height: 85)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(player.color.value.opacity(player.id == selectedPlayer.id ? 1 : 0.4))
        )
    }
    
    @ViewBuilder
    private func selected() -> some View {
        
        if let selected = gameManager.questionSelection {
            
            ZStack {
                //image... (questions 2 - 4)
                if let imageString = selected.imageString {
                    Image(systemName: imageString)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .foregroundStyle(selected.color)
                        .fontWeight(selected.isHeavy ? .heavy : .medium)
                        .frame(width: 55, height: 55)
                    
                //text... (question 1)
                } else {
                    Text(selected.rawValue)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(selected == .black || selected == .red ? selected.color : .clear)
                        .frame(width: 70, height: 70)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(.gray)
                }
            )
        }
    }
    
    @ViewBuilder
    private func currentCard() -> some View {
        let currentCard = gameManager.getCurrentCard()
        ZStack {
            
            //revealed...
            ZStack {
                Image(systemName: currentCard.imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(currentCard.color)
                Text(currentCard.text)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(12)
            .frame(width: 100, height: 100)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(.gray)
                }
            )
            .opacity(currentCardOpacity.revealed)
            
            
            //hidden...
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.clear)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 10, dash: [5]))
                        .foregroundStyle(.black)
                )
                .cardStyle(customWidth: 100, customHeight: 100, border: false)
                .opacity(currentCardOpacity.hidden)
        }
    }
    
    @ViewBuilder
    private func result() -> some View {
        
        if let result = gameManager.result {
            Text(result ? "👍" : "👎")
                .font(.system(size: 45))
                .frame(width: 70, height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(.gray)
                )
        }
    }
}


#Preview {
    struct StandbyViewPreview: View {
        
        @State var gameManager: GameManager
        
        init(cardIndex: Int) {
            self.gameManager = .preview(cardIndex: cardIndex)
        }
        
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                StandbyView(selectedPlayer: gameManager.currentPlayer)
                Button("TEST") {
                    gameManager.questionSelection = .red
                    gameManager.result = true
                }
                .padding()
            }
                .environmentObject(gameManager)
        }
    }
    
    return StandbyViewPreview(cardIndex: 1)
}

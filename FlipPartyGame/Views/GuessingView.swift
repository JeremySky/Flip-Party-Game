//
//  GuessingView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 9/30/24.
//

import SwiftUI

struct GuessingView: View {
    
    // Device/App Property...
    let user: User = User.test1
    
    @StateObject var viewModel: GuessingViewModel
    
    // Animation Properties...
    @State var overviewCurrentCardOpacity: (revealed: Double, hidden: Double) = (0, 0.6)
    @State var currentCardOffset: CGFloat = 0
    @State var selectionOffset: CGFloat = 0
    @State var resultOffset: CGFloat = 200
    
    
    var body: some View {
        VStack {
            
            //MARK: -- HEADER
            Header(player: viewModel.getCurrentPlayer(), type: .currentPlayer)
            
            
            //MARK: -- HAND OVERVIEW...
            handOverview()
                .padding(.top)
            
            
            //MARK: -- CURRENT CARD...
            Button(action: { viewModel.flipCard() }) {
                CardView(card: viewModel.getCurrentCard(), style: .standard, isFlipped: $viewModel.isFlipped)
            }
            .disabled(viewModel.selection == nil || viewModel.isFlipped)
            .buttonStyle(CustomAnimation())
            .frame(maxHeight: .infinity)
            .offset(x: currentCardOffset)
            
            
            ZStack {
                //MARK: -- SELECTIONS...
                HStack(spacing: 15) {
                    ForEach(viewModel.phase.selections, id: \.self) { selection in
                        
                        selectionButton(for: selection)
                            .disabled(viewModel.isFlipped)
                        
                    }
                }
                .offset(y: selectionOffset)
                
                
                //MARK: -- RESULTS...
                if let selection = viewModel.selection, let isCorrect = viewModel.isCorrect {
                    HStack {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(viewModel.phase == .one ? selection.color : .white)
                                .frame(width: 70, height: 70)
                                .shadow(color: isCorrect ? .green : .red, radius: 5)
                            
                            if let imageString = selection.imageString {
                                Image(systemName: imageString)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(4)
                                    .foregroundStyle(selection.color)
                                    .fontWeight(selection.isHeavy ? .heavy : .medium)
                                    .frame(width: 55, height: 55)
                            } else {
                                Text(selection.rawValue)
                                    .font(.system(size: 22, weight: .black, design: .rounded))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        Text(isCorrect ? "👍" : "👎")
                            .font(.system(size: 40))
                    }
                    .offset(y: resultOffset)
                }
            }
            .frame(height: 100)
            .padding(.bottom)
            
            
        }
        .onChange(of: viewModel.isFlipped) { _, isFlipped in
            // MARK: -- OVERVIEW ANIMATION...
            withAnimation(.linear.delay(0.6)) {
                overviewCurrentCardOpacity.revealed = 1
                overviewCurrentCardOpacity.hidden = 0
            }
            
            // MARK: -- SELECTION ANIMATION...
            withAnimation {
                selectionOffset = 200
            }
            
            // MARK: -- RESULTS ANIMATION...
            withAnimation(.easeOut.delay(0.6)) {
                resultOffset = 0
            }
            
            // MARK: -- CURRENT CARD ANIMATION
            withAnimation(.easeIn.delay(1.8)) {
                currentCardOffset = -400
            }
        }
    }
    
    @ViewBuilder
    private func handOverview() -> some View {
        HStack(spacing: 15) {
            ForEach(1..<5) { cardPosition in
                if cardPosition == viewModel.getHandCount() {
                    
                    //MARK: CURRENT CARD...
                    ZStack {
                        //revealed...
                        MiniFrontView(viewModel.getCurrentCard())
                            .opacity(overviewCurrentCardOpacity.revealed)
                        //hidden...
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 10, dash: [5]))
                            .cardStyle(customWidth: 60, customHeight: 60, border: false)
                            .opacity(overviewCurrentCardOpacity.hidden)
                    }
                    
                    
                } else if cardPosition < viewModel.getHandCount() {
                    //MARK: FLIPPED CARDS...
                    MiniFrontView(viewModel.getCurrentCard())
                    
                    
                } else {
                    //MARK: UNKNOWN CARDS...
                    BackView(cardSize: .mini)
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectionButton(for selection: GamePhase.Selections) -> some View {
        Button(action: {
            viewModel.selection = viewModel.selection == selection ? nil : selection
        }, label: {
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(viewModel.phase == .one ? selection.color : .white)
                    .frame(width: 70, height: 70)
                    .shadow(color: selection == viewModel.selection ? .yellow : .black.opacity(0.5), radius: 5)
                
                if let imageString = selection.imageString {
                    Image(systemName: imageString)
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .foregroundStyle(selection.color)
                        .fontWeight(selection.isHeavy ? .heavy : .medium)
                        .frame(width: 55, height: 55)
                } else {
                    Text(selection.rawValue)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            
        })
        .buttonStyle(CustomAnimation())
    }
    
    @ViewBuilder
    private func iconLabel(selection: GamePhase.Selections) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .frame(width: 75, height: 75)
                .shadow(color: selection == viewModel.selection ? .yellow : .black.opacity(0.5), radius: 5)
            Image(systemName: selection.imageString!)
                .resizable()
                .scaledToFit()
                .padding(4)
                .foregroundStyle(selection.color)
                .fontWeight(selection.isHeavy ? .heavy : .medium)
                .frame(width: 55, height: 55)
        }
    }
    
    @ViewBuilder
    private func textLabel(selection: GamePhase.Selections) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .frame(width: 75, height: 75)
                .shadow(color: selection == viewModel.selection ? .yellow : .black.opacity(0.5), radius: 5)
            Text(selection.rawValue)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(selection.color)
                .frame(width: 55, height: 55)
        }
    }
    
}

#Preview {
    
    struct GuessingPreview: View {
        
        var manager : GameManager
        var viewModel: GuessingViewModel
        
        init() {
            let deck = Card.shuffledDeck
            let i = 0
            self.manager = GameManager(phase: .one, currentPlayer: User.test1, deck: deck, deckIndex: i, hand: [deck[i]])
            self.viewModel = GuessingViewModel(gameManager: manager)
        }
        
        var body: some View {
            GuessingView(viewModel: viewModel)
        }
    }
    
    return GuessingPreview()
}

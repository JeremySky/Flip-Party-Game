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
    @State var selectionOpacity: Double = 1
    @State var resultOffset: CGFloat = 0
    @State var resultOpacity: Double = 0
    
    
    var body: some View {
        VStack {
            
            //MARK: -- HEADER
            Header(type: .guessing)
            
            
            //MARK: -- HAND OVERVIEW...
            handOverview()
                .padding(.top)
            
            
            //MARK: -- CURRENT CARD...
            Button(action: {
                withAnimation {
                    viewModel.flipCard()
                }
            }) {
                CardView(card: viewModel.currentCard, style: .standard, isFlipped: $viewModel.isFlipped)
            }
            .disabled(viewModel.selectedAnswer == nil || viewModel.isFlipped)
            .buttonStyle(CustomAnimation())
            .frame(maxHeight: .infinity)
            
            
            ZStack {
                
                result()
                    .offset(x: resultOffset)
                    .opacity(resultOpacity)
                
                //MARK: -- SELECTIONS...
                HStack(spacing: 18) {
                    ForEach(Array(viewModel.question.selections.enumerated()), id: \.offset) { i, selection in
                        
                        selectionButton(for: selection)
                            .disabled(viewModel.isFlipped)
                            .offset(x: viewModel.isFlipped ? selection.offset : 0)
                            .zIndex(viewModel.selectedAnswer == selection ? 1 : 0)
                            .opacity(viewModel.selectedAnswer == selection ? 1 : selectionOpacity)
                            .offset(x: -resultOffset)
                            .scaleEffect((viewModel.selectedAnswer == selection) && !viewModel.isFlipped ? 1.1 : 1)
                        
                    }
                }
            }
            .frame(height: 100)
            .padding(.bottom)
            
            
        }
        .onChange(of: viewModel.isFlipped) { _, isFlipped in
            // MARK: -- SELECTION OPACITY...
            withAnimation(.easeIn) {
                selectionOpacity = 0
            }
            
            // MARK: -- RESULTS...
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                withAnimation(.spring) {
                    resultOffset = ((QuestionSelection.frame + QuestionSelection.padding) / 2)
                }
                withAnimation {
                    resultOpacity = 1
                }
            }
            
            // MARK: -- OVERVIEW ANIMATION...
            withAnimation(.linear.delay(0.6)) {
                overviewCurrentCardOpacity.revealed = 1
                overviewCurrentCardOpacity.hidden = 0
            }
        }
    }
    
    
    
    @ViewBuilder
    private func result() -> some View {
        
        if let result = viewModel.isCorrect {
            Text(result ? "👍" : "👎")
                .font(.system(size: 45))
                .frame(width: QuestionSelection.frame, height: QuestionSelection.frame)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(.gray)
                )
        }
    }
    
    @ViewBuilder
    private func handOverview() -> some View {
        HStack(spacing: 15) {
            ForEach(1..<5) { cardPosition in
                
                if cardPosition == viewModel.hand.count {

                    //MARK: CURRENT CARD...
                    ZStack {
                        //revealed...
                        MiniFrontView(viewModel.currentCard)
                            .opacity(overviewCurrentCardOpacity.revealed)
                        //hidden...
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 10, dash: [5]))
                            .cardStyle(customWidth: 60, customHeight: 60, border: false)
                            .opacity(overviewCurrentCardOpacity.hidden)
                    }
                    .scaleEffect(1.2)


                } else if cardPosition < viewModel.hand.count {
                    //MARK: FLIPPED CARDS...
                    MiniFrontView(viewModel.hand[cardPosition - 1])


                } else {
                    //MARK: UNKNOWN CARDS...
                    BackView(cardSize: .mini)
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectionButton(for selection: QuestionSelection) -> some View {
        Button(action: {
            viewModel.selectedAnswer = viewModel.selectedAnswer == selection ? nil : selection
        }, label: {
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(viewModel.question == .one ? selection.color : .white)
                    .frame(width: QuestionSelection.frame, height: QuestionSelection.frame)
                    .shadow(color: selection == viewModel.selectedAnswer ? .yellow : .black.opacity(0.5), radius: 5)
                
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
}




#Preview {
    struct GuessingViewPreview: View {
        
        let currentCardIndex: Int
        
        var body: some View {
            let gameManager = GameManager.preview(cardIndex: currentCardIndex)
            let currentPlayer = gameManager.currentPlayer

            if gameManager.phase.question != nil{
                let viewModel = GuessingViewModel(gameManager: gameManager, user: currentPlayer)
                GuessingView(viewModel: viewModel)
            } else {
                Text("Should show next phase")
            }
        }
    }
    
    return GuessingViewPreview(currentCardIndex: 10)
}

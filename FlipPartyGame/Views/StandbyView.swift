//
//  StandbyView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/15/24.
//

import SwiftUI

class StandbyViewModel: ObservableObject {
    
    @Published var gameManager: GameManager
    @Published var currentCard: Card
    @Published var result: Bool?
    @Published var selected: Selection?
    
    let players: [User]
    
    
    init(gameManager: GameManager, currentCard: Card, result: Bool? = nil, selected: Selection? = nil, players: [User]) {
        self.gameManager = gameManager
        self.currentCard = currentCard
        self.result = result
        self.selected = selected
        self.players = players
    }
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
        self.currentCard = gameManager.getCurrentCard()
        self.result = nil
        self.selected = nil
        self.players = gameManager.players
    }
    
    func updateResultsOverview() {
        if let result = gameManager.result, let selected = gameManager.selected {
            self.result = result
            self.selected = selected
        }
    }
}


struct StandbyView: View {
    
    @StateObject var viewModel: StandbyViewModel
    var player: User = .test1
    
    // Animation Properties...
    @State var selectedPlayer: User
    @State var currentCardOpacity: (revealed: Double, hidden: Double) = (0, 1)
    @State var resultsOverviewOffset: (selected: CGFloat, result: CGFloat) = (90 , -90)

    
    var body: some View {
        VStack {
            
            //MARK: -- HEADER...
            Header(player: viewModel.gameManager.currentPlayer, type: .currentPlayer)

            
            //MARK: -- PLAYERS OVERVIEW...
            playersOverview()
            .frame(maxHeight: .infinity)
            
            
            //MARK: -- RESULTS OVERVIEW...
            HStack(spacing: 20) {
                selected()
                    .offset(x: resultsOverviewOffset.selected)
                    .zIndex(1)
                currentCard()
                    .zIndex(2)
                result()
                    .offset(x: resultsOverviewOffset.result)
                    .zIndex(1)
            }
        }
        .onChange(of: viewModel.gameManager.result) { oldValue, newValue in
            
            //fetch data from game manager to view model...
            viewModel.updateResultsOverview()
            
            withAnimation(.bouncy(duration: 0.5)) {
                selectedPlayer = viewModel.gameManager.currentPlayer
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
    private func playersOverview() -> some View {
        VStack(spacing: 15) {
            ForEach(Array(viewModel.players.enumerated()), id: \.offset) { playerNum, player in
                
                Button(action: { selectedPlayer = player }) {
                    overview(of: player, playerNum)
                        .scaleEffect(player.id == selectedPlayer.id ? 1 : 0.9)
                }
                .buttonStyle(CustomAnimation())
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
                let card: Card = viewModel.gameManager.deck[deckIndex]
                
                if deckIndex == viewModel.gameManager.currentCardIndex {
                    
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
                    
                    
                } else if deckIndex < viewModel.gameManager.currentCardIndex {
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
        
        if let selected = viewModel.selected {
            
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
        ZStack {
            
            //revealed...
            ZStack {
                Image(systemName: viewModel.currentCard.imageSystemName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(viewModel.currentCard.color)
                Text(viewModel.currentCard.text)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(12)
            .frame(width: 100, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
            )
            .cardStyle(customWidth: 100, customHeight: 100, border: true)
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
        .shadow(color: .gray.opacity(0.5),radius: 5)
    }
    
    @ViewBuilder
    private func result() -> some View {
        
        if let result = viewModel.result {
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
        @State var viewModel: StandbyViewModel
        
        init() {
            let players = User.testArr
            let deck = Card.shuffledDeck
            let currentCardIndex = 9
            
            let currentPlayer = players[currentCardIndex % players.count]
            
            var question: Question? {
                for question in Question.allCases {
                    let questionIndex = (currentCardIndex / players.count)
                    if question.index == questionIndex { return question }
                }
                
                return nil
            }
            
            var hands: [UUID:[Card]] {
                var data: [UUID:[Card]] = Dictionary(uniqueKeysWithValues: players.map { ($0.id, []) })
                var cardIndex = 0
                var playerIndex = 0
                
                while cardIndex < currentCardIndex {
                    
                    let id = players[playerIndex].id
                    
                    if data[id] != nil {
                        data[id]!.append(deck[cardIndex])
                    }
                    
                    playerIndex = (playerIndex + 1) % players.count
                    cardIndex += 1
                }
                
                return data
            }
            
            let gameManager = GameManager(players: players, currentPlayer: currentPlayer, deck: deck, currentCardIndex: currentCardIndex, hands: hands, question: question!)

            
            self.gameManager = gameManager
            self.viewModel = StandbyViewModel(gameManager: gameManager)
        }
        
        var body: some View {
            StandbyView(viewModel: viewModel, selectedPlayer: gameManager.currentPlayer)
        }
    }
    
    return StandbyViewPreview()
}

//
//
//#Preview {
//    struct StandbyPreview: View {
//        
//        @StateObject var manager: GameManager
//        @StateObject var viewModel: StandbyViewModel
//        
//        init() {
//            let question = Question.three
//            let deck = Card.shuffledDeck
//            let currentCardIndex = 9
//            let players = User.testArr
//            let currentPlayer = players[currentCardIndex % 4]
//            let hands = Dictionary(uniqueKeysWithValues: User.testArr.map { ($0.id, [Card(value: .ace, suit: .clubs)]) })
//            // Assigning the GameManager
//            let manager = GameManager(question: question, currentPlayer: currentPlayer, deck: deck, currentCardIndex: currentCardIndex, players: players, hands: hands)
//            // Create StandbyViewModel based on the GameManager
//            _manager = StateObject(wrappedValue: manager)
//            _viewModel = StateObject(wrappedValue: StandbyViewModel(gameManager: manager))
//        }
//        
//        var body: some View {
//            StandbyView(viewModel: viewModel, selectedPlayer: manager.currentPlayer)
//        }
//    }
//    
//    return StandbyPreview()
//}

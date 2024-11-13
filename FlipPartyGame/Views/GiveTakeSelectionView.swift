//
//  GiveTakeSelectionView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/23/24.
//

import SwiftUI


struct GiveTakeSelectionView: View {
    typealias StickerViewProperties = (type: Sticker, offset: CGSize, opacity: Double, zIndex: Double)
    
    @StateObject var viewModel: GiveTakeSelectionViewModel
    
    // Device/App Property...
    let user: User
    
    //Card animations....
    @State var isEnlarged: Bool = false
    @State var isFlipped: Bool = false
    
    //Sticker Animations...
    @State var stickerViewPropertiesArr: [StickerViewProperties]
    @State var disableGestures: Bool = false
    
    
    var body: some View {
        VStack {
            
            Header(player: user, type: .currentPlayer)
            
            VStack(spacing: 40) {
                
                handOverview()
                
                // MARK: -- Cards...
                giveTake()
                
                // MARK: -- Stickers...
                ZStack {
                    ForEach($stickerViewPropertiesArr, id: \.self.wrappedValue.type.rawValue) { $stickerData in
                        
                        getSticker(for: stickerData.type)
                            .modifier(
                                StickerDragModifier(
                                    stickerData: $stickerData,
                                    stickerDataArr: $stickerViewPropertiesArr,
                                    isEnlarged: $isEnlarged,
                                    isFlipped: $isFlipped,
                                    disableGestures: $disableGestures,
                                    selectAction: { viewModel.selectSticker($0) }
                                )
                            )
                        
                        
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
    
    
    @ViewBuilder
    private func handOverview() -> some View {
        HStack(spacing: 18) {
            ForEach(viewModel.hand, id: \.self) { card in
                MiniFrontView(card)
                    .scaleEffect(isFlipped && card.value == viewModel.card.value ? 1.2 : 1)
                    .opacity(isFlipped ? (card.value == viewModel.card.value ? 1 : 0.5) : 1)
                    .shadow(color: isFlipped && card.value == viewModel.card.value ? (viewModel.selectedSticker == .give ? .green : .red) : .clear, radius: 10)
            }
        }
    }
    
    @ViewBuilder
    func giveTake() -> some View {
        ZStack {
            // visual 2nd card, not functional at all...
            if stickerViewPropertiesArr.count > 1 {
                BackView(cardSize: .standard)
                    .scaleEffect(0.88)
                    .offset(x: 12, y: 10)
            }
            
            // actual card in play...
            CardView(card: viewModel.card, style: .standard, isFlipped: $isFlipped)
                .scaleEffect(isEnlarged ? 1 : 0.88)
        }
    }
    
    @ViewBuilder
    func getSticker(for sticker: Sticker) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .frame(width: QuestionSelection.frame, height: QuestionSelection.frame)
                .shadow(color: .black.opacity(0.5), radius: 5)
            
            Text(sticker.rawValue)
                .font(.system(size: 22, weight: .black, design: .rounded))
        }
    }
}


extension GiveTakeSelectionView {
    struct StickerDragModifier: ViewModifier {
        
        @Binding var stickerData: StickerViewProperties
        @Binding var stickerDataArr: [StickerViewProperties]
        @Binding var isEnlarged: Bool
        @Binding var isFlipped: Bool
        @Binding var disableGestures: Bool
        
        var selectAction: (Sticker) -> Void
        
        func body(content: Content) -> some View {
            content
                .opacity(stickerData.opacity)
                .offset(stickerData.offset)
                .zIndex(stickerData.zIndex)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if !disableGestures {
                                handleDragChange(gesture)
                            }
                        }
                        .onEnded { gesture in
                            if !disableGestures {
                                handleDragEnd(gesture)
                            }
                        }
                )
        }
        
        
        // MARK: - Drag Handlers
        private func handleDragChange(_ gesture: DragGesture.Value) {
            stickerData.zIndex = 2
            
            // Capture movement of gesture
            if stickerDataArr.count > 1 {
                stickerData.offset.width = gesture.translation.width + stickerData.type.offset.width
                stickerData.offset.height = gesture.translation.height
            } else {
                stickerData.offset = gesture.translation
            }
            
            // Animate card enlargement if within bounds
            withAnimation(.bouncy(duration: 0.3, extraBounce: 0.4)) {
                isEnlarged = withinBounds(stickerData.offset)
            }
        }
        
        private func handleDragEnd(_ gesture: DragGesture.Value) {
            //Helper Functions...
            func animateStickersOpacity() {
                // selected sticker fades out...
                withAnimation(.easeIn(duration: 0.1)) {
                    if let j = stickerDataArr.firstIndex(where: { $0.type == stickerData.type }) {
                        stickerDataArr[j].opacity = 0
                    }
                }
                // other dimmed...
                withAnimation(.linear(duration: 0.3)) {
                    if let i = stickerDataArr.firstIndex(where: { $0.type != stickerData.type }) {
                        stickerDataArr[i].opacity = 0.3
                    }
                }
            }
            func resetStickerPosition() {
                let duration = 0.4
                withAnimation(.bouncy(duration: duration, extraBounce: 0.2)) {
                    stickerData.offset = stickerDataArr.count == 2 ? stickerData.type.offset : .zero
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    stickerData.zIndex = 1
                }
            }
            
            //Ends Within Bounds...
            if withinBounds(gesture.translation) {
                
                //Set viewModel's selected / handle business logic...
                selectAction(stickerData.type)
                
                //Stickers...
                disableGestures = true
                animateStickersOpacity()
                
                //Card...
                withAnimation(.bouncy(duration: 0.35, extraBounce: 0.38)) {
                    isEnlarged = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation {
                        isFlipped = true
                    }
                }
                
                //Ends Outside Bounds...
            } else {
                resetStickerPosition()
            }
        }
        

        // MARK: - Bounds Check
        private func withinBounds(_ offset: CGSize) -> Bool {
            let isWithinHeightBounds = offset.height > -425 && offset.height < -65
            let isWithinWidthBounds = offset.width > -130 && offset.width < 130
            return isWithinHeightBounds && isWithinWidthBounds
        }
    }
}



#Preview {
    struct GiveTakeSelectionViewPreview: View {
        
        let currentCardIndex: Int
        
        var body: some View {
            let gameManager = GameManager.preview(cardIndex: currentCardIndex)
            
            if let remainingStickers = gameManager.phase.remainingStickers {
                let currentPlayer = gameManager.currentPlayer
                let viewModel = GiveTakeSelectionViewModel(gameManager: gameManager, remainingStickers: remainingStickers, user: currentPlayer)
                let stickerViewPropertiesArr: [GiveTakeSelectionView.StickerViewProperties] = remainingStickers.map({ ($0, remainingStickers.count == 2 ? $0.offset : .zero , 1, 1) })
                
                GiveTakeSelectionView(
                    viewModel: viewModel,
                    user: gameManager.currentPlayer,
                    stickerViewPropertiesArr: stickerViewPropertiesArr
                )
                
            } else {
                Text("Should show other phase")
            }
        }
    }
    
    return GiveTakeSelectionViewPreview(currentCardIndex: 51)
}

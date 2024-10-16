//
//  GiveView.swift
//  FlipPartyGame
//
//  Created by Jeremy Manlangit on 10/4/24.
//

import SwiftUI

struct GiveView: View {
    
    @StateObject var viewModel: GiveViewModel = GiveViewModel()
    @State var alertOffset: CGFloat = -250
    @State var tipsOpacity: Double = 0
    let user: User = .test1
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                //MARK: -- HEADER & ALERTS...
                ZStack {
                    Header(player: user, type: .give(viewModel.pointsRemaining))
                    
                    //ALERT
                    Text(viewModel.error?.localizedDescription ?? "")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.black.opacity(0.85))
                        )
                        .padding(8)
                        .offset(y: alertOffset)
                }
                
                //MARK: -- PLAYER SELECTION...
                VStack(spacing: 30) {
                    
                    ForEach(viewModel.players, id: \.self.id) { player in
                        
                        playerSelectButton(player, action: { viewModel.handlePlayerSelectAction(player) })
                        .padding(.horizontal)
                        
                    }
                }
                .frame(maxHeight: .infinity)
                
                
                //MARK: -- TIPS & BUTTONS...
                VStack(spacing: 0) {
                    
                    tips()
                    Spacer()
                    
                    
                    if viewModel.pointsRemaining == 0 && viewModel.selectedQueue.isEmpty {
                        
                        // GIVE BUTTON...
                        Button("Give") {
                            //
                        }
                        .buttonStyle(ColorBackground((viewModel.pointsRemaining == 0 && viewModel.selectedQueue.isEmpty), user.color.value))
                        .padding(.horizontal, 40)
                        .padding(.bottom)
                        
                        
                    } else {
                        
                        HStack(spacing: 8) {
                            
                            // QUICK DISTRIBUTE...
                            iconButton(systemName: viewModel.isQuickDistribute ? "bolt.circle.fill" : "bolt.circle", fontWeight: .ultraLight) {
                                viewModel.isQuickDistribute.toggle()
                                viewModel.selectedQueue = []
                            }
                            .frame(height: 60)
                            .padding(.bottom, 25)
                            
                            // CLEAR...
                            iconButton(systemName: "trash.circle", fontWeight: .ultraLight, action: { viewModel.removeAllPointsFromSelectedPlayers() })
                                .frame(height: 60)
                                .padding(.bottom, 25)
                            
                            // SUBTRACT & ADD || GIVE ALL & SPLIT
                            quantityControlButtons()
                        }
                    }
                }
                .frame(height: 130)
            }
        }
        //MARK: -- ANIMATION FOR ALERT
        .onChange(of: viewModel.error) { oldValue, newValue in
            if newValue != nil {
                withAnimation(.bouncy(duration: 0.28)) {
                    alertOffset = 0
                }
                withAnimation(.easeIn(duration: 0.3).delay(1.3)) {
                    alertOffset = -250
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3 + 0.3) {
                    viewModel.error = nil
                }
            }
        }
        //MARK: -- ANIMATION FOR TIPS
        .onChange(of: viewModel.isQuickDistribute) { _, isQuickDistribute in
            if isQuickDistribute {
                withAnimation {
                    tipsOpacity = 0.8
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        tipsOpacity = 0
                    }
                }
            }
        }
        .onChange(of: viewModel.pointsRemaining) { oldValue, newValue in
            if newValue == 0 {
                withAnimation {
                    tipsOpacity = 0.8
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        tipsOpacity = 0
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func playerSelectButton(_ player: User, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            
            HStack {
                
                //PLAYER INFO...
                HStack {
                    
                    Image(player.icon.string)
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                        .background( Circle().foregroundStyle(.white).opacity(0.3) )
                        .padding(5)
                        .padding(.leading, 12)
                    
                    Text(player.name)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                }
                .frame(height: 65)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundStyle(player.color.value)
                        .shadow(color: viewModel.selectedQueue.contains(where: { $0 == player.id }) ? .yellow : .black.opacity(0.5), radius: 5)
                )
                
                //POINTS...
                Text("\(viewModel.playerPoints[player.id] ?? 0)")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .frame(width: 70, height: 65)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: viewModel.selectedQueue.contains(where: { $0 == player.id })  ? .yellow : .black.opacity(0.5), radius: 5)
                    )
            }
        }
        .buttonStyle(CustomAnimation())
    }
    
    
    @ViewBuilder
    private func tips() -> some View {
        
        
        if viewModel.isQuickDistribute && viewModel.selectedQueue.count < 2 {
            
            Text("Select multiple players to split points evenly...")
                .font(.system(size: 15))
                .foregroundStyle(.gray.opacity(tipsOpacity))
            
            
        } else if viewModel.pointsRemaining == 0 && viewModel.selectedQueue.isEmpty {
            
            Text("Select a player to edit...")
                .font(.system(size: 15))
                .foregroundStyle(.gray.opacity(tipsOpacity))
            
            
        } else {
            EmptyView()
        }
    }
    
    
    @ViewBuilder
    private func iconButton(systemName: String, fontWeight: Font.Weight, action: @escaping () -> Void) -> some View {
        
        Button(action: action) {
            
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .fontWeight(fontWeight)
                .foregroundStyle(
                    Color(user.color.value).gradient
                )
            
        }
        .buttonStyle(CustomAnimation())
    }
    
    
    @ViewBuilder
    private func quantityControlButtons() -> some View {
        
        HStack(spacing: 8) {
            
            //QUICK DISTRIBUTE BUTTONS...
            if viewModel.isQuickDistribute {
                
                Button(action: { viewModel.quickDistributePoints() }) {
                    
                    HStack {
                        Text(viewModel.selectedQueue.count > 1 ? "Split" : "Give All")
                            .font(.system(size: 23, weight: .medium, design: .rounded))
                        
                        Image(systemName: viewModel.selectedQueue.count > 1 ? "arrowshape.turn.up.left.2" : "arrowshape.turn.up.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .padding(.bottom, 5)
                            .rotation3DEffect(
                                .degrees(180),
                                axis: (x: 0.0, y: 1.0, z: 0.0)
                            )
                    }
                    .frame(width: 170 ,height: 70)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .foregroundStyle(user.color.value.gradient)
                    )
                    .foregroundStyle(.white)
                }
                .buttonStyle(CustomAnimation())
                .padding(.bottom)
                
                
            //PLUS & MINUS BUTTONS...
            } else {
                
                HStack {
                    Group {
                        
                        iconButton(systemName: "minus.circle.fill", fontWeight: .bold, action: { viewModel.subtractPoint() })
                        
                        iconButton(systemName: "plus.circle.fill", fontWeight: .bold, action: { viewModel.addPoint() })
                    }
                    .frame(width: 70, height: 70)
                    .fontWeight(.medium)
                    .padding(.bottom)
                    .buttonStyle(CustomAnimation())
                }
                .frame(width: 170 ,height: 70)
            }
            
            
        }
        .frame(width: 170)
    }
    
}

#Preview {
    GiveView()
}

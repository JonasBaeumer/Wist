//
//  ConfigureGameView.swift
//  Wizard
//
//  Created by Jonas Bäumer on 08.10.22.
//

import SwiftUI

struct ConfigureGameView: View {
    
    @State var addPlayersViewTrue = false
    @State private var isShowingAddPlayerSheet = false
    @ObservedObject var viewModel: GameViewModel = GameViewModel()
    
    func getAddPlayersView() -> some View {
        GameView(viewModel: self.viewModel)
    }
    
    func getFinalScreen() -> some View {
        FinalScreen(viewModel: self.viewModel)
    }
    
    var body: some View {
        NavigationStack {
            if !addPlayersViewTrue {
                VStack() {
                    PlayerOverview(viewModel: viewModel)
                    ContinueButton(
                        addPlayerViewTrue: $addPlayersViewTrue,
                        viewModel: viewModel
                    )
                        .padding()
                }
                .safeAreaInset(edge: .top) {
                    HStack {
                        Text("Spieler Liste")
                            .font(.largeTitle.weight(.bold))
                        Spacer()
                        Button(action: {
                            isShowingAddPlayerSheet.toggle()
                        }) {
                            Image(systemName: "person.fill.badge.plus")
                        }.sheet(isPresented: $isShowingAddPlayerSheet) {
                            AddPlayersSheet(viewModel: viewModel)
                                .presentationDetents([.medium])
                        }
                    }
                    .padding()
                    .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .overlay(.ultraThinMaterial)
                    )
                }
            } else {
                if !self.viewModel.gameIsOver {
                    getAddPlayersView()
                } else {
                    getFinalScreen()
                }
            }
        }
    }
}

struct ConfigureGameView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureGameView()
    }
}

struct PlayerOverview: View {
    
    @ObservedObject var viewModel: GameViewModel
    var gridItemLayout = [GridItem(.flexible(), spacing: 50), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 30) {
                ForEach(viewModel.playerList, id: \.id) {player in
                    Image("ape\(player.tag)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .frame(width:70, height:70)
                        Text(player.name)
                }
            }
        }
    }
}




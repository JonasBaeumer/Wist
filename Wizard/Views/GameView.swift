//
//  AddPlayersView.swift
//  Wizard
//
//  Created by Jonas Bäumer on 12.10.22.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var viewModel: GameViewModel
    @State var isShowingPlayerSheet = false
    @State var showGameView = true
    
    func getGameViewHeader(number: Int) -> some View {
        return VStack() {
            
        }.safeAreaInset(edge: .top) {
            HStack {
                Text("Runde #\(number)")
                    .font(.largeTitle.weight(.bold))
                Spacer()
                Button(action: {
                    isShowingPlayerSheet.toggle()
                }) {
                    Text("Spielstand")
                }.sheet(isPresented: $isShowingPlayerSheet) {
                    ScoreBoardSheet(viewModel: viewModel)
                        .presentationDetents([.fraction(0.8)])
                }
            }
            .padding()
            .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay(.ultraThinMaterial)
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.showGameView {
                getGameViewHeader(number: viewModel.currentRoundNumber)
                VStack {
                    HStack {
                        ProgressBar(viewModel: viewModel)
                            .padding()
                        CurrentDealer(viewModel: viewModel)
                            .padding()
                    }
                    PredictionSetter(viewModel: viewModel)
                }
                .padding()
                HStack {
                    GoBackToEnterResultsButton(viewModel: viewModel)
                    EnterResultsButton(viewModel: viewModel)
                }.padding()
            } else {
                ScoreCalculationView(viewModel: viewModel)
            }
        }
    }
}

struct AddPlayersView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel())
    }
}

struct ProgressBar: View {
    
    @ObservedObject var viewModel: GameViewModel
    ///let maxNumberOfRounds: Int
    
    var body: some View {
        ZStack {
            RoundProgressCounter(progress:
                Double(viewModel.currentRoundNumber) / Double(viewModel.maxNumberOfRounds))
            Text("\(viewModel.currentRoundNumber)/\(viewModel.maxNumberOfRounds)")
                .bold()
        }
    }
}

struct RoundProgressCounter: View {
    
    /// Needed to make sure the progress bar is data driven and not static
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.green.opacity(0.1),
                    lineWidth: 30
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.blue.opacity(0.5),
                    style: StrokeStyle(
                        lineWidth: 30,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
    }
}

struct CurrentDealer: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack{
            Text("Current Dealer")
                .bold()
                .fontWeight(.heavy)
            Image("ape\(viewModel.playerList.last!.tag)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .frame(width:80, height:80)
            Text(viewModel.playerList.last!.name)
        }
    }
}

struct PredictionSetter: View {
    @ObservedObject var viewModel: GameViewModel
    /// Use this for expanding the background beyond the list
    /// https://developer.apple.com/documentation/swiftui/adding-a-background-to-your-view
    let backgroundGradient = LinearGradient(
        colors: [Color.red, Color.blue],
        startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        VStack() {
            
        }.safeAreaInset(edge: .trailing) {
            HStack() {
                Spacer()
                Text("Angesagte Stiche: \(viewModel.totalCalledTrumps)/\(viewModel.maxNumberOfTrumps)")
                    .bold()
                Spacer()
            }
            .padding()
            .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay(.ultraThinMaterial)
            )
        }
        
        List(viewModel.playerList.indices) { index in
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Image("ape\(viewModel.playerList[index].tag)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .frame(width:40, height:40)
                    Text(viewModel.playerList[index].name)
                }
                VStack(alignment: .trailing) {
                    Text(String(viewModel.playerList[index].predictedTricks))
                        .bold()
                    Stepper{
                    } onIncrement: {
                        viewModel.increasePlayerPrediction(index: index)
                    } onDecrement: {
                        viewModel.decreasePlayerPrediction(index: index)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

///PROBLEM: Image still does not resize its just cropped
///https://www.hackingwithswift.com/books/ios-swiftui/resizing-images-to-fit-the-screen-using-geometryreader
struct Header: View {
    @AppStorage("rValue") var rValue = 150.0
    @AppStorage("gValue") var gValue = 150.0
    @AppStorage("bValue") var bValue = 150.0
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(.green)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 100)
            Image("profile")
                .frame(width:150, height:150)
                .clipShape(Circle())
                .scaledToFill()
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                //.shadow(radius: 10)
        }
    }
}

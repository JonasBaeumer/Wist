//
//  ScoreCalculationView.swift
//  Wizard
//
//  Created by Jonas Bäumer on 12.11.22.
//

import SwiftUI

struct ScoreCalculationView: View {
    
    @State var boolTest = true
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        //VStack {
            HeaderBar(title: "Ergebnisse eintragen")
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
                        HStack {
                            Text("Angesagt: ")
                            Text(String(viewModel.playerList[index].predictedTricks))
                                .bold()
                        }
                        HStack{
                            Text("Bekommen: ")
                            Text(String(viewModel.playerList[index].actualTricks))
                                .bold()
                        }
                        Stepper{
                        } onIncrement: {
                            viewModel.increaseActualTrumpsReceived(index: index)
                        } onDecrement: {
                            viewModel.decreaseActualTrumpsReceived(index: index)
                        }
                    }
                }
            }
        HStack {
            GoBackToRoundButton(viewModel: viewModel)
            NextRoundButton(viewModel: viewModel)
        }
        .padding()
        //}
    }
}

struct ScoreCalculationView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCalculationView(viewModel: GameViewModel())
    }
}

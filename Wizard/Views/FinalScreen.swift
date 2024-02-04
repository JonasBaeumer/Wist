//
//  FinalScreen.swift
//  Wizard
//
//  Created by Jonas Bäumer on 10.12.22.
//

import SwiftUI

struct FinalScreen: View {
    
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack{
            Winner(viewModel: self.viewModel)
                .frame(height:250)
            PlayerRanking(viewModel: self.viewModel)
        }
        .padding()
    }
}

struct FinalScreen_Previews: PreviewProvider {
    static var previews: some View {
        FinalScreen(viewModel: GameViewModel())
    }
}

struct Winner: View {
    /// https://dribbble.com/tags/rank_app
    
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        HStack {
            VStack{
                ZStack {
                    Image("ape\(viewModel.playerList[1].tag)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                    //.shadow(radius: 5)
                        .frame(width:70, height:70)
                    RankingCircle(colour: .blue, number: "2")
                        .frame(width: 20, height: 20)
                        .offset(y:33)
                }
                VStack{
                    Text("\(viewModel.playerList[1].name)")
                    Text("\(viewModel.playerList[1].score)")
                        .bold()
                    Text("Punkte")
                        .bold()
                }
            }
            .offset(y: 15)
            //.padding()
            VStack{
                ZStack{
                    Image("Crown1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80,height:80)
                        .offset(y: -76)
                    Image("ape\(viewModel.playerList[0].tag)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
                    //.shadow(radius: 5)
                        .frame(width:100, height:100)
                    RankingCircle(colour: .yellow, number: "1")
                        .offset(y:49)
                }
                VStack{
                    Text("\(viewModel.playerList[0].name)")
                    Text("\(viewModel.playerList[0].score)")
                        .bold()
                    Text("Punkte")
                        .bold()
                }
            }
            .offset(y: -15)
            //.padding()
            VStack{
                ZStack {
                    Image("ape\(viewModel.playerList[2].tag)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.purple, lineWidth: 4))
                    //.shadow(radius: 5)
                        .frame(width:70, height:70)
                    RankingCircle(colour: .purple, number: "3")
                        .offset(y:33)
                }
                VStack{
                    Text("\(viewModel.playerList[2].name)")
                    Text("\(viewModel.playerList[2].score)")
                        .bold()
                    Text("Punkte")
                        .bold()
                }
            }
            .offset(y: 15)
            //.padding()
        }
        .padding()
    }
}

struct Winner_Previews: PreviewProvider {
    static var previews: some View{
        Winner(viewModel: GameViewModel())
    }
}


struct RankingCircle: View {
    
    var colour: Color
    var number: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(self.colour)
                .frame(width: 28, height: 28)
            Text(self.number)
                .bold()
                //.frame(width: 30, height: 30)
        }
    }
}

struct RankingCircle_Previews: PreviewProvider {
    static var previews: some View{
        RankingCircle(colour: .yellow, number: "1")
    }
}


struct PlayerRanking: View {
    
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack{
            //Rectangle()
              //  .fill(Color.black).ignoresSafeArea()
            
            ScrollView {
                VStack{
                    ForEach(3..<viewModel.playerList.count) { index in
                        PlayerRankingRowElement(player: viewModel.playerList[index])
                        
                    }
                }
            }
        }
    }
}

struct PlayerRanking_Previews: PreviewProvider {
    static var previews: some View{
        PlayerRanking(viewModel: GameViewModel())
    }
}

struct PlayerRankingRowElement: View {
    
    var player: Player
    
    var body: some View {
        HStack() {
            Spacer()
                .frame(width: 20)
            Image("ape\(player.tag)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                .frame(width:60, height:70)
            Spacer()
                .frame(width: 15)
            Text("\(player.name)")
                .frame(width: 130)
            Text("\(player.score) Punkte")
                .bold()
            Spacer()
        }
        .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay(.ultraThinMaterial))
        .clipShape(
            RoundedRectangle(
                cornerRadius: 25.0, style: .continuous)
        )
        .padding()
    }
}

struct PlayerRankingRowElement_Previews: PreviewProvider {
    static var previews: some View{
        PlayerRankingRowElement(player: Player(name: "Wolfgang", tag: 2 ,predictedTricks: 0, actualTricks: 0, roundsRight: 30, roundsWrong: 0, score: 200))
    }
}


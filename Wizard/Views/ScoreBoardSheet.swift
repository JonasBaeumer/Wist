//
//  ScoreBoardSheet.swift
//  Wizard
//
//  Created by Jonas Bäumer on 31.10.22.
//

import SwiftUI

struct ScoreBoardSheet: View {
    
    @ObservedObject var viewModel: GameViewModel
        
    var body: some View {
        VStack() {
            Spacer()
            HStack(spacing: 10) {
                Text("Spieler")
                    .padding(.leading)
                    .frame(width: 120, alignment: .leading)
                    .bold()
                Spacer()
                Text("Punkte")
                Divider()
                    .frame(height: 50.0)
                    .bold()
                Text("W")
                Divider()
                    .frame(height: 50.0)
                    .bold()
                Text("L")
                Divider()
                    .frame(height: 50.0)
                    .bold()
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
            List(viewModel.playerList.indices) { index in
                HStack(spacing: 10) {
                    Text("\(index+1)")
                    Image("ape\(viewModel.playerList[index].tag)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .frame(width:40, height:40)
                    Text("\(viewModel.playerList[index].name)")
                        .frame(width: 150.0, alignment:.leading)
                    // Spacer()
                        //.frame(width: 10.0)
                    Divider()
                    Text("\(viewModel.playerList[index].score)")
                        .frame(width: 30)
                    Divider()
                    Text("\(viewModel.playerList[index].roundsRight)")
                        .frame(width: 30) // replace 12 with any value for the exact result you're expecting
                    Divider()
                    Text("\(viewModel.playerList[index].roundsWrong)")
                        .frame(width: 30, alignment: .leading) // doesn't have to match the above Text's width either could be any value and would still work
                }
            }
        }
    }
}

struct ScoreBoardSheet_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBoardSheet(viewModel: GameViewModel())
    }
}

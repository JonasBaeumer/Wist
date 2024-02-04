//
//  AddPlayersSheet.swift
//  Wizard
//
//  Created by Jonas Bäumer on 15.10.22.
//

import SwiftUI

struct AddPlayersSheet: View {
    
    @ObservedObject var viewModel: GameViewModel
    @State var name: String = ""
    var counter = 0

    func addPlayer() {
        viewModel.addPlayerToGame(name)
    }
    
    var body: some View {
        NavigationStack {
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                Button("Hinzufügen") {
                    addPlayer()
                }
            }
            .padding()
            VStack(alignment: .leading) {
                
                Form() {
                    Image("profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 4))
                        //.shadow(radius: 5)
                        .frame(width:70, height:70)
                    TextField("Spielername", text: $name)
                }
            }
            .padding()
        }
    }
}

struct AddPlayersSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayersSheet(viewModel: GameViewModel())
    }
}

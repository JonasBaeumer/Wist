//
//  Buttons.swift
//  Wizard
//
//  Created by Jonas Bäumer on 12.11.22.
//

import SwiftUI

struct Buttons: View {
    var body: some View {
        Text("This class is only needed to store the different button classes")
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Buttons()
    }
}

/// This button is supposed to switch in between the score result view as well as the active round view
/// TODO: Make button take a variable input text to make sure it can be adjusted to the respective view
struct EnterResultsButton: View {
    @ObservedObject var viewModel: GameViewModel
   
    var body: some View {
        Button(action: {
            /// Make sure we increase the round counter only after the scores were calculated and we are starting a new round
            viewModel.showGameView.toggle()
        }) {
            Text("Ergebnisse")
                .fontWeight(.bold)
                .font(.title2)
                .padding()
                .foregroundColor(.white)
                .fixedSize()
                .frame(minWidth: 140, minHeight: 30)
                .padding(2)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
    }
}

struct NextRoundButton: View {
    @ObservedObject var viewModel: GameViewModel
   
    var body: some View {
        Button(action: {
            self.viewModel.roundIsOver()
            viewModel.showGameView.toggle()
        }) {
            Text("Nächste Runde")
                .fontWeight(.bold)
                .font(.title2)
                .padding()
                .foregroundColor(.white)
                .fixedSize()
                .frame(minWidth: 140, minHeight: 30)
                .padding(2)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
    }
}

struct ContinueButton: View {
    @Binding var addPlayerViewTrue: Bool
    @ObservedObject var viewModel: GameViewModel
   
    var body: some View {
        Button(action: {
            self.addPlayerViewTrue.toggle()
        }) {
            Text("Weiter")
                .fontWeight(.bold)
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .frame(minWidth: 270, minHeight: 40)
                .padding(2)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .disabled(viewModel.disableContinueButton)
    }
}

struct GoBackToRoundButton: View {
    @ObservedObject var viewModel: GameViewModel
   
    var body: some View {
        Button(action: {
            viewModel.showGameView.toggle()
        }) {
            Text("Zurück")
                .fontWeight(.bold)
                .font(.title2)
                .padding()
                .foregroundColor(.white)
                .frame(minWidth: 140, minHeight: 30)
                .padding(2)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .disabled(viewModel.disableContinueButton)
    }
}

struct GoBackToEnterResultsButton: View {
    @ObservedObject var viewModel: GameViewModel
   
    var body: some View {
        Button(action: {
            /// This solution does not work if the game is played till the last round is reached (e.g. where the max number of trumps is also 1)
            if(viewModel.maxNumberOfTrumps != 1) {
                self.viewModel.rerollPreviousRound()
                viewModel.showGameView.toggle()
            }
        }) {
            Text("Zurück")
                .fontWeight(.bold)
                .font(.title2)
                .padding()
                .foregroundColor(.white)
                .frame(minWidth: 140, minHeight: 30)
                .padding(2)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .disabled(viewModel.disableContinueButton)
    }
}

struct HeaderBar: View {
    
    @State var title = ""
    
    var body: some View {
        VStack() {
            
        }.safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                Text(title)
                    .font(.largeTitle.weight(.bold))
                }
                Spacer()
            }
            .padding()
            .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .overlay(.ultraThinMaterial)
            )
    }
    
}

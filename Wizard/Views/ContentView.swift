//
//  ContentView.swift
//  Wizard
//
//  Created by Jonas Bäumer on 07.10.22.
//

import SwiftUI

struct ContentView: View {
    
    @State var showNextScreen = false
    
    func getConfigureGameViewScreen() -> some View {
        ConfigureGameView()
    }
    
    var body: some View {
        if !showNextScreen {
            VStack() {
                Image("wistlogo")
                    .resizable()
                    .scaledToFit()
                ButtonResult(
                    resultViewSuccess: $showNextScreen
                )
            }
        } else {
            getConfigureGameViewScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

struct ButtonResult: View {
    @Binding var resultViewSuccess: Bool
    
    var body: some View {
        Button(action: {
            self.resultViewSuccess = true
        }) {
            Text("Los gehts!")
                .fontWeight(.bold)
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .frame(minWidth: 270, minHeight: 40)
                .padding(2)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
    }
}

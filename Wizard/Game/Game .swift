//
//  Game .swift
//  Wizard
//
//  Created by Jonas Bäumer on 07.10.22.
//

import Foundation

class Game: ObservableObject {
    
    var players: [Player] = []
    var round: Int
    var numberOfRounds: Int
    
    init(round: Int, numberOfRounds: Int) {
        self.round = round
        self.numberOfRounds = numberOfRounds
    }
    
    /// TODO: Make method to update the playerList rather than add (this functionality was moved elsewhere)
    func updatePlayerList(_ list: [Player]) {
        self.players = list
        print("Player List was updated")
        for player in self.players {
            print("Player name: \(player.name)")
        }
    }
    
    func increaseRound() {
        self.round+=1
    }
    
    /// With each round the dealer changes and so does the order of players that need to call the tricks first
    /// The dealer has to call last
    func changeDealer() {
        /// let dealer = players.first
        ///Move all elements down by one in order and put the dealer last
        ///for i in stride(from: 0, to: players.count-1, by: 1) {
           /// players[i] = players[i+1]
        ///}
        ///players[players.capacity-1] = dealer!
    }
    
    func incrementPrediction(_ player: Player) -> Player {
        var playerOverwritten = player
        
        playerOverwritten.predictedTricks += 1
        if player.predictedTricks > self.round { playerOverwritten.predictedTricks = 0 }
        
        return playerOverwritten
    }

    func decrementPrediction(_ player: Player) -> Player {
        var playerOverwriten = player
        
        playerOverwriten.predictedTricks -= 1
        if playerOverwriten.predictedTricks < 0 { playerOverwriten.predictedTricks = self.round - 1 }
        
        return playerOverwriten
    }
}

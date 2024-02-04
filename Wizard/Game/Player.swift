//
//  Player.swift
//  Wizard
//
//  Created by Jonas Bäumer on 07.10.22.
//

import Foundation
import Combine

class PlayerStoragePublisher {
    
    private let currentPlayerBaseSubject = CurrentValueSubject<PlayerList, Never>(PlayerList(listOfPlayers: []))
    
    /// This variable is supposed to store the information of the player of the previous round, if necessary, the old round results can just be restored with this
    private var previousRoundPlayerBase: [Player] = []
    
    var currentPlayerBase: AnyPublisher<PlayerList, Never> {
        currentPlayerBaseSubject.eraseToAnyPublisher()
    }
    
    /// To make the new PlayerBase Accessible for the Game (it must be handed over to the ViewModel)
    public func addPlayer(_ name: String, tag: Int) -> [Player] {
        
        var updatedPlayerBase = currentPlayerBaseSubject.value.listOfPlayers
        updatedPlayerBase.append(Player(name: name, tag: tag, score: 0))
        currentPlayerBaseSubject.send(.init(listOfPlayers: updatedPlayerBase))
     
        return updatedPlayerBase
    }
    
    /// This method changes the player order after the round is over
    /// The dealer will be moved to the end of the list while all other elements are moved forward by one position
    public func changePlayerOrder() {
        var updatedPlayeBase = currentPlayerBaseSubject.value.listOfPlayers
        
        let dealer = updatedPlayeBase.first!
        
        ///Move all elements down by one in order and put the dealer last
        for i in stride(from: 0, to: updatedPlayeBase.count-1, by: 1) {
           updatedPlayeBase[i] = updatedPlayeBase[i+1]
        }
        
        updatedPlayeBase.removeLast()
        
        updatedPlayeBase.append(dealer)
        
        updatedPlayeBase = resetPredictions(playerBase: updatedPlayeBase)
        
        currentPlayerBaseSubject.send(.init(listOfPlayers: updatedPlayeBase))
    }
    
    /// Resets all predicted trumps before the next round
    public func resetPredictions(playerBase: [Player]) -> [Player] {
        var updatedPlayerBase: [Player] = []
        
        playerBase.forEach { element in
            var newPlayer = element
            newPlayer.predictedTricks = 0
            updatedPlayerBase.append(newPlayer)
        }
        
        return updatedPlayerBase
    }
    
    /// Return True if score could be increased further
    /// Return False if not
    public func increasePrediction(index: Int, round: Int) -> Bool {
        var updatedPlayerBase = currentPlayerBaseSubject.value.listOfPlayers
        var scoreWasIncreased = true
        
        var player = updatedPlayerBase.remove(at: index)
        player.predictedTricks += 1
        
        ///Make sure a player can not call more than the maximum number of cards
        if player.predictedTricks > round {
            player.predictedTricks = round
            scoreWasIncreased = false
        }
        
        updatedPlayerBase.insert(player, at: index)
        currentPlayerBaseSubject.send(.init(listOfPlayers: updatedPlayerBase))
        
        return scoreWasIncreased
    }
    
    /// Return true if the score could be decreased further
    /// False if not
    public func decreasePrediction(index: Int) -> Bool {
        var updatedPlayerBase = currentPlayerBaseSubject.value.listOfPlayers
        var scoreWasDecreased = true
        
        var player = updatedPlayerBase.remove(at: index)
        player.predictedTricks -= 1
        
        /// Make sure that a player can not call less than 0
        if player.predictedTricks < 0 {
            player.predictedTricks = 0
            scoreWasDecreased = false
        }
        
        updatedPlayerBase.insert(player, at: index)
        currentPlayerBaseSubject.send(.init(listOfPlayers: updatedPlayerBase))
        
        return scoreWasDecreased
    }
    
    public func increaseActualTrumps(index: Int) {
        var updatedPlayerBase = currentPlayerBaseSubject.value.listOfPlayers
        var scoreWasIncreased = true
        
        var player = updatedPlayerBase.remove(at: index)
        player.actualTricks += 1
        
        updatedPlayerBase.insert(player, at: index)
        currentPlayerBaseSubject.send(.init(listOfPlayers: updatedPlayerBase))
        
    }
    
    public func decreaseActualTrumps(index: Int) {
        var updatedPlayerBase = currentPlayerBaseSubject.value.listOfPlayers
        
        var player = updatedPlayerBase.remove(at: index)
        player.actualTricks -= 1
        
        /// Make sure that a player can not call less than 0
        if player.actualTricks < 0 {
            player.actualTricks = 0
        }
        
        updatedPlayerBase.insert(player, at: index)
        currentPlayerBaseSubject.send(.init(listOfPlayers: updatedPlayerBase))
        
    }
    
    /// Problem: All items are evaluated after another, can be done in a more optimal way later
    public func calculatePoints(index: Int) {
        var updatedPlayerBase = currentPlayerBaseSubject.value.listOfPlayers
        
        var player = calculatePoints(player: updatedPlayerBase.remove(at: index))
        
        updatedPlayerBase.insert(player, at: index)
        currentPlayerBaseSubject.send(.init(listOfPlayers: updatedPlayerBase))

    }
    
    /// Only to use before the scorecalculationView
    public func resetActualValues(index: Int) {
        var updatedPlayerBase = currentPlayerBaseSubject.value.listOfPlayers
        
        var player = updatedPlayerBase.remove(at: index)
        player.actualTricks = 0
        
        updatedPlayerBase.insert(player, at: index)
        currentPlayerBaseSubject.send(.init(listOfPlayers: updatedPlayerBase))
    }
    
    /// A helper method to calculate the points for the player and track wins and losses after each round
    private func calculatePoints(player: Player) -> Player {
        var player = player
        
        /// Player gets deducted points
        if (player.actualTricks != player.predictedTricks) {
            var difference = abs(player.actualTricks - player.predictedTricks)
            player.score -= (2 * difference)
            player.roundsWrong += 1
        /// Player receives points
        } else {
            player.score += 10 + (player.actualTricks * 2)
            player.roundsRight += 1
        }
        
        return player
    }
    
    /// ------------------------------------------------------------------------------------------
    /// The section below is for methods that are used to store and load the game state of the previous round.
    
    public func storePlayerState() {
        self.previousRoundPlayerBase = self.currentPlayerBaseSubject.value.listOfPlayers
    }
    
    public func retrievePreviousRoundPlayerBase() {
        currentPlayerBaseSubject.send(.init(listOfPlayers: previousRoundPlayerBase))
    }
    
}

/// Needed to Nest the Array for CurrentValueSubject which can only take a single object
struct PlayerList {
    
    var listOfPlayers : [Player]
    
}

struct Player: Identifiable {
    
    let id = UUID()
    let name: String
    let tag: Int
    var predictedTricks: Int = 0
    var actualTricks: Int = 0
    var roundsRight: Int = 0
    var roundsWrong: Int = 0
    var score: Int = 0
    
}

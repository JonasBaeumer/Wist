//
//  GameViewModel.swift
//  Wizard
//
//  Created by Jonas Bäumer on 11.10.22.
//

import Foundation

class GameViewModel: ObservableObject {
    
    @Published var disableContinueButton = true
    @Published var showGameView = true
    @Published private(set) var playerList: [Player] = []
    /// TODO: Adjust this number automatically depending on the number of player in the list
    @Published var maxNumberOfRounds = 24
    @Published var currentRoundNumber = 1
    @Published var maxNumberOfTrumps = 1
    @Published var totalCalledTrumps = 0
    @Published var gameIsOver = false
    private let playerStoragePublisher = PlayerStoragePublisher()
    /// This variable tracks if the game is half way through, if that happens the max number of trumps decreases until it reaches zero
    private var secondHalf = false
    /// This counter is used for profile picture selection
    private var tag: Int = 0
    
    init() {
        playerStoragePublisher.currentPlayerBase
            .map{ $0.listOfPlayers }
            .assign(to: &$playerList)
    }
    
    func setMaxNumberOfRounds() {
        /// The number of cards in the game is 104
        /// A maximum number of 13 for up and down can be played
        /// If there are too many other players the max number of rounds will be decreased accordingly
        var numberOfPlayers: Int = self.playerList.count
        var numberOfCards: Int = 104
        var numberOfRounds = (numberOfCards / numberOfPlayers) * 2
        
        self.maxNumberOfRounds = numberOfRounds > 26 ? 26 : numberOfRounds
        
    }
    
    func addPlayerToGame(_ name: String) {
        let updatedPlayerList = self.playerStoragePublisher.addPlayer(name, tag: tag)
        self.tag+=1
        /// If not at least one user is added to the game, it can not start
        if !updatedPlayerList.isEmpty {
            disableContinueButton = false
        }
        self.setMaxNumberOfRounds()
    }
    
    func increasePlayerPrediction(index: Int) {
        let scoreIncreaseSuccess = self.playerStoragePublisher.increasePrediction(index: index, round: self.currentRoundNumber)
        print("Prediction of player \(self.playerList[index].name) was increased to \(self.playerList[index].predictedTricks)")
        
        if scoreIncreaseSuccess {
            self.totalCalledTrumps += 1
        }
    }
    
    func decreasePlayerPrediction(index: Int) {
        let scoreDecreaseSuccess = self.playerStoragePublisher.decreasePrediction(index: index)
        print("Prediction of player \(self.playerList[index].name) was increased to \(self.playerList[index].predictedTricks)")
        
        if scoreDecreaseSuccess {
            self.totalCalledTrumps -= 1
        }
    }
    
    func increaseActualTrumpsReceived(index: Int) {
        self.playerStoragePublisher.increaseActualTrumps(index: index)
    }
    
    func decreaseActualTrumpsReceived(index: Int) {
        self.playerStoragePublisher.decreaseActualTrumps(index: index)
    }
    
    func determineMaxNumberOfTrumps() {
        
    }
    
    func resetUIValues() {
        self.totalCalledTrumps = 0
    }
    
    /// FOR REROLL
    func rerollUIValues() {
        self.playerList.forEach{self.totalCalledTrumps += $0.predictedTricks}
    }
    
    /// FOR REROLL
    func restorePreviousPlayerBaseState() {
        self.playerStoragePublisher.retrievePreviousRoundPlayerBase()
    }
    
    func resetPlayerValues() {
        for index in playerList.indices {
            self.playerStoragePublisher.resetActualValues(index: index)
        }
    }
    
    func checkIfGameIsOver() {
        if self.currentRoundNumber > self.maxNumberOfRounds {
            self.gameIsOver = true
            self.findWinners()
        }
    }
    
    func updateScores() {
        for index in playerList.indices {             self.playerStoragePublisher.calculatePoints(index: index)
            print("Score for \(self.playerList[index].name) is \(self.playerList[index].score) points")
        }
    }
    
    func roundIsOver() {
        self.increaseRoundCounter()
        /// Store the score of this round to make it accessible in case of a reroll
        self.storeCurrentState()
        /// Reset predictions for all players
        self.updateScores()
        self.playerStoragePublisher.changePlayerOrder()
        self.resetUIValues()
        self.resetPlayerValues()
        self.checkIfGameIsOver()
    }
    
    /// FOR REROLL
    func rerollPreviousRound() {
        self.decreaseRoundCounter()
        self.restorePreviousPlayerBaseState()
        self.rerollUIValues()
    }
    
    func storeCurrentState() {
        self.playerStoragePublisher.storePlayerState()
    }
    
    func increaseRoundCounter() {
        /// After the game is played half way through with the highest round played twice without trumps the trumps and cards per round decrease again until they reach 0
        if secondHalf {
            self.maxNumberOfTrumps -= 1
        } else {
            /// Making sure that the max number of cards does not increase once we are at maximum point
            if maxNumberOfTrumps == ((maxNumberOfRounds / 2)) {
                self.secondHalf = true
            } else {
                self.maxNumberOfTrumps += 1
            }
        }
        self.currentRoundNumber += 1
    }
    
    /// FOR REROLL
    func decreaseRoundCounter() {
        if secondHalf {
            self.maxNumberOfTrumps += 1
        } else {
            if maxNumberOfTrumps == ((maxNumberOfRounds / 2)) {
                self.secondHalf = false
            } else {
                self.maxNumberOfTrumps -= 1
            }
        }
        self.currentRoundNumber -= 1
    }
    
    /// As the card game contains a maximum number of 52 cards the maximum rounds that can be played is dependent on the number of players
    func calculateMaximumRounds(numberOfPlayers: Int) {
        maxNumberOfRounds = ((112 % numberOfPlayers) * 2)
        
        self.maxNumberOfRounds = maxNumberOfRounds
    }
    
    /// After all rounds are played the list is sorted based on the player with the most points
    func findWinners() {
        self.playerList = self.playerList.sorted{$0.score > $1.score}
        for list in playerList {
            print("Player \(list.name) has \(list.score)")
        }
    }
}

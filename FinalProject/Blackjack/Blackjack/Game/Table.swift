//
//  Deck.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-04-10.
//

import Foundation

struct TablePlayer {
    var cards: [Card] = []
    var count: Int = 0
}

class Game {
    var deck = Set<Int>()
    var dealer = TablePlayer()
    var player = TablePlayer()
    var selectedPlayer: Player
    var bet: Int
    
    
    init(selectedPlayer: Player, bet: Int) {
        while deck.count < 15 {
            let card = Int.random(in: 1..<52)
            deck.insert(card)
        }
        self.selectedPlayer = selectedPlayer
        self.bet = bet
    }
    
    // Check for winner
    func hasWinner() -> Int {
        // no winner
        if (dealer.count == 0) {
            return 0 // no winner yet
        }
        else if (player.count > dealer.count) {
            return 1 // player wins
        }
        else {
            return -1 // dealer wins
        }
    }
    
    func dealInitialCards() {
        if (deck.count > 3) {
            player.cards.append(Card(number: deck.removeFirst()))
            player.cards.append(Card(number: deck.removeFirst()))
            dealer.cards.append(Card(number: deck.removeFirst()))
            dealer.cards.append(Card(number: deck.removeFirst()))
        }
        else {
            print("Error not enough cards to deal -> \(deck)")
        }
    }
    
    func hitPlayer() {
        if (deck.count > 0) {
            player.cards.append(Card(number: deck.removeFirst()))
        }
        else{
            print("Error not enough cards to hit -> \(deck)")
        }
    }
}

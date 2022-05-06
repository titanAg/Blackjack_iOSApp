//
//  Deck.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-04-10.
//

import Foundation
import UIKit

struct TablePlayer {
    var cards: [Card] = []
    var count: Int = 0
}

class Game {
    var initPosCGRect: CGRect // initial ref position of dealt cards
    var dealerPosCGRect: CGRect // dealer ref position of cards
    var playerPosCGRect: CGRect // player ref position of cards
    var view: UIView
    
    var deck = Set<Int>()
    var dealer = TablePlayer()
    var player = TablePlayer()
    var selectedPlayer: Player
    var bet: Int
    
    init(view: UIView, selectedPlayer: Player, bet: Int, initPosCGRect: CGRect, dealerPosCGRect: CGRect, playerPosCGRect: CGRect) {
        self.view = view
        while deck.count < 15 {
            let card = Int.random(in: 1..<52)
            deck.insert(card)
        }
        self.selectedPlayer = selectedPlayer
        self.bet = bet
        self.initPosCGRect = initPosCGRect
        self.dealerPosCGRect = dealerPosCGRect
        self.playerPosCGRect = playerPosCGRect
    }
    
    // remove all cards
    func clearCards() {
        for card in dealer.cards + player.cards {
            card.imageView.removeFromSuperview()
        }
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
            let dealerPos1 = CGRect(x:dealerPosCGRect.minX-35, y:dealerPosCGRect.minY, width: dealerPosCGRect.width, height: dealerPosCGRect.width)
            let dealerPos2 = CGRect(x:dealerPosCGRect.minX+35, y:dealerPosCGRect.minY, width: dealerPosCGRect.width, height: dealerPosCGRect.width)
            let playerPos1 = CGRect(x:playerPosCGRect.minX-35, y:playerPosCGRect.minY, width: playerPosCGRect.width, height: playerPosCGRect.height)
            let playerPos2 = CGRect(x:playerPosCGRect.minX+35, y:playerPosCGRect.minY, width: playerPosCGRect.width, height: playerPosCGRect.height)
            player.cards.append(Card(id: player.cards.count, number: deck.removeFirst(), initPosCGRect: initPosCGRect, targetPosCGRect: playerPos1))
            player.cards.append(Card(id: player.cards.count, number: deck.removeFirst(), initPosCGRect: initPosCGRect, targetPosCGRect: playerPos2))
            dealer.cards.append(Card(id: dealer.cards.count, number: deck.removeFirst(), initPosCGRect: initPosCGRect, targetPosCGRect: dealerPos1))
            dealer.cards.append(Card(id: dealer.cards.count, number: deck.removeFirst(), initPosCGRect: initPosCGRect, targetPosCGRect: dealerPos2))
            // For Debugging
//            player.cards.append(Card(id: player.cards.count, number: 14, initPosCGRect: initPosCGRect, targetPosCGRect: playerPos1))
//            player.cards.append(Card(id: player.cards.count, number: 26, initPosCGRect: initPosCGRect, targetPosCGRect: playerPos2))
//            dealer.cards.append(Card(id: dealer.cards.count, number: 16, initPosCGRect: initPosCGRect, targetPosCGRect: dealerPos1))
//            dealer.cards.append(Card(id: dealer.cards.count, number: 17, initPosCGRect: initPosCGRect, targetPosCGRect: dealerPos2))
            player.count = updateCount(cards: player.cards)
            dealer.count = updateCount(cards: dealer.cards)
        }
        else {
            print("Error not enough cards to deal -> \(deck)")
        }
    }
    
    // This function performs the initial deal
    func deal(completion: ((Bool) -> Void)?) {
        let dealerCards = dealer.cards
        view.addSubview(dealerCards[0].imageView)
        view.addSubview(dealerCards[1].imageView)
        
        let playerCards = player.cards
        view.addSubview(playerCards[0].imageView)
        view.addSubview(playerCards[1].imageView)
        
        // flip cards
        UIView.transition(with: dealer.cards[0].imageView,
                          duration: 1.0,
                      options: [.curveEaseOut, .transitionFlipFromRight],
                      animations: { self.dealer.cards[0].placeCard(flip: false)
                        },
                      completion: getDealCompletions(cards: player.cards + [dealer.cards[1]], completion: completion))
    }
    
    // This function initiates flip and deal transitions for player's new card
    func hitPlayer(completion: ((Bool) -> Void)?) {
        if (deck.count > 0) {
            // Draw new card and add to last card position
            let c = Card(id: player.cards.count, number: deck.removeFirst(), initPosCGRect: initPosCGRect, targetPosCGRect: player.cards[player.cards.count-1].targetPosCGRect)
            player.cards.append(c)
            print("New player card: " + c.imagePath)
            c.imageView.frame = initPosCGRect
            view.addSubview(c.imageView)
            
            var cards = player.cards
            cards.removeFirst()
            // shift and deal
            UIView.transition(with: player.cards[0].imageView,
                              duration: 0.75,
                          options: [.curveEaseOut, .transitionFlipFromRight],
                          animations: { self.player.cards[0].shiftCard() },
                          completion: getHitCompletions(cards: cards, finalCompletion: completion))
            player.count = updateCount(cards: player.cards)
            dealer.count = updateCount(cards: dealer.cards)
        }
        else{
            print("Error not enough cards to hit -> \(deck)")
        }
    }
    
    // This function initiates flip and deal transitions for player's new card
    func hitDealer(completion: ((Bool) -> Void)?) {
        var count = updateCount(cards: dealer.cards)
        var newCards: [Card] = []
        print("Inital count: " + String(count))
        while count < player.count && count < 22 {
            if (deck.count > 0) {
                // Draw new card and add to last card position
                let n = deck.removeFirst()
                //count += n % 13
                print("drawing : " + String(n%13))
                
                let c = Card(id: dealer.cards.count, number: n, initPosCGRect: initPosCGRect, targetPosCGRect: dealer.cards[dealer.cards.count-1].targetPosCGRect)
                dealer.cards.append(c)
                newCards.append(c)
                print("New dealer card: " + c.imagePath)
                c.imageView.frame = initPosCGRect
                view.addSubview(c.imageView)
                
                
                count = updateCount(cards: dealer.cards)
                print("New count: " + String(count))
            }
            else{
                print("Error not enough cards to hit -> \(deck)")
            }

        }
           

        var cards = dealer.cards
        cards.removeFirst()
        
        if (dealer.count >= player.count) {
            UIView.transition(with: dealer.cards[0].imageView,
                              duration: 1.0,
                          options: [.curveEaseOut, .transitionFlipFromRight],
                          animations: {
                            self.dealer.cards[0].flipCard();
                          },
                            completion: completion)
        }
        else {
            UIView.transition(with: dealer.cards[0].imageView,
                              duration: 1.0,
                          options: [.curveEaseOut, .transitionFlipFromRight],
                          animations: { self.dealer.cards[0].shiftCard();
                            self.dealer.cards[0].flipCard();
                          },
                            completion: self.getHitCompletions(cards: cards, finalCompletion: completion))
        }
        
        player.count = updateCount(cards: player.cards)
        dealer.count = updateCount(cards: dealer.cards)
        printPlayerCards()
 
    }
    
    // recursive function to return completions for subsequent dealt card flips
    private func getDealCompletions(cards: [Card], completion: ((Bool) -> Void)?) -> ((Bool) -> Void)? {
        var c = cards
        let e = c.removeLast()
        if (c.isEmpty) {
            return {_ in
                UIView.transition(with: e.imageView,
                                  duration: 0.75,
                              options: [.curveEaseOut, .transitionFlipFromRight],
                              animations: {
                                e.placeCard(flip: true)},
                              completion: completion)
              }
        }
        else {
            return {_ in
                UIView.transition(with: e.imageView,
                                  duration: 0.75,
                              options: [.curveEaseOut, .transitionFlipFromRight],
                              animations: { e.placeCard(flip: true)},
                              completion: self.getDealCompletions(cards: c, completion: completion))
              }
        }
    }
    
    // recursive function to return completions for cards on table
    private func getHitCompletions(cards: [Card], finalCompletion: ((Bool) -> Void)?) -> ((Bool) -> Void)? {
        var c = cards.sorted(by: { $0.id > $1.id})
            let e = c.removeLast()
        print("Working on : " + e.imagePath)
            if (c.isEmpty) {
                return {_ in
                    UIView.transition(with: e.imageView,
                                      duration: 0.75,
                                  options: [.curveEaseOut, .transitionFlipFromRight],
                                  animations: {
                                    let pos = CGFloat(35)
                                    e.targetPosCGRect = CGRect(x: e.targetPosCGRect.minX+pos, y: e.targetPosCGRect.minY, width: e.targetPosCGRect.width, height: e.targetPosCGRect.height)
                                    e.placeCard(flip: true)},
                                  completion: finalCompletion)
                  }
            }
            else {
                return {_ in
                    UIView.transition(with: e.imageView,
                                      duration: 0.75,
                                  options: [.curveEaseOut, .transitionFlipFromRight],
                                  animations: {
                                    print("id: " + String(e.id))
                                        if (e.state == 1) {                                            
                                            let pos = CGFloat(70)
                                            e.targetPosCGRect = CGRect(x: e.targetPosCGRect.minX+pos, y: e.targetPosCGRect.minY, width: e.targetPosCGRect.width, height: e.targetPosCGRect.height)
                                            e.placeCard(flip: true)
                                            e.shiftCard()
                                        }
                                        else {
                                            e.shiftCard()
                                        }
                                     },
                                  completion: self.getHitCompletions(cards: c, finalCompletion: finalCompletion))
                  }
            }
    }
    
    private func updateCount(cards: [Card]) -> Int {
        var c = 0
        var aceCount = 0
        for card in cards {
            print("card number: " + String(card.number))
            var number = card.number
            if (number == 1) { // handle ace
                aceCount += 1
                number = 11
            }
            c += number
        }
        if (c > 21 && aceCount > 0) {
            for _ in 1...aceCount {
                print("removing ace")
                c -= 10
                if (c < 22) {
                    break
                }
            }
        }
        
        return c
    }
    

    
    func printPlayerCards() {
        for card in player.cards {
            print("Player: " + card.imagePath + " " + String(card.number))
        }
        for card in dealer.cards {
            print("Dealer: " + card.imagePath + " " + String(card.number))
        }
//        print("Dealer: " + dealer.cards[0].imagePath + " " + String(dealer.cards[0].number))
//        print("Dealer: " + dealer.cards[1].imagePath + " " + String(dealer.cards[1].number))
//        print("Player: " + player.cards[0].imagePath + " " + String(player.cards[0].number))

    }
    
}

//
//  Card.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-04-10.
//

import Foundation
import SwiftUI

class Card {
    var id: Int // id to provide sortability
    var number: Int // 1-13 -> 2-Ace
    var suit: Int // 1,2,3,4 -> hearts, diamonds, clubs, spades
    var imagePath: String
    var imagePathCovered: String
    var state: Int // 1-2 -> covered, uncovered
    var imageView: UIImageView
    var targetPosCGRect: CGRect
    init(id: Int, number: Int, initPosCGRect: CGRect,  targetPosCGRect: CGRect) {
        self.id = id
        self.number = number%13 == 0 ? 13 : number%13
        state = 1
        let faces = ["jack", "queen", "king"]
        let imageSuffix = self.number < 11 ? (self.number > 1 ? String(self.number) : "ace") : faces[self.number%11]
        
        self.number = min(self.number, 10) // reset any face card to 10
        
        if (number <= 13) {
            suit = 1
            self.imagePath = "hearts_" + imageSuffix
        } else if (number <= 26) {
            suit = 2
            imagePath = "diamonds_" + imageSuffix
        } else if (number <= 39) {
            suit = 3
            imagePath = "clubs_" + imageSuffix
        } else {
            suit = 4
            imagePath = "spades_" + imageSuffix
        }
        imagePathCovered = "cover_blue";
        let image = UIImage(named: imagePathCovered)
        imageView = UIImageView(image: image)
        imageView.frame = initPosCGRect
        self.targetPosCGRect = targetPosCGRect
    }


    func updateCard(card: Card) {
        self.number = card.number;
        self.suit = card.suit;
        self.imagePath = card.imagePath;
    }
    
    func flipCard() {
        self.imageView.image = UIImage(named: self.imagePath)
        self.state = 2
    }
    
    func placeCard(flip: Bool) {
        self.imageView.frame = self.targetPosCGRect
        if (flip) {
            self.flipCard()
        }
    }
    
    func shiftCard() {
        let x = self.imageView.frame.origin.x
        let y = self.imageView.frame.origin.y
        self.imageView.frame = CGRect(x:x-35, y:y, width: 150, height: 150)
        //flipCard()
    }
}

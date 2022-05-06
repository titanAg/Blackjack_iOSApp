//
//  ViewController.swift
//  Blackjack
//
//  Created by Kyle on 2022-03-21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPlayer: UIButton!
    @IBOutlet weak var btnEarn: UIButton!
    @IBOutlet weak var lblPlayer: UILabel!
    var selectedPlayer: Player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PlayersDBHelper.dropPlayersTable()
        PlayersDBHelper.createPlayersTable()
        //PlayersDBHelper.printRecords()
        //PlayersDBHelper.insertPlayer(playerName: "Test")
        
        let player = PlayersDBHelper.getSelectedPlayer()
        if player != nil {
            selectedPlayer = PlayersDBHelper.getSelectedPlayer()
        }
        updateViewWithPlayer(selectedPlayer: selectedPlayer)
    }
    
    @IBAction func exitGame(_ sender: Any) {
        exit(-1)
    }
    
    func updateViewWithPlayer(selectedPlayer: Player){
        if !selectedPlayer.ID.isEmpty {
            // Player selected
            btnPlay.isEnabled = true
            btnEarn.isEnabled = true
            lblPlayer.text = "Welcome " + selectedPlayer.name
        }
        else {
            // No selected player
            btnPlay.isEnabled = false
            btnEarn.isEnabled = false
            lblPlayer.text = "Please Select Player"
        }
    }
    
    //To Perform Unwind Segue
    @IBAction func performUnwindSegueOperation(_ sender: UIStoryboardSegue) {
        guard let selectVC = sender.source as? SelectPlayerViewController else { return }
        selectedPlayer = selectVC.selectedPlayer
        updateViewWithPlayer(selectedPlayer: selectedPlayer)
        PlayersDBHelper.updatePlayerSelection(player: selectedPlayer, isSelected: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "game" {
            guard let gameVC = segue.destination as? GameViewController else {
                return
            }
            gameVC.selectedPlayer = selectedPlayer
        }
        else if segue.identifier == "select" {
            guard let selectVC = segue.destination as? SelectPlayerViewController else {
                return
            }
            selectVC.selectedPlayer = selectedPlayer
            PlayersDBHelper.updatePlayerSelection(player: selectedPlayer, isSelected: false)
        }
        else if segue.identifier == "gameOver" {
            guard let gameOverVC = segue.destination as? GameOverViewController else {
                return
            }
            gameOverVC.selectedPlayer = selectedPlayer
            gameOverVC.isActiveGame = false
        }
    }


}

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}



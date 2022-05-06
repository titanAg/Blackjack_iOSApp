//
//  AddPlayerViewController.swift
//  Blackjack
//
//  Created by Kyle on 2022-03-22.
//

import UIKit

class AddPlayerViewController: UIViewController {
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var savePlayer: UIButton!
    var selectedPlayer: Player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewWithPlayer(selectedPlayer: selectedPlayer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectPage = segue.destination as? SelectPlayerViewController else {
            return
        }
        if (selectedPlayer.ID.isEmpty) {
            selectPage.players.append(PlayersDBHelper.insertPlayer(playerName: playerName.text ?? "NOBODY"))
        }
        else {
            selectedPlayer.name = playerName.text!
            var player = PlayersDBHelper.updatePlayerName(player: selectedPlayer)
        }
        
    }
    
    func updateViewWithPlayer(selectedPlayer: Player) {
        if (selectedPlayer.ID.isEmpty) {
            playerName.text = "Player " + String(PlayersDBHelper.getPlayerCount())
            savePlayer.setTitle("Create Player", for: .normal)
        }
        else {
            playerName.text = selectedPlayer.name
            savePlayer.setTitle("Update Player", for: .normal)
        }
    }
    
}

//
//  GameOverViewController.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-04-12.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var chip1: UIImageView!
    @IBOutlet weak var chip2: UIImageView!
    @IBOutlet weak var chip3: UIImageView!
    @IBOutlet weak var lblchip1: UILabel!
    @IBOutlet weak var lblChip2: UILabel!
    @IBOutlet weak var lblChip3: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    
    var selectedPlayer: Player = Player()
    var isActiveGame: Bool = false
    
    var prizes = [5, 10, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(GameOverViewController.chip1Tapped))
        chip1.addGestureRecognizer(tap1)
        chip1.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(GameOverViewController.chip2Tapped))
        chip2.addGestureRecognizer(tap2)
        chip2.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(GameOverViewController.chip3Tapped))
        chip3.addGestureRecognizer(tap3)
        chip3.isUserInteractionEnabled = true
        
        chip1.startRotating()
        chip2.startRotating()
        chip3.startRotating()
        
        if (isActiveGame) {
            btnPlay.isHidden = false
            btnPlay.isEnabled = false
            btnPlay.backgroundColor = .gray
        }
        btnMenu.isHidden = false
        btnMenu.isEnabled = false
        btnMenu.backgroundColor = .gray
    }
    
    @objc func chip1Tapped() {
        updateAfterPrizeCollected()
        let prize = prizes[Int.random(in: 0..<3)]
        self.lblchip1.text = "$\(String(prize))"
        self.lblchip1.isHidden = false
        selectedPlayer = PlayersDBHelper.updatePlayerChips(player: selectedPlayer, chips: selectedPlayer.chips + prize)
    }
    
    @objc func chip2Tapped() {
        updateAfterPrizeCollected()
        let prize = prizes[Int.random(in: 0..<3)]
        lblChip2.text = "$\(String(prize))"
        lblChip2.isHidden = false
        selectedPlayer = PlayersDBHelper.updatePlayerChips(player: selectedPlayer, chips: selectedPlayer.chips + prize)
    }
    
    @objc func chip3Tapped() {
        updateAfterPrizeCollected()
        let prize = prizes[Int.random(in: 0..<3)]
        lblChip3.text = "$\(String(prize))"
        lblChip3.isHidden = false
        selectedPlayer = PlayersDBHelper.updatePlayerChips(player: selectedPlayer, chips: selectedPlayer.chips + prize)
    }
    
    func updateAfterPrizeCollected() {
        chip1.stopRotating()
        chip2.stopRotating()
        chip3.stopRotating()
        
        chip1.isUserInteractionEnabled = false
        chip2.isUserInteractionEnabled = false
        chip3.isUserInteractionEnabled = false
        
        btnPlay.isEnabled = true
        btnPlay.backgroundColor = .systemGreen
        
        btnMenu.isEnabled = true
        btnMenu.backgroundColor = .systemRed
    }
 
    
    @IBAction func exitToRootView(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension UIView {
    func startRotating(duration: Double = 1) {
        if self.layer.animation(forKey: "rotation") == nil {
            let animate = CABasicAnimation(keyPath: "transform.rotation")
            animate.duration = duration
            animate.repeatCount = Float.infinity
            animate.fromValue = 0.0
            animate.toValue = Float(.pi * 2.0)
            self.layer.add(animate, forKey: "rotation")
        }
    }
    func stopRotating() {
        if self.layer.animation(forKey: "rotation") != nil {
            self.layer.removeAnimation(forKey: "rotation")
        }
    }
}

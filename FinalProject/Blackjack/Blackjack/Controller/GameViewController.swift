//
//  GameViewController.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-04-03.
//

import UIKit

class GameViewController: UIViewController {
    // Table elements
    @IBOutlet weak var dealtCard: UIImageView!
    @IBOutlet weak var dealerCard: UIImageView!
    @IBOutlet weak var playerCard: UIImageView!
    @IBOutlet weak var lblDealerTitle: UILabel!
    @IBOutlet weak var lblDealerCount: UILabel!
    @IBOutlet weak var lblPlayerTitle: UILabel!
    @IBOutlet weak var lblPlayerCount: UILabel!
    @IBOutlet weak var lblOutput: UILabel!
    @IBOutlet weak var btnHit: UIButton!
    @IBOutlet weak var btnStand: UIButton!
    
    // Bet elements
    @IBOutlet weak var lblBet: UILabel!
    @IBOutlet weak var stepBet: UIStepper!
    @IBOutlet weak var btnPlaceBet: UIButton!
    
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var lblWinMsg: UILabel!
    @IBOutlet weak var lblWinChips: UILabel!
    @IBOutlet weak var lblWinResult: UILabel!
    @IBOutlet weak var ivWinFade: UIImageView!
    
    @IBOutlet weak var btnQuit: UIButton!
    var selectedPlayer: Player = Player()
    var game: Game!
    var bet: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  

    }
    
    override func viewDidAppear(_ animated: Bool) {
        toggleView(isBetMode: true)
        bet = Int(stepBet.value)
    }
    
    func disableButtons() {
        btnHit.isEnabled = false
        btnStand.isEnabled = false
        btnQuit.isEnabled = false
        btnHit.backgroundColor = .gray
        btnStand.backgroundColor = .gray
        btnQuit.backgroundColor = .gray
    }
    
    
    func enableButtons() {
        btnHit.isEnabled = true
        btnStand.isEnabled = true
        btnQuit.isEnabled = true
        btnHit.backgroundColor = .systemGreen
        btnStand.backgroundColor = .systemRed
        btnQuit.backgroundColor = .systemGreen
    }
    
    
    //To Perform Unwind Segue
    @IBAction func performUnwindSegueOperation(_ sender: UIStoryboardSegue) {
        guard let gameOverVC = sender.source as? GameOverViewController else { return }
        selectedPlayer = gameOverVC.selectedPlayer
        //updateViewWithPlayer(selectedPlayer: selectedPlayer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameOver" {
            guard let gameOverVC = segue.destination as? GameOverViewController else {
                return
            }
            game.clearCards()
            toggleView(isBetMode: true)
            gameOverVC.selectedPlayer = selectedPlayer
            gameOverVC.isActiveGame = true
        }
    }
    
    @IBAction func quitGame(_ sender: Any) {
        let exitToMenu: (UIAlertAction) -> Void = {_ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        AlertHelper.createTwoActionAlert(view: self,
                                         title: "Exit Game",
                                         message: "Are you sure you want to exit?",
                                         action1: UIAlertAction(title: "Lose Chips", style: UIAlertAction.Style.destructive, handler: exitToMenu),
                                         action2: UIAlertAction(title: "Keep Playing", style: UIAlertAction.Style.cancel, handler: nil))
    }
    
    
    
    @IBAction func stepBetValueChanged(_ sender: UIStepper) {
        bet = Int(sender.value)
        lblBet.text = "$ \(String(bet))"
        print("Initial bet: " + String(bet))
    }
    @IBAction func placeBet(_ sender: Any) {
        toggleView(isBetMode: false)
        print("Player chips: " + String(selectedPlayer.chips))
        print("Bet: " + String(self.bet))
        let newChips = selectedPlayer.chips - bet
        selectedPlayer = PlayersDBHelper.updatePlayerChips(player: selectedPlayer, chips: newChips)
        lblOutput.text = "Chips: \(selectedPlayer.chips)"
       
    }
    
 
    
    @IBAction func hit(_ sender: Any) {
        if (game.player.count < 22) {
            disableButtons()
            let completion: ((Bool) -> Void)?  = { [self]_ in
                btnHit.isHidden = false
                btnStand.isHidden = false
                lblPlayerCount.text = "\(game.player.count)"
                enableButtons()
                if (game.player.count > 21) {
                    lblOutput.text = "BUST!"
                    UIView.transition(with: gameOverView,
                                      duration: 0.75,
                                      options: .transitionCrossDissolve,
                                      animations: { [self] in
                                        view.bringSubviewToFront(ivWinFade)
                                        view.bringSubviewToFront(gameOverView)
                                        lblWinMsg.text = "LOSS"
                                        lblWinResult.text = "\(selectedPlayer.name) BUST's with \(game.player.count)"
                                        lblWinChips.textColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
                                        lblWinChips.text = "$ \(String(bet))"
                                                    gameOverView.isHidden = false
                                        ivWinFade.isHidden = false
                                        btnQuit.isEnabled = false
                                                    },
                                      completion: {_ in disableButtons() })
                }
                
            }
            game.hitPlayer(completion: completion)
            

        }
    }
    
    @IBAction func stand(_ sender: Any) {
        // do a flip
        // then do deal until win/loss
        if (game.player.count < 22) {
            disableButtons()
            lblDealerCount.text = "\(game.dealer.count)"
            lblPlayerCount.text = "\(game.player.count)"
            let completion: ((Bool) -> Void)?  = { [self]_ in
                lblDealerCount.text = "\(game.dealer.count)"
                lblPlayerCount.text = "\(game.player.count)"
                
                var output = "LOSS!"
                var winMsg = "LOSS!"
                var textColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
                if (game.dealer.count > 21 || game.dealer.count < game.player.count) {
                    output = "WIN!"
                    winMsg = "WIN!"
                    textColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1.0)
                    selectedPlayer = PlayersDBHelper.updatePlayerChips(player: selectedPlayer, chips: selectedPlayer.chips + bet*2)
                }
                
                lblOutput.text = output
                
                enableButtons()
                UIView.transition(with: gameOverView,
                                  duration: 0.75,
                                  options: .transitionCrossDissolve,
                                  animations: { [self] in
                                    view.bringSubviewToFront(ivWinFade)
                                    view.bringSubviewToFront(gameOverView)
                                    lblWinMsg.text = winMsg
                                    lblWinChips.textColor = textColor
                                    lblWinChips.text = "$ \(String(bet))"
                                    lblWinResult.text = "Dealer: \(game.dealer.count) Player: \(game.player.count)"
                                    gameOverView.isHidden = false
                                    ivWinFade.isHidden = false
                                    btnQuit.isEnabled = false
                                                },
                                  completion: {_ in disableButtons()})
                
            }
            game.hitDealer(completion: completion)
            
        }
    }
    
    func initGame() {
        
        let initPoscgRect = CGRect(x:dealtCard.frame.origin.x, y:dealtCard.frame.origin.y, width: dealtCard.frame.width, height: dealtCard.frame.height)
        let dealerPosCGRect = CGRect(x:dealerCard.frame.origin.x, y:dealerCard.frame.origin.y, width: dealerCard.frame.width, height: dealerCard.frame.height)
        let playerPosCGRect = CGRect(x:playerCard.frame.origin.x, y:playerCard.frame.origin.y, width: playerCard.frame.width, height: playerCard.frame.height)
        game = Game(view: view, selectedPlayer: selectedPlayer, bet: bet, initPosCGRect: initPoscgRect, dealerPosCGRect: dealerPosCGRect, playerPosCGRect: playerPosCGRect)
        game.dealInitialCards()
        
        game.printPlayerCards()
        
        let completion: ((Bool) -> Void)?  = { [self]_ in
            btnHit.isHidden = false
            btnStand.isHidden = false
            lblPlayerCount.text = "\(game.player.count)"
        }
        
        game.deal(completion: completion)
    }
    
    func toggleView(isBetMode: Bool) {
        UIView.transition(with: view,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: { [self] in
                            lblDealerTitle.isHidden = isBetMode
                            lblDealerCount.isHidden = isBetMode
                            lblPlayerTitle.isHidden = isBetMode
                            lblPlayerCount.isHidden = isBetMode
                            lblOutput.isHidden = false
                            btnHit.isHidden = true
                            btnStand.isHidden = true
                            gameOverView.isHidden = true
                            ivWinFade.isHidden = true
                            btnQuit.isEnabled = true
                            enableButtons()
                            
                            lblBet.isHidden = !isBetMode
                            stepBet.isHidden = !isBetMode
                            btnPlaceBet.isHidden = !isBetMode
                            
                            lblDealerCount.text = " "
                            lblOutput.text = "Chips: \(selectedPlayer.chips)"
                            lblBet.text = "$ \(String(Int(stepBet.value)))"
                            if (!isBetMode) {
                                lblPlayerCount.text = " "
                            }
                          },
                          completion: (isBetMode ? nil : { [self]_ in initGame()}))

    }
}

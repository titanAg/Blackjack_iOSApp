//
//  SelectPlayerViewController.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-03-22.
//
import UIKit

class SelectPlayerViewController: UITableViewController {
    @IBOutlet var selectPlayerView: UITableView!
    var players:[Player] = []
    var selectedPlayer: Player = Player()
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectPlayerView.backgroundView = UIImageView(image: UIImage( named: "table_red"))
        
        players = PlayersDBHelper.getPlayersNSArray() as! [Player]
    }
    
    @IBAction func deletePlayer(_ sender: Any) {
        if (selectPlayerView.indexPathForSelectedRow != nil) {
            PlayersDBHelper.deletePlayer(id: String(selectPlayerView.indexPathForSelectedRow!.row))
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "update") {
            guard let addVC = segue.destination as? AddPlayerViewController else {
                return
            }
            addVC.selectedPlayer = selectedPlayer
        }
        else if (segue.identifier == "add") {
            guard let addVC = segue.destination as? AddPlayerViewController else {
                return
            }
            //addVC.selectedPlayer = selectedPlayer
        }

    }
    
    //To Perform Unwind Segue
    @IBAction func performUnwindSegueOperation(_ sender: UIStoryboardSegue) {
        guard let addVC = sender.source as? AddPlayerViewController else { return }
        //selectedPlayer = addVC.selectedPlayer
        players = PlayersDBHelper.getPlayersNSArray() as! [Player]
        selectPlayerView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row > 0) {
            return 50.0
        }
        else {
            return 50.0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayersDBHelper.getPlayerCount() + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let rowColor = UIColor(red: 86/255, green: 101/255, blue: 115/255, alpha: 1)
        if (indexPath.row == 0) {
            // add
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddButtonTableViewCell
            cell.btnAdd?.frame.size = CGSize(width: 375.0, height: 30.0 )
            cell.backgroundColor = rowColor
            return cell
        }
        else if (row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! SelectButtonTableViewCell
            cell.backgroundColor = rowColor
            cell.btnSelect?.isEnabled = false
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! CustomPlayerTableViewCell
            let index = row - 2
            cell.lblUser?.text = "\(players[index].name)"
            cell.lblChips?.text = "Chips: \(players[index].chips)"
//            if (players[index].selected) {
//                let image = UIImage(named: "IconSelected.png")
//                cell.ivSelected.image = image
//            }
            
            cell.backgroundColor = rowColor
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let index = indexPath.row-2;
        if (indexPath.row > 1) {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                
                let deletePlayer: (UIAlertAction) -> Void = {_ in
                    PlayersDBHelper.deletePlayer(id: self.players[index].ID)
                    self.players = PlayersDBHelper.getPlayersNSArray() as! [Player]
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
                AlertHelper.createTwoActionAlert(view: self,
                                                 title: "Delete Player",
                                                 message: "Are you sure you want to delete \"\(self.players[index].name)\"?",
                                                 action1: UIAlertAction(title: "DELETE PLAYER", style: UIAlertAction.Style.destructive, handler: deletePlayer),
                                                 action2: UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

            }

            let updateAction = UITableViewRowAction(style: .normal, title: "Update") { (action, indexPath) in
                let cell = tableView.cellForRow(at: indexPath) as! CustomPlayerTableViewCell
                self.selectedPlayer = self.players[index]
                self.performSegue(withIdentifier: "update", sender: self)
            }
            
            deleteAction.backgroundColor = UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)
            
            updateAction.backgroundColor = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)

            return [deleteAction, updateAction]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Players"
        label.font = UIFont(name: "MarkerFelt-Wide", size: 32)
        label.textColor = .systemGray
        //label.backgroundColor = .black
        
        let label2 = UILabel()
        label2.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label2.backgroundColor = .black
            
        headerView.addSubview(label2)
        headerView.addSubview(label)

            return headerView
        }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row > 1) {
            guard let cp_cell = tableView.cellForRow(at: indexPath) as? CustomPlayerTableViewCell else {return}
            let image = UIImage(named: "IconSelected.png")
            cp_cell.ivSelected.image = image
            
            let index = indexPath.row - 2
            let selectRow = 1
            let path: IndexPath = NSIndexPath(row: selectRow, section: 0) as IndexPath
            guard let cell = tableView.cellForRow(at: path) as? SelectButtonTableViewCell else {return}
            
            cell.btnSelect?.isEnabled = true;
            selectedPlayer = players[index]
            //PlayersDBHelper.updatePlayerSelection(player: selectedPlayer, isSelected: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (indexPath.row > 1) {
            guard let cp_cell = tableView.cellForRow(at: indexPath) as? CustomPlayerTableViewCell else {return}
            let image = UIImage()
            cp_cell.ivSelected.image = image
            
//            let index = indexPath.row - 2
//            let selectRow = 1
//            let path: IndexPath = NSIndexPath(row: selectRow, section: 0) as IndexPath
//            guard let cell = tableView.cellForRow(at: path) as? SelectButtonTableViewCell else {return}
//            
//            cell.btnSelect?.isEnabled = false;
        }
    }

}

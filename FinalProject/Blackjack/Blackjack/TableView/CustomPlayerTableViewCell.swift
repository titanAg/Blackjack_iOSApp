//
//  CustomPlayerTableViewCell.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-03-24.
//

import UIKit

class CustomPlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var lblChips: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var ivSelected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

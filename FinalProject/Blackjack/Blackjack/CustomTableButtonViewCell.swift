//
//  CustomTableViewCell.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-03-24.
//

import UIKit

class CustomTableButtonViewCell: UITableViewCell {
    
    @IBOutlet weak var addButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

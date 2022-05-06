//
//  SelectButtonTableViewCell.swift
//  Blackjack
//
//  Created by Kyle Orcutt on 2022-03-29.
//

import UIKit

class SelectButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var btnSelect: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

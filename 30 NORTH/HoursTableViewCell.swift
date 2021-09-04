//
//  HoursTableViewCell.swift
//  30 NORTH
//
//  Created by vinay on 21/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class HoursTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

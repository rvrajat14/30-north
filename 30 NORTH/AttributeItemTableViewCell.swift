//
//  AttributeItemTableViewCell.swift
//  30 NORTH
//
//  Created by admin on 03/10/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class AttributeItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstAttributeButton: UIButton!
    @IBOutlet weak var secondAttributeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

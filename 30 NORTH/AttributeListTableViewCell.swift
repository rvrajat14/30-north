//
//  AttributeListTableViewCell.swift
//  30 NORTH
//
//  Created by admin on 07/10/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class AttributeListTableViewCell: UITableViewCell {

    @IBOutlet weak var attributeTitle: UILabel!
    @IBOutlet weak var attributeName: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

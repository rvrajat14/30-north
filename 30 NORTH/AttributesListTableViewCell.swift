//
//  AttributesListTableViewCell.swift
//  30 NORTH
//
//  Created by admin on 05/09/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class AttributesListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var plusImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

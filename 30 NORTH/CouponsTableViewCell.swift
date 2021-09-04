//
//  CouponsTableViewCell.swift
//  30 NORTH
//
//  Created by vinay on 28/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class CouponsTableViewCell: UITableViewCell {

    @IBOutlet weak var couponName: UILabel!
    @IBOutlet weak var couponCode: UILabel!
    @IBOutlet weak var copyToClipboardButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

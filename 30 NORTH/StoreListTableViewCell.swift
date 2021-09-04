//
//  StoreListTableViewCell.swift
//  30 NORTH
//
//  Created by vinay on 06/06/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class StoreListTableViewCell: UITableViewCell {

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var openUntil: UILabel!
    @IBOutlet weak var miles: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

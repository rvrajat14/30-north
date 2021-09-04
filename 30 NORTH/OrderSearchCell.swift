//
//  OrderSearchCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 26/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class OrderSearchCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = ""
			titleLabel.font = UIFont(name: AppFontName.regular, size: 17)
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

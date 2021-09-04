//
//  CoffeeProfileCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 22/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class CoffeeProfileCell: UITableViewCell {

	@IBOutlet weak var leftLabel: UILabel! {
		didSet {
			leftLabel.text = nil
			leftLabel.numberOfLines = 0
			leftLabel.textAlignment = .left
			leftLabel.textColor = UIColor.gold
			leftLabel.backgroundColor = .clear
            leftLabel.font = UIFont(name: AppFontName.regular, size: 16)!
		}
	}

	@IBOutlet weak var rightLabel: UILabel! {
		didSet {
			rightLabel.text = nil
			rightLabel.numberOfLines = 0
			rightLabel.textAlignment = .left
			rightLabel.textColor = UIColor.white
			rightLabel.backgroundColor = .clear
            rightLabel.font = UIFont(name: AppFontName.regular, size: 16)!
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

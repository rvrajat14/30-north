//
//  OutletCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 22/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class OutletCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel! {
		didSet {
			nameLabel.text = nil
			nameLabel.numberOfLines = 0
			nameLabel.textColor = UIColor.white
			nameLabel.font = UIFont(name: AppFontName.regular, size: 14)
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

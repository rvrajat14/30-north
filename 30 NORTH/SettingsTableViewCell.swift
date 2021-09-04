//
//  SettingsTableViewCell.swift
//  30 NORTH
//
//  Created by Apple on 4/6/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.textColor = UIColor.white
			titleLabel.font = UIFont(name: AppFontName.bold, size: 20)
			titleLabel.textAlignment = .center
		}
	}

	@IBOutlet weak var accessoryImageView: UIImageView! {
		didSet {
			accessoryImageView.contentMode = .scaleAspectFit
			accessoryImageView.clipsToBounds = true
			accessoryImageView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var lineView: UIView! {
		didSet {
			lineView.clipsToBounds = true
			lineView.backgroundColor = UIColor.homeLineViewGrey
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

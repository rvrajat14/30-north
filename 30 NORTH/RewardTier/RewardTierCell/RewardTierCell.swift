//
//  RewardTierCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 12/06/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class RewardTierCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = ""
			titleLabel.textAlignment = .left
			titleLabel.numberOfLines = 0
			titleLabel.font = UIFont(name:AppFontName.regular, size:16)
			titleLabel.adjustsFontSizeToFitWidth = true
			titleLabel.minimumScaleFactor = 0.5
			titleLabel.textColor = .black
			titleLabel.clipsToBounds = true
		}
	}
	@IBOutlet weak var detailLabel: UILabel! {
		didSet {
			detailLabel.text = ""
			detailLabel.textAlignment = .center
			detailLabel.numberOfLines = 0
			detailLabel.font = UIFont(name:AppFontName.regular, size:15)
			detailLabel.adjustsFontSizeToFitWidth = true
			detailLabel.minimumScaleFactor = 0.5
			detailLabel.textColor = .black
			detailLabel.clipsToBounds = true
		}
	}
	@IBOutlet weak var cellImageView: UIImageView!{
		didSet {
			cellImageView.contentMode = .scaleAspectFit
			cellImageView.clipsToBounds = true
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

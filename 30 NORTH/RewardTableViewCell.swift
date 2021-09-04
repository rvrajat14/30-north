//
//  RewardTableViewCell.swift
//  30 NORTH
//
//  Created by vinay on 25/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class RewardTableViewCell: UITableViewCell {

	@IBOutlet weak var innerView: UIView! {
		didSet {
			innerView.clipsToBounds = true
			innerView.layer.cornerRadius = 3.0
			innerView.layer.borderColor = UIColor.darkGray.cgColor
			innerView.layer.borderWidth = 0.5
			innerView.backgroundColor = UIColor(displayP3Red: 0.082, green: 0.086, blue: 0.094, alpha: 1.0)
		}
	}

	@IBOutlet weak var rewardImage: UIImageView!{
		didSet {
			rewardImage.clipsToBounds = true
		}
	}
    @IBOutlet weak var rewardTitle: UILabel!
    @IBOutlet weak var rewardDesc: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

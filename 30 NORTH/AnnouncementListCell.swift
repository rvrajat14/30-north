//
//  AnnouncementListCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 18/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class AnnouncementListCell: UITableViewCell {

	@IBOutlet weak var innerView: UIView! {
		didSet {
			innerView.layer.cornerRadius = 3.0
			innerView.layer.borderColor = UIColor.white.cgColor
			innerView.layer.borderWidth = 0.0
            innerView.backgroundColor = UIColor.black //UIColor(displayP3Red: 0.082, green: 0.086, blue: 0.094, alpha: 1.0)
			//innerView.addShadowEffect()
		}
	}
	@IBOutlet weak var countryLabel: UILabel! {
		didSet {
			countryLabel.text = nil
			countryLabel.numberOfLines = 0
			countryLabel.textColor = UIColor.darkGray
			countryLabel.backgroundColor = .clear
            countryLabel.font = UIFont(name: "NexaBold", size: 16)
		}
	}

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = nil
			titleLabel.numberOfLines = 0
			titleLabel.textColor = UIColor.white
			titleLabel.backgroundColor = .clear
			//titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            titleLabel.font = UIFont(name: "NexaBold", size: 14)

		}
	}

	@IBOutlet weak var descriptionLabel: UILabel! {
		didSet {
			descriptionLabel.text = nil
			descriptionLabel.numberOfLines = 2
			descriptionLabel.textColor = UIColor.white
			//descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            descriptionLabel.font = UIFont(name: "NexaLight", size: 14)

		}
	}
	@IBOutlet weak var iconImage: UIImageView! {
		didSet {
			iconImage.image = nil
			iconImage.layer.cornerRadius = 12
			iconImage.clipsToBounds = true
		}
	}
	@IBOutlet weak var learnMore: UIButton! {
		didSet {
			learnMore.setTitle("More", for: .normal)
			learnMore.setTitleColor(UIColor.white, for: .normal)
			learnMore.backgroundColor = UIColor.gold
			learnMore.layer.cornerRadius = 3.0
			learnMore.clipsToBounds = true
			learnMore.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
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

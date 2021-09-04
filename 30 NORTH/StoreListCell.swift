//
//  StoreListCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 23/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class StoreListCell: UITableViewCell {

	@IBOutlet weak var innerView: UIView! {
		didSet {
			innerView.layer.cornerRadius = 3.0
			innerView.layer.borderColor = UIColor.darkGray.cgColor
			innerView.layer.borderWidth = 0.0
            innerView.backgroundColor = UIColor.black //UIColor(displayP3Red: 0.082, green: 0.086, blue: 0.094, alpha: 1.0)
			//innerView.addShadowEffect()
		}
	}

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = nil
			titleLabel.numberOfLines = 0
			titleLabel.textColor = UIColor.gold
			titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		}
	}

	@IBOutlet weak var addressLabel: UILabel! {
		didSet {
			addressLabel.text = nil
			addressLabel.numberOfLines = 0
			addressLabel.textColor = UIColor.white
			addressLabel.font = UIFont(name: AppFontName.regular, size: 14)
		}
	}
	@IBOutlet weak var areaLabel: UILabel! {
		didSet {
			areaLabel.text = nil
			areaLabel.numberOfLines = 0
			areaLabel.textColor = UIColor.white
			areaLabel.font = UIFont(name: AppFontName.regular, size: 14)
		}
	}
	@IBOutlet weak var openLabel: UILabel! {
		didSet {
			openLabel.text = nil
			openLabel.numberOfLines = 0
			openLabel.textColor = UIColor.white
			openLabel.font = UIFont(name: AppFontName.regular, size: 14)
		}
	}
	@IBOutlet weak var iconImage: UIImageView! {
		didSet {
			iconImage.image = nil
			iconImage.layer.cornerRadius = 12
			iconImage.clipsToBounds = true
		}
	}

	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet var iconView: [UIImageView]! {
		didSet {
			iconView.forEach { (imageView) in
				imageView.isHidden = true
				imageView.image = nil
				imageView.layer.cornerRadius = 3.0
				imageView.clipsToBounds = true
			}
		}
	}

	@IBOutlet weak var learnMore: UIButton! {
		didSet {
			learnMore.setTitle("Details", for: .normal)
			learnMore.setTitleColor(UIColor.white, for: .normal)
			learnMore.backgroundColor = UIColor.gold
			learnMore.layer.cornerRadius = 3.0
			learnMore.clipsToBounds = true
			learnMore.titleLabel?.font = UIFont(name: AppFontName.regular, size: 17)
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

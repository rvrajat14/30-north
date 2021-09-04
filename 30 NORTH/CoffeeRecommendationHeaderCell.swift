//
//  CoffeeRecommendationHeaderCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 29/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class CoffeeRecommendationHeaderCell: UICollectionViewCell {
	

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = nil
			titleLabel.numberOfLines = 0
			titleLabel.textColor = UIColor.gold
			titleLabel.backgroundColor = UIColor.clear
			titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
		}
	}

	@IBOutlet weak var backView: UIView! {
		didSet {
		 backView.layer.borderColor = UIColor.darkGray.cgColor
		 backView.layer.borderWidth = 0.5
		 backView.layer.cornerRadius = 5.0

		 backView.contentMode = .scaleAspectFill
		 backView.clipsToBounds = true
		 backView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var descriptionLabel: UILabel! {
		didSet {
			descriptionLabel.text = nil
			descriptionLabel.numberOfLines = 0
			descriptionLabel.textColor = UIColor.gold
			descriptionLabel.textAlignment = .center
			descriptionLabel.backgroundColor = UIColor.clear
			descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		}
	}

	@IBOutlet weak var nameLabel: UILabel! {
		didSet {
			nameLabel.text = nil
			nameLabel.numberOfLines = 0
			nameLabel.textColor = UIColor.white
			nameLabel.textAlignment = .center
			nameLabel.backgroundColor = UIColor.clear
			nameLabel.font = UIFont(name: AppFontName.bold, size: 18)
		}
	}

	 @IBOutlet weak var imageView: UIImageView! {
		didSet {
			imageView.layer.borderColor = UIColor.darkGray.cgColor
			imageView.layer.borderWidth = 0.5
			imageView.layer.cornerRadius = 5.0

			imageView.contentMode = .scaleAspectFill
			imageView.clipsToBounds = true
			imageView.backgroundColor = .clear
		}
	}
}

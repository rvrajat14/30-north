//
//  OrderItemCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 24/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class OrderItemCell: UICollectionViewCell {
	

	@IBOutlet weak var categoryLabel: UILabel! {
		didSet {
			categoryLabel.text = nil
			categoryLabel.numberOfLines = 0
			categoryLabel.textColor = UIColor.gold
			categoryLabel.backgroundColor = UIColor.clear
			categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		}
	}
	
	@IBOutlet weak var subCategoryLabel: UILabel! {
		didSet {
			subCategoryLabel.text = nil
			subCategoryLabel.numberOfLines = 0
			subCategoryLabel.textColor = .white
			subCategoryLabel.backgroundColor = UIColor.clear
			subCategoryLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
		}
	}

	@IBOutlet weak var nameLabel: UILabel! {
		didSet {
			nameLabel.text = nil
			nameLabel.numberOfLines = 0
            nameLabel.textColor = UIColor.white
			nameLabel.backgroundColor = UIColor.clear
			nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		}
	}

	@IBOutlet weak var priceLabel: UILabel! {
		didSet {
			priceLabel.text = nil
			priceLabel.numberOfLines = 0
			priceLabel.textColor = UIColor.white
			priceLabel.backgroundColor = UIColor.clear
			//priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

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

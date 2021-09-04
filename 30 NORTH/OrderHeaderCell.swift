//
//  OrderHeaderCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 24/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class OrderHeaderCell: UICollectionViewCell {

	@IBOutlet weak var categoryLabel: UILabel! {
		didSet {
			categoryLabel.text = nil
			categoryLabel.numberOfLines = 0
			categoryLabel.textColor = UIColor.gold
			categoryLabel.backgroundColor = UIColor.clear
			categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		}
	}

    @IBOutlet weak var imageView: UIImageView! {
		didSet {
            imageView.layer.borderColor = UIColor.darkGray.cgColor
            imageView.layer.borderWidth = 0.5
			 imageView.layer.cornerRadius = 5.0
            
            //Scale aspect fit so that pattern behind the image can be seen.
			 imageView.contentMode = .scaleAspectFill
			 imageView.clipsToBounds = true
			 imageView.backgroundColor = .clear
		}
	}
	
}

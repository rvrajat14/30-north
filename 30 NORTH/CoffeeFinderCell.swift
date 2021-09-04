//
//  CoffeeFinderCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 13/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class CoffeeFinderCell: UICollectionViewCell {

	@IBOutlet weak var textLabel: UILabel! {
		didSet {
			textLabel.text = nil
			textLabel.textAlignment = .center
			textLabel.numberOfLines = 0
			textLabel.textColor = UIColor.gold
			textLabel.backgroundColor = UIColor.clear
			textLabel.font = UIFont(name:AppFontName.regular, size:14)
		}
	}

	@IBOutlet weak var imageView: UIImageView! {
		didSet {
			imageView.layer.borderColor = UIColor.darkGray.cgColor
			imageView.layer.borderWidth = 0
			 imageView.layer.cornerRadius = 5.0

			//Scale aspect fit so that pattern behind the image can be seen.
			 imageView.contentMode = .scaleAspectFit
			 imageView.clipsToBounds = true
			 imageView.backgroundColor = .clear
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

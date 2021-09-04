//
//  PickupPlaceCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 09/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class PickupPlaceCell: UICollectionViewCell {

     var isGreyedOut: Bool = false
    
	override var isSelected: Bool {
		didSet{
			if self.isSelected {
				self.placeLabel.textColor = UIColor.gold
				self.checkbox.backgroundColor = UIColor.gold
			}
			else {
				self.placeLabel.textColor = UIColor.white
				self.checkbox.backgroundColor = UIColor.clear
			}
		}
	}
    
    
    

	@IBOutlet weak var placeLabel: UILabel! {
		didSet {
			placeLabel.text = nil
			placeLabel.numberOfLines = 0
			placeLabel.textColor = UIColor.white
			placeLabel.backgroundColor = UIColor.clear
			placeLabel.font = UIFont(name: AppFontName.regular, size: 16)
		}
	}

	@IBOutlet weak var checkbox: UILabel! {
	   didSet {
			checkbox.layer.borderColor = UIColor.gold.cgColor
			checkbox.layer.borderWidth = 1.0
			checkbox.layer.cornerRadius = checkbox.frame.width/2.0
			checkbox.clipsToBounds = true
			checkbox.backgroundColor = .clear
	   }
   }
}

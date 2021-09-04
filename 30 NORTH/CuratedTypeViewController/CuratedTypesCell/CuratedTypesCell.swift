//
//  CuratedTypesCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 12/06/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class CuratedTypesCell: UITableViewCell {

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
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

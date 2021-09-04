//
//  AnnouncementCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 27/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class AnnouncementCell: UICollectionViewCell {

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = ""
			titleLabel.textAlignment = .left
			titleLabel.font = UIFont(name:AppFontName.bold, size:30)
			titleLabel.textColor = .white
		}
	}
	@IBOutlet weak var descriptionLabel: UILabel!{
		didSet {
			descriptionLabel.text = ""
			descriptionLabel.textAlignment = .left
			descriptionLabel.font = UIFont(name:AppFontName.regular, size:14)
			descriptionLabel.textColor = .white
		}
	}
	@IBOutlet weak var notesLabel: UILabel!{
		didSet {
			notesLabel.text = ""
			notesLabel.textAlignment = .left
			notesLabel.font = UIFont(name:AppFontName.regular, size:12)
			notesLabel.textColor = .white
		}
	}

    @IBOutlet weak var previousButton: UIButton! {
		didSet {
			previousButton.setImage(UIImage(named: "previous-icon"), for: .normal)
			previousButton.setTitle("", for: .normal)
			previousButton.imageView?.contentMode = .scaleAspectFit
		}
	}

	@IBOutlet weak var goButton: UIButton! {
		didSet {
			goButton.layer.cornerRadius = 3.0
			goButton.clipsToBounds = true
			goButton.backgroundColor = UIColor.gold

			goButton.setTitle("GO", for: .normal)
			goButton.setTitleColor(.white, for: .normal)
			goButton.titleLabel?.font = UIFont(name:AppFontName.bold, size: 18)
		}
	}

	@IBOutlet weak var nextButton: UIButton! {
		didSet {
			nextButton.setImage(UIImage(named: "next-icon"), for: .normal)
			nextButton.setTitle("", for: .normal)
			nextButton.imageView?.contentMode = .scaleAspectFit
		}
	}
}

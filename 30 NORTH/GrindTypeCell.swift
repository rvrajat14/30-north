//
//  GrindTypeCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 18/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class GrindTypeCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = ""
			titleLabel.textColor = .black
			titleLabel.font = UIFont(name: AppFontName.regular, size: 17)
		}
	}

    @IBOutlet weak var plusImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

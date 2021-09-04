//
//  ItemCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 28/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

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
    @IBOutlet weak var discountNameLabel: UILabel! {
       didSet {
           discountNameLabel.text = nil
           discountNameLabel.numberOfLines = 0
           discountNameLabel.textColor = UIColor.gold
           discountNameLabel.backgroundColor = UIColor.clear
           //priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
           //discountNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .thin)
            discountNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)


       }
       }
	@IBOutlet weak var itemImageView: UIImageView! {
	   didSet {
			itemImageView.layer.borderColor = UIColor.clear.cgColor
			itemImageView.layer.borderWidth = 0.0
			itemImageView.layer.cornerRadius = 3.0
			itemImageView.contentMode = .scaleAspectFill
			itemImageView.clipsToBounds = true
			itemImageView.backgroundColor = .clear
	   }
	}

	@IBOutlet weak var lineView: UIView! {
		didSet {
			lineView.clipsToBounds = true
		}
	}
	@IBOutlet weak var descLabel: UILabel! {
		didSet {
			descLabel.text = nil
			descLabel.numberOfLines = 0
			descLabel.textColor = UIColor.white
			descLabel.backgroundColor = UIColor.clear
			descLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		}
	}

	@IBOutlet weak var leftView: UIView! {
		didSet {
			leftView.clipsToBounds = true
			leftView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var rightView: UIView! {
		didSet {
			rightView.clipsToBounds = true
			rightView.backgroundColor = .clear
		}
	}

	@IBOutlet var leftIconView: [UIImageView]! {
		didSet {
			leftIconView.forEach { (imageView) in
				self.configureIcon(sender: imageView)
			}
		}
	}
	@IBOutlet var rightIconView: [UIImageView]!{
		didSet {
			rightIconView.forEach { (imageView) in
				self.configureIcon(sender: imageView)
			}
		}
	}

	@IBOutlet var leftLabel: [UILabel]! {
		didSet {
			leftLabel.forEach { (label) in
				self.configureLabel(sender: label)
			}
		}
	}

	@IBOutlet var rightLabel: [UILabel]!{
		didSet {
			rightLabel.forEach { (label) in
				self.configureLabel(sender: label)
			}
		}
	}

	private func configureIcon(sender:UIImageView) {
		sender.contentMode = .scaleAspectFit
		sender.clipsToBounds = true
	}

	private func configureLabel(sender:UILabel) {
		sender.font = UIFont(name: AppFontName.regular, size: 18)
		sender.textColor = .white
	}
}

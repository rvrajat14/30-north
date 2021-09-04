//
//  SubscriptionCell.swift
//  30 NORTH
//
//  Created by Anil Kumar on 18/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation

class SubscriptionCell: UITableViewCell {

    @IBOutlet weak var innerView: UIView! {
        didSet {
            innerView.layer.cornerRadius = 3.0
            innerView.clipsToBounds = true
            innerView.backgroundColor = UIColor.black
        }
    }

    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.backgroundColor = UIColor.clear
        }
    }

    @IBOutlet weak var orderNumber: UILabel! {
        didSet {
            orderNumber.font = UIFont(name: AppFontName.bold, size: 18)
            orderNumber.textColor = .white
        }
    }

    @IBOutlet weak var totalAmount: UILabel!{
        didSet {
            totalAmount.font = UIFont(name: AppFontName.regular, size: 16)
            totalAmount.textColor = .white
        }
    }

    @IBOutlet weak var frequencyLabel: UILabel!{
        didSet {
            frequencyLabel.font = UIFont(name: AppFontName.regular, size: 16)
            frequencyLabel.textColor = .white
        }
    }

    @IBOutlet weak var beansLabel: UILabel!{
        didSet {
            beansLabel.font = UIFont(name: AppFontName.regular, size: 16)
            beansLabel.textColor = .white
        }
    }

    @IBOutlet weak var quantityLabel: UILabel!{
       didSet {
           quantityLabel.font = UIFont(name: AppFontName.regular, size: 16)
           quantityLabel.textColor = .white
       }
   }

	@IBOutlet weak var endedLabel: UILabel!{
		didSet {
			endedLabel.font = UIFont(name: AppFontName.regular, size: 16)
			endedLabel.textColor = .white
		}
	}

    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(.white, for: .normal)
            cancelButton.backgroundColor = UIColor.gold
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

            cancelButton.layer.cornerRadius = 3.0
            cancelButton.clipsToBounds = true
        }
    }
}


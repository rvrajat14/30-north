//
//  CustomPopupViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 19/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class CustomPopupViewController: UIViewController {
	
	@IBOutlet weak var contentView: UIView! {
		didSet {
			contentView.backgroundColor = .black
			contentView.layer.borderColor = UIColor.white.cgColor
			contentView.layer.borderWidth = 1.0
			contentView.layer.cornerRadius = 20.0
			contentView.clipsToBounds = true
		}
	}

	@IBOutlet weak var logoImageView: UIImageView! {
		didSet {
			logoImageView.image = UIImage(named: "Logo")
			logoImageView.contentMode = .scaleAspectFit
			logoImageView.backgroundColor = UIColor.clear
		}
	}

	@IBOutlet weak var imageView: UIImageView! {
		didSet {
			imageView.image = nil
			imageView.contentMode = .scaleAspectFit
			imageView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = ""
			titleLabel.textAlignment = .center
			titleLabel.textColor = self.titleColor
			titleLabel.font = self.titleFont
		}
	}

	@IBOutlet weak var descriptionTextView: UITextView! {
		didSet {
			descriptionTextView.text = ""
			descriptionTextView.textColor = self.descColor
			descriptionTextView.textAlignment = .center
			descriptionTextView.isEditable = false
			descriptionTextView.isSelectable = false
			descriptionTextView.font = self.descFont
		}
	}

	var titleText: String?
	var descText: String?
	var imagePath:String?

	var titleColor = UIColor(red: 186/255, green: 140/255, blue: 43/255, alpha: 1)
	var descColor = UIColor.white

	var titleFont = UIFont(name: AppFontName.bold, size: 17)!
	var descFont = UIFont(name: AppFontName.regular, size: 16)!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.setupUIandContent()
	}

	func setupUIandContent() {
		self.loadImage()
		self.titleLabel.attributedText = NSAttributedString(string: self.titleText ?? "")
		self.descriptionTextView.attributedText = NSAttributedString(string: self.descText ?? "")

		self.titleLabel.textColor = self.titleColor
		self.titleLabel.font = self.titleFont

		self.descriptionTextView.textColor = self.descColor
		self.descriptionTextView.font = self.descFont
	}

	func loadImage() {
		let imageHeightConstraint = self.imageView.constraints.filter { (constraint) -> Bool in
			return constraint.identifier == "IMAGEVIEWHEIGHTCONSTRAINT"
		}.first
		imageHeightConstraint?.constant = 0
		self.imageView.image = nil

		if let imageURL = self.imagePath {
			self.imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
				if(status == STATUS.success) {
					imageHeightConstraint?.constant = 200
					print(url + " is loaded successfully.")
				} else {
					imageHeightConstraint?.constant = 0
					print("Error in loading image" + msg)
				}
			}
		}
	}

	func configureView(title:String, description:String, imagePath:String?, titleColor:UIColor, descColor:UIColor, titleFont:UIFont, descFont:UIFont) {

		self.imagePath = imagePath

		self.titleText = title
		self.descText = description

		self.titleColor = titleColor
		self.titleFont = titleFont

		self.descColor = descColor
		self.descFont = descFont
	}

}

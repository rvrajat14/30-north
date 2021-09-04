//
//  OverlayViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 12/06/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {

	var data: NSDictionary? = nil {
		didSet {
			if let title = data?.value(forKey: "title") as? String {
				titleLabel.text = title
			}
			if let desc = data?.value(forKey: "description") as? String {
				descriptionLabel.text = desc
			}

			if let data = data?.value(forKey: "data") as? [[String:String]] {
				data.enumerated().forEach { (index, object) in
					imageView[index].image = UIImage(named: object["image"] ?? "1")

					textLabel[index].text = object["title"]
					detailLabel[index].text = object["detail"]
					noteLabel[index].text = object["note"]
				}
			}
		}
	}

	lazy var titleLabelBottomConstraint:NSLayoutConstraint? = {
		let constraint = self.view.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "TitleLabelBottomConstraint"
		}
		return constraint
	}()
	lazy var descriptionLabelBottomConstraint:NSLayoutConstraint? = {
		let constraint = self.view.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "DescriptionLabelBottomConstraint"
		}
		return constraint
	}()
	lazy var view1BottomConstraint:NSLayoutConstraint? = {
		let constraint = self.view.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "View1BottomConstraint"
		}
		return constraint
	}()
	lazy var view2BottomConstraint:NSLayoutConstraint? = {
		let constraint = self.view.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "View2BottomConstraint"
		}
		return constraint
	}()
	lazy var view3BottomConstraint:NSLayoutConstraint? = {
		let constraint = self.view.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "View3BottomConstraint"
		}
		return constraint
	}()

	@IBOutlet weak var logoImageView: UIImageView! {
		didSet{
			logoImageView.image = UIImage(named: "newLogoWhite")
			logoImageView.contentMode = .scaleAspectFit
			logoImageView.clipsToBounds = true
			logoImageView.backgroundColor = .clear
		}
	}
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var titleLabel: UILabel!{
		didSet {
			titleLabel.text = ""
			titleLabel.textColor = UIColor.black
			titleLabel.numberOfLines = 0
			titleLabel.font = UIFont(name: AppFontName.nexaBlack, size: 23)
		}
	}
	@IBOutlet weak var descriptionLabel: UILabel!{
		didSet {
			descriptionLabel.text = ""
			descriptionLabel.textColor = UIColor.black
			descriptionLabel.numberOfLines = 0
			descriptionLabel.font = UIFont(name: AppFontName.regular, size: 16)
		}
	}

	@IBOutlet weak var view1: UIView! {
		didSet {
			view1.backgroundColor = .clear
			view1.clipsToBounds = true
		}
	}
	@IBOutlet weak var view2: UIView!{
		didSet {
			view2.backgroundColor = .clear
			view2.clipsToBounds = true
		}
	}
	@IBOutlet weak var view3: UIView!{
		didSet {
			view3.backgroundColor = .clear
			view3.clipsToBounds = true
		}
	}

	@IBOutlet var imageView: [UIImageView]!{
		didSet {
			imageView.forEach { (iv) in
				iv.contentMode = .scaleAspectFit
				iv.clipsToBounds = true
				iv.backgroundColor = .clear
			}
		}
	}

	@IBOutlet var textLabel: [UILabel]!{
		didSet {
			textLabel.forEach { (label) in
				label.text = ""
				label.textColor = UIColor.black
				label.numberOfLines = 0
				label.font = UIFont(name: AppFontName.regular, size: 16)
			}
		}
	}


	@IBOutlet var detailLabel: [UILabel]!{
		didSet {
			detailLabel.forEach { (label) in
				label.text = ""
				label.textColor = UIColor.black
				label.numberOfLines = 0
				label.font = UIFont(name: AppFontName.regular, size: 16)
			}
		}
	}

	@IBOutlet var noteLabel: [UILabel]!{
		didSet {
			noteLabel.forEach { (label) in
				label.text = ""
				label.textColor = UIColor.black
				label.numberOfLines = 0
				label.font = UIFont(name: AppFontName.regular, size: 16)
			}
		}
	}

	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		configureView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.isNavigationBarHidden = false
	}

	func configureView() {
		self.view.backgroundColor = .white
		setupConstraints()
	}

	func setupConstraints() {
		let screenBounds = UIScreen.main.bounds
		var margin:CGFloat = 20
		if screenBounds.height <= 667 {
			margin = 8
		} else if screenBounds.height <= 736 {
			margin = 12
		} else if screenBounds.height <= 812 {
			margin = 16
		} else {
			margin = 20
		}

		//Set margins
		self.titleLabelBottomConstraint?.constant = margin
		self.descriptionLabelBottomConstraint?.constant = margin
		self.view1BottomConstraint?.constant = margin
		self.view2BottomConstraint?.constant = margin
		self.view3BottomConstraint?.constant = margin
	}

	@IBAction func closeAction(_ sender: UIButton) {
		self.dismiss(animated: true) {
			print("Closed")
		}
	}
}

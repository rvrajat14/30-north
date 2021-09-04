//
//  CoffeeDetailViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 19/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import WebKit

class CoffeeDetailViewController: UIViewController {
	let titleColor = UIColor.gold
	let titleFont = UIFont(name: AppFontName.bold, size: 18)!
	let descriptionFont = UIFont(name: AppFontName.regular, size: 18)!
	let profileFont = UIFont(name: AppFontName.bold, size: 16)!
	let profileTextFont = UIFont(name: AppFontName.regular, size: 16)!

	var cupping:Cupping? = nil

	@IBOutlet weak var titleLabel: UILabel!{
		didSet {
			titleLabel.text = ""
			titleLabel.textAlignment = .left
			titleLabel.textColor = UIColor.gold
			titleLabel.font = self.titleFont
		}
	}
	@IBOutlet weak var imageView: UIImageView! {
		didSet {
			imageView.contentMode = .scaleAspectFit
			imageView.clipsToBounds = true
		}
	}
	@IBOutlet weak var descriptionLabel: UILabel!{
		didSet {
			descriptionLabel.text = ""
			descriptionLabel.textAlignment = .left
			descriptionLabel.textColor = .white
			descriptionLabel.font = self.descriptionFont
		}
	}
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
			tableView.separatorStyle = .none
			tableView.estimatedRowHeight = 30
			tableView.backgroundColor = UIColor.clear
		}
	}
	@IBOutlet weak var profileTitleLabel: UILabel!{
		didSet {
			profileTitleLabel.text = ""
			profileTitleLabel.textAlignment = .left
			profileTitleLabel.backgroundColor = .clear
			profileTitleLabel.textColor = .white
			profileTitleLabel.font = self.profileFont
		}
	}

	@IBOutlet weak var profileTextView: UITextView! {
		didSet {
			profileTextView.textContainerInset = UIEdgeInsets(top: 8, left: -5, bottom: 8, right: 0)
			profileTextView.text = ""
			profileTextView.isEditable = false
			profileTextView.isSelectable = false
			profileTextView.textAlignment = .left
			profileTextView.backgroundColor = .clear
			profileTextView.textColor = .white
			profileTextView.font = self.profileTextFont
		}
	}


	@IBOutlet weak var getCoffeeButton: UIButton! {
		didSet {
			getCoffeeButton.layer.cornerRadius = 8.0
			getCoffeeButton.clipsToBounds = true
			getCoffeeButton.backgroundColor = self.titleColor

			getCoffeeButton.setTitle("Get This Coffee", for: .normal)
			getCoffeeButton.setTitleColor(.white, for: .normal)
			getCoffeeButton.titleLabel?.font = self.titleFont
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        // Do any additional setup after loading the view.
		configureView()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        setNavigationItem()
		updateBackButton()
		self.showCartButton()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

    func setNavigationItem() {
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
    }

	func updateBackButton() {
	   let backItem = UIBarButtonItem()
	   backItem.title = ""
	   navigationItem.backBarButtonItem = backItem
   }

	//MARK: Private method
	func configureView() {
		guard let cupping = self.cupping else {
			return
		}

		if let imagePath = cupping.banner_path {
			let imageURL = configs.imageUrl + imagePath
			self.imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
			   if(status == STATUS.success) {
				print("Loaded flag image successfully: \(msg)")
			   } else {
				  print("Error in loading image: \(msg)")
			   }
			}
		}
		titleLabel.text = cupping.title
		descriptionLabel.text = cupping.desc
		profileTitleLabel.text = cupping.cupping_profile_title

		let ps = NSMutableParagraphStyle()
		ps.lineSpacing = 5
		if let cupping_profile_text = cupping.cupping_profile_text {
			let attributes = [NSAttributedString.Key.font:self.profileTextFont, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.paragraphStyle:ps] as [NSAttributedString.Key: Any]
			let attributedText = NSMutableAttributedString(string: cupping_profile_text, attributes: attributes)
			self.profileTextView.attributedText = attributedText
		}

		let tableHeightConstraint = self.tableView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "TableViewHeightConstraint"
		}
		tableHeightConstraint?.constant = 188 // 35(Row Height) * 6 (Number of Rows) + 8 margin
	}

	@IBAction func getCoffeeAction(_ sender: UIButton) {
		let coffeeRecommendationVC = self.storyboard?.instantiateViewController(identifier: "CoffeeRecommendationViewController") as? CoffeeRecommendationViewController
		coffeeRecommendationVC?.selectedCupping = self.cupping
		self.navigationController?.pushViewController(coffeeRecommendationVC!, animated: true)
	}
}

extension CoffeeDetailViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeProfileCell", for: indexPath) as? CoffeeProfileCell

		switch indexPath.row {
		case 0:
			cell?.leftLabel?.text = self.cupping?.text_1_title
			cell?.rightLabel?.text = self.cupping?.text_1
		case 1:
			cell?.leftLabel?.text = self.cupping?.text_2_title
			cell?.rightLabel?.text = self.cupping?.text_2
		case 2:
			cell?.leftLabel?.text = self.cupping?.text_3_title
			cell?.rightLabel?.text = self.cupping?.text_3
		case 3:
			cell?.leftLabel?.text = self.cupping?.text_4_title
			cell?.rightLabel?.text = self.cupping?.text_4
		case 4:
			cell?.leftLabel?.text = self.cupping?.text_5_title
			cell?.rightLabel?.text = self.cupping?.text_5
		case 5:
			cell?.leftLabel?.text = self.cupping?.text_6_title
			cell?.rightLabel?.text = self.cupping?.text_6
		default:
			break
		}

		cell?.selectionStyle = .none
		cell?.backgroundColor = .clear
		return cell!
	}
}

extension CoffeeDetailViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _ = EZLoadingActivity.hide()
    }

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		_ = EZLoadingActivity.hide()
	}
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

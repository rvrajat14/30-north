//
//  OutletPopupViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 22/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire

public typealias OutletHandler = (_ option:Outlet) -> Void

class OutletPopupViewController: UIViewController {

	var didSelectOutlet:OutletHandler? = nil
	var option:NSDictionary?
	var shop: Shop?

	var titleColor = UIColor(red: 186/255, green: 140/255, blue: 43/255, alpha: 1)
	var titleFont = UIFont(name: AppFontName.bold, size: 17)!

	@IBOutlet weak var logoImageView: UIImageView! {
		didSet {
			logoImageView.image = UIImage(named: "Logo")
			logoImageView.contentMode = .scaleAspectFit
			logoImageView.backgroundColor = UIColor.clear
		}
	}

	@IBOutlet weak var contentView: UIView! {
		didSet {
			contentView.backgroundColor = .black
			contentView.layer.borderColor = UIColor.white.cgColor
			contentView.layer.borderWidth = 1.0
			contentView.layer.cornerRadius = 8.0
			contentView.clipsToBounds = true
		}
	}

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = "Select Outlet"
			titleLabel.textAlignment = .center
			titleLabel.textColor = self.titleColor
			titleLabel.font = self.titleFont
		}
	}

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
			tableView.backgroundColor = .clear

			tableView.estimatedRowHeight = 20
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
		self.tableView.reloadData()
	}
	
	func configureView() {
	}

	@objc func didTapedRow(_ sender:UITapGestureRecognizer) {
		guard let cell = sender.view as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
			return
		}

		let outlets = self.outlets()
		if outlets.count > 0 {

			let outlet = outlets[indexPath.row]
			if let handler = self.didSelectOutlet {
				handler(outlet)
			}
		}
	}

	func outlets() -> [Outlet] {
		guard let outlets = self.shop?.outlets else {
			return []
		}
		return outlets.filter { (outlet) -> Bool in
			if let pickup = outlet.has_pickup, pickup == 1, let show = outlet.show_in_list, show == 1, let isOpen = outlet.is_open, isOpen == 1 {
				return true
			}
			return false
		}
	}
}

extension OutletPopupViewController {

	func configureOutletsCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OutletCell", for: indexPath) as! OutletCell

		let outlets = self.outlets()
		let outlet = outlets[indexPath.row]
		cell.nameLabel?.text = outlet.name

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapedRow(_:)))
		cell.addGestureRecognizer(tapGesture)

		cell.selectionStyle = .none
		return cell
	}
}

extension OutletPopupViewController : UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//Show Outlets
		let outlets = self.outlets()
		print(outlets.count)
		return outlets.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return self.configureOutletsCell(tableView: tableView, indexPath: indexPath)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		//Navigate to outlets view screen
	}
}

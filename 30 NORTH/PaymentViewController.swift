//
//  PaymentViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 21/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire

public typealias CompletionHandler = (_ option:NSDictionary) -> Void

class PaymentViewController: UIViewController {

	var didSelectPaymentOption:CompletionHandler? = nil

	var paymentOptions:[[String:String]]? = nil
	var titleColor = UIColor(red: 186/255, green: 140/255, blue: 43/255, alpha: 1)
	var titleFont = UIFont(name: AppFontName.bold, size: 17)!

	var currencySymbol: String = ""
	var currencyShortForm: String = ""


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
			titleLabel.text = "Select Payment Option"
			titleLabel.textAlignment = .center
			titleLabel.textColor = self.titleColor
			titleLabel.font = self.titleFont
		}
	}

	@IBOutlet weak var paymentTableView: UITableView! {
		didSet {
			paymentTableView.delegate = self
			paymentTableView.dataSource = self
			paymentTableView.rowHeight = 40
			paymentTableView.backgroundColor = .clear

			paymentTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "PaymentCell")

			paymentTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "OutletCell")
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        // Do any additional setup after loading the view.
		configureView()
		loadPaymentOptions()
    }

	func configureView() {
		if let _ = settingsDetailModel{
		   currencySymbol = settingsDetailModel!.currency_symbol!
		   currencyShortForm = settingsDetailModel!.currency_short_form!
		}else{
		   appDelegate.doSettingsAPI()
		   return
		}
	}


	func loadPaymentOptions() {
		if let settingsDetail = settingsDetailModel{

			var options = [[String:String]]()
			if let isEnabled = settingsDetail.paypal_enabled, isEnabled != "0" {
				let option = ["name": "Paypal", "image":"Paypal", "id": "paypal"]
				options.append(option)
			}
			if let isEnabled = settingsDetail.stripe_enabled, isEnabled != "0" {
				let option = ["name": "Stripe", "image":"Stripe", "id": "stripe"]
				options.append(option)
			}
			if let isEnabled = settingsDetail.cash_pickup_enabled, isEnabled != "0" {
				let option = ["name": "Pay Cash at Pickup", "image":"COD", "id": "poc"]
				options.append(option)
			}
			if let isEnabled = settingsDetail.cod_enabled, isEnabled != "0" {
				let option = ["name": "Cash on Delivery", "image":"COD", "id": "cod"]
				options.append(option)
			}
			if let isEnabled = settingsDetail.banktransfer_enabled, isEnabled != "0" {
				let option = ["name": "Bank Transfer", "image":"Bank-Transfer", "id": "bank"]
				options.append(option)
			}

			self.paymentOptions = options
			self.paymentTableView.reloadData()
		}
	}

	@objc func didTapedRow(_ sender:UITapGestureRecognizer) {
		guard let cell = sender.view as? UITableViewCell, let indexPath = paymentTableView.indexPath(for: cell) else {
			return
		}

		if let option = self.paymentOptions?[indexPath.row] {
			//Notify compelition handler
			if let handler = self.didSelectPaymentOption, let data = option as? NSDictionary {
				handler(data)
			}
		}
	}
}

extension PaymentViewController {
	func configurePaymentCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath)
		let option = self.paymentOptions?[indexPath.row]
		cell.textLabel?.text = option?["name"]
		cell.textLabel?.font = UIFont(name: AppFontName.regular, size: 14)

		cell.textLabel?.textColor = .white

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapedRow(_:)))
		cell.addGestureRecognizer(tapGesture)

		/*
		if let image = option?["image"] {
			cell.imageView?.image = UIImage(named: image)
			cell.imageView?.contentMode = .scaleAspectFit
			cell.imageView?.layer.borderColor = UIColor.white.cgColor
			cell.imageView?.layer.borderWidth = 1
		}
		*/

		cell.selectionStyle = .blue
		let backView = UIView(frame: cell.bounds)
		backView.backgroundColor = .black
		cell.backgroundView = backView

		return cell
	}
}

extension PaymentViewController : UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//Show Payment options
		guard let count = self.paymentOptions?.count else {
			return 0
		}
		return count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//PaymentCell
		return self.configurePaymentCell(tableView: tableView, indexPath: indexPath)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		//Navigate to outlets view screen
	}
}

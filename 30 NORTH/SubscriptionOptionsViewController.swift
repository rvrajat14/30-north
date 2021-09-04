//
//  SubscriptionOptionsViewController.swift
//  30 NORTH
//
//  Created by AnilKumar on 18/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import SwiftUI
import Alamofire


class SubscriptionOptionsViewController: UIViewController {

	var grindTypes:[NSDictionary]? = nil
	var selectedAttibuteIndex:Int = -1
	var selectedGrindType:NSDictionary? = nil
	var item:ItemModel? = nil
	var subscriptionType:String? = nil

    var selectedSubscriptionQuantity : String = ""
    var selectedSubscriptionDuration : String = ""

    //MARK: Outlets
    @IBOutlet weak var chosenLabel: UILabel!
    @IBOutlet weak var gm250Btn: UIButton!
    @IBOutlet weak var gm500Btn: UIButton!
    @IBOutlet weak var kg1Btn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var biweeklyBtn: UIButton!
    @IBOutlet weak var grindTypeButton: UIButton!
    @IBOutlet weak var proceedBtn: UIButton!
    
	@IBOutlet weak var grindTypePopup: UIView! {
		didSet {
			grindTypePopup.isHidden = true
			grindTypePopup.layer.cornerRadius = CGFloat(8)
			grindTypePopup.layer.borderWidth = 1
			grindTypePopup.layer.borderColor = UIColor.black.cgColor
			grindTypePopup.clipsToBounds = true
		}
	}
	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = "Ground Type"
			titleLabel.font = UIFont(name: AppFontName.bold, size: 17)!
			titleLabel.textAlignment = .center
		}
	}
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
		}
	}
	@IBOutlet weak var selectButton: UIButton!
	@IBOutlet weak var closeButton: UIButton!

	@IBOutlet weak var beanTopSpace: NSLayoutConstraint!
    @IBOutlet weak var beanBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var subscriptionsTopGap: NSLayoutConstraint!
    @IBOutlet weak var beansHeight: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
		self.getGrindTypes()

		//Selectign default values
		self.gm500Btn.sendActions(for: .touchUpInside)
		self.monthlyBtn.sendActions(for: .touchUpInside)
		if let itemName = self.item?.itemName {
			self.chosenLabel.text = "You've chosen: \(itemName)"
		}
    }

    override func viewWillAppear(_ animated: Bool) {
        if UIScreen.main.bounds.height <= 667 {
            subscriptionsTopGap.constant = 0.0
            beansHeight.constant = 0.0
            beanTopSpace.constant = 0.0
            beanBottomSpace.constant = 0.0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
    }

    //MARK: Actions
    @IBAction func gm250Action(_ sender: Any) {
        gm250Btn.setBackgroundImage(UIImage.init(named: "250_on"), for: .normal)
        gm500Btn.setBackgroundImage(UIImage.init(named: "500_off"), for: .normal)
        kg1Btn.setBackgroundImage(UIImage.init(named: "1kg_off"), for: .normal)
        self.selectedSubscriptionQuantity = "250gm"
	}

    @IBAction func gm500Action(_ sender: Any) {
		gm250Btn.setBackgroundImage(UIImage.init(named: "250_off"), for: .normal)
		gm500Btn.setBackgroundImage(UIImage.init(named: "500_on"), for: .normal)
		kg1Btn.setBackgroundImage(UIImage.init(named: "1kg_off"), for: .normal)
		self.selectedSubscriptionQuantity = "500gm"
    }

    @IBAction func kg1Action(_ sender: Any) {
		gm250Btn.setBackgroundImage(UIImage.init(named: "250_off"), for: .normal)
		gm500Btn.setBackgroundImage(UIImage.init(named: "500_off"), for: .normal)
		kg1Btn.setBackgroundImage(UIImage.init(named: "1kg_on"), for: .normal)
		self.selectedSubscriptionQuantity = "1000gm"
    }

    @IBAction func monthlyAction(_ sender: Any) {
		monthlyBtn.setBackgroundImage(UIImage.init(named: "Monthly_on"), for: .normal)
		biweeklyBtn.setBackgroundImage(UIImage.init(named: "Bi-Weekly_off"), for: .normal)
		self.selectedSubscriptionDuration = "monthly"
    }

    @IBAction func biweeklyAction(_ sender: Any) {
		monthlyBtn.setBackgroundImage(UIImage.init(named: "Monthly_off"), for: .normal)
		biweeklyBtn.setBackgroundImage(UIImage.init(named: "Bi-Weekly_on"), for: .normal)
		self.selectedSubscriptionDuration = "biweekly"
    }

    @IBAction func gringTypeAction(_ sender: Any) {
		self.showAttributePopupView()
    }

	@IBAction func selectAction(_ sender: UIButton) {
		if selectedAttibuteIndex == -1 {
			_ = SweetAlert().showAlert("30 North", subTitle: "Please choose any attribute.", style: AlertStyle.customImag(imageFile: "Logo"))
		 return
		}
		guard let types = self.grindTypes else {
			return
		}
		let item = types[selectedAttibuteIndex]
		self.selectedGrindType = item
		self.closeButton.sendActions(for: .touchUpInside)

		if let name = item.value(forKey:"name") as? String {
			self.grindTypeButton.setTitle(name, for: .normal)
		}
	}

	@IBAction func closeAction(_ sender: UIButton) {
		self.grindTypePopup.isHidden = true
	}

	@IBAction func proceedAction(_ sender: Any) {

		var subscriptionTypes:[String:String] = ["type": self.subscriptionType!]
		if selectedSubscriptionQuantity == "250gm" {
			subscriptionTypes["quantity"] =  "1"
		}else if selectedSubscriptionQuantity == "500gm" {
			subscriptionTypes["quantity"] =  "2"
		} else if selectedSubscriptionQuantity == "1000gm" {
			subscriptionTypes["quantity"] =  "3"
		} else {
			_ = SweetAlert().showAlert("Subscription", subTitle: "Please select quantity!", style: AlertStyle.customImag(imageFile: "Logo"))
			return
		}
		if selectedSubscriptionDuration == "monthly" {
			subscriptionTypes["duration"] = "1"
		} else if selectedSubscriptionDuration == "biweekly" {
			subscriptionTypes["duration"] = "2"
		} else {
			_ = SweetAlert().showAlert("Subscription", subTitle: "Please select duration!", style: AlertStyle.customImag(imageFile: "Logo"))
			return
		}
		if let grindType = self.selectedGrindType, let grindID = grindType.value(forKey: "id") as? String {
			subscriptionTypes["grindType"] =  grindID
		} else {
			_ = SweetAlert().showAlert("Subscription", subTitle: "Please select grind type!", style: AlertStyle.customImag(imageFile: "Logo"))
			return
		}
		self.openConfirmVC(subscription: subscriptionTypes)
	}

	func openConfirmVC(subscription:[String:String]) {

		guard let itemPrice = self.item?.itemPrice, let additional_price = self.selectedGrindType?.value(forKey: "additional_price") as? String, let quantity = subscription["quantity"] else {
			return
		}
		var price = itemPrice.floatValue + additional_price.floatValue
		if quantity == "2" {
			price = (itemPrice.floatValue * 2) + additional_price.floatValue
		} else if quantity == "3" {
			price = (itemPrice.floatValue * 4) + additional_price.floatValue
		}

		weak var ConfirmViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CheckoutConfirm") as? CheckoutConfirmViewController
		ConfirmViewController?.subTotalAmount = price
		ConfirmViewController?.selectedPaymentOption = "online"
		ConfirmViewController?.deliveryMethod = "delivery"
		ConfirmViewController?.checkoutCurrencySymbol = settingsDetailModel!.currency_symbol!
		ConfirmViewController?.checkoutCurrencyShortForm = settingsDetailModel!.currency_short_form!
		ConfirmViewController?.subscription = subscription
		ConfirmViewController?.subscriptionItem = self.item

		ConfirmViewController?.selectedShopId = 1
		ConfirmViewController?.couponName = ""
		ConfirmViewController?.couponAmount = ""
		self.navigationController?.pushViewController(ConfirmViewController!, animated: true)
	}

	func showAttributePopupView() {
		guard let count = self.grindTypes?.count else {
			return
		}
        grindTypePopup.isHidden = false
		self.view.bringSubviewToFront(grindTypePopup)
		let heightConstraint = self.grindTypePopup.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "PopupViewHeightConstraint"
		}
        if count > 3 {
			heightConstraint?.constant = CGFloat(4 * 60) + 100
        }else{
			heightConstraint?.constant = CGFloat(count * 60) + 100
        }
		tableView.reloadData()

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

	func getGrindTypes() {
		  _ = EZLoadingActivity.show("Loading...", disableUI: true)
		Alamofire.request(APIRouters.GetGrindTypes).responseJSON { (response) in
			  _ = EZLoadingActivity.hide()

			  switch response.result {
			  case .success:
				if let jsonData = response.result.value as? [NSDictionary] {
					self.grindTypes = jsonData
				}
			  case .failure(let error):
				 print(error)
			  }
		  }
	  }
}

extension SubscriptionOptionsViewController : UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let types = self.grindTypes else {
			return 0
		}
		return types.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GrindTypeCell") as! GrindTypeCell

		guard let types = self.grindTypes else {
			return cell
		}
		let attribute = types[indexPath.row]
		var title = ""
		if let name = attribute.value(forKey: "name") as? String {
			title = name
		}
		if let additionlPrice = attribute.value(forKey: "additionlPrice") as? String, additionlPrice.floatValue > 0 {
			title.append(" (\(additionlPrice)")
		}
		cell.titleLabel.text = title

		if selectedAttibuteIndex == indexPath.row {
			cell.plusImage.image = UIImage(named: "ic_radio_check")
		} else {
			cell.plusImage.image = UIImage(named: "ic_radio_uncheck")
		}
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		self.selectedAttibuteIndex = indexPath.row
		tableView.reloadData()
	}
}

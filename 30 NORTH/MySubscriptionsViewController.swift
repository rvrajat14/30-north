//
//  MySubscriptionsViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 19/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire

class MySubscriptionsViewController: UIViewController {
	var subscriptions:[TransactionModel] = []

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "My Subscriptions")
		}
	}

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.estimatedRowHeight = 160
			tableView.separatorStyle = .none
			tableView.backgroundColor = .clear
			tableView.delegate = self
			tableView.dataSource = self
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
		loadTransaction()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.showCartButton()
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}

	func updateBackButton() {
		let backItem = UIBarButtonItem()
		backItem.title = ""
		navigationItem.backBarButtonItem = backItem
	}

	func loadTransaction() {
		let userID = self.isUserLoggedIn()
		_ = EZLoadingActivity.show("Loading...", disableUI: true)
		Alamofire.request(APIRouters.UserTransactionHistory(userID)).responseCollection {
			(response: DataResponse<[Transaction]>) in
			_ = EZLoadingActivity.hide()
			if response.result.isSuccess, let trans: [Transaction] = response.result.value {
				var tempArray:[TransactionModel] = []
				for tran in trans {
					let oneTran = TransactionModel(transData: tran)
					tempArray.append(oneTran)
				}

				let subscriptions = tempArray.filter { (trans) -> Bool in
					return trans.is_subscription == "1"
				}

				self.subscriptions = subscriptions
				self.tableView.reloadData()
			} else {
			   print(response)
			}
		}
	}
}

extension MySubscriptionsViewController : UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return subscriptions.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell") as! SubscriptionCell
		let tran = subscriptions[indexPath.row]

		cell.orderNumber.text = language.subscriptionNumber + tran.id.trim()
		cell.totalAmount.text = language.subscriptionAmount + tran.totalAmount.trim()
		let frequency = tran.subscription_frequency.trim()
		cell.frequencyLabel.text = language.subscriptionFrequency + ((frequency == "1") ? "Month" : "2 Weeks")
		if tran.subscription_type == "1" {
			if let detail = tran.transactionDetail.first {
				cell.beansLabel.text = language.subscriptionBeans + (detail.itemName?.trim() ?? "")
			} else {
				cell.beansLabel.text = language.subscriptionBeans + (tran.transactionDetail.first?.itemName?.trim() ?? "")
			}
		} else {
			cell.beansLabel.text = language.subscriptionBeans +  "Various"
		}
		cell.quantityLabel.text = language.subscriptionQuantity + tran.subscription_quantity.trim()

		if tran.subscription_ended_date != "" {
			cell.cancelButton.isHidden = true
			cell.endedLabel.isHidden = false
			cell.endedLabel.text = language.subscriptionEnded + tran.subscription_ended_date.trim()
		} else {
			cell.endedLabel.text = nil
			cell.endedLabel.isHidden = true
			cell.cancelButton.isHidden = false
			cell.cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
		}

		cell.backgroundColor = .clear
		cell.selectionStyle = .none
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.openTransationDetail(index: indexPath.row)
	}

    func openTransationDetail(index:Int) {
		let tranDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransDetail") as? TransactionHistoryDetailViewController
			tranDetailViewController?.title = language.transactionHistoryDetail
		tranDetailViewController?.allTrans = self.subscriptions
		tranDetailViewController?.rowIndex = index
		self.navigationController?.pushViewController(tranDetailViewController!, animated: true)
		updateBackButton()
	}

	@objc func cancelAction(_ sender:UIButton){
		guard let cell = sender.superview?.superview?.superview as? SubscriptionCell, let indexPath = tableView.indexPath(for: cell) else {
			return
		}
		//Are you sure you want to cancel this subscription
        _ = SweetAlert().showAlert("", subTitle: "Are you sure you want to cancel this subscription?", style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Cancel", buttonColor: UIColor.colorFromRGB(0xAEDEF4), otherButtonTitle: "Ok", action: { (isOk) in
            if !isOk {
				let trans = self.subscriptions[indexPath.row]
				self.cancelSubscription(trans: trans)
            }
        })
	}

	func cancelSubscription(trans:TransactionModel) {
		let date = Date()
		let dateText = date.toString(format: .custom("yyyy/MM/dd"))
		let params: [String: AnyObject] = [
			"subscription_status"   : "0" as AnyObject,
			"subscription_ended_date": dateText as AnyObject,
			"id":trans.id as AnyObject,
		]

		_ = EZLoadingActivity.show("Loading...", disableUI: true)
		_ = Alamofire.request(APIRouters.UpdateSubscription(params)).responseObject {
			(response: DataResponse<StdResponse>) in

			_ = EZLoadingActivity.hide()
			if response.result.isSuccess {
				if let res = response.result.value {
					_ = SweetAlert().showAlert("Subscription", subTitle:res.data, style:AlertStyle.customImag(imageFile: "Logo"))
					self.loadTransaction()
				}
			} else {
				if let res = response.result.value {
					_ = SweetAlert().showAlert("Subscription", subTitle:res.data, style:AlertStyle.customImag(imageFile: "Logo"))
				}
			}
		}
    }
}

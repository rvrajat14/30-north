//
//  TrasnactionHeaderCell.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 31/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

class TransactionHeaderCell : UICollectionViewCell {
    
    @IBOutlet weak var transactionNo: UILabel!
    @IBOutlet weak var transactionNoValue: UILabel!
    @IBOutlet weak var transactionTotalAmount: UILabel!
    @IBOutlet weak var transactionTotalAmountValue: UILabel!
    @IBOutlet weak var couponDiscount: UILabel!
    @IBOutlet weak var couponDiscountValue: UILabel!
    @IBOutlet weak var shippingRate: UILabel!
    @IBOutlet weak var shippingRateValue: UILabel!
    @IBOutlet weak var transactionStatus: UILabel!
    @IBOutlet weak var transactionStatusValue: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var phoneValue: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var emailValue: UILabel!
    @IBOutlet weak var billingAddress: UILabel!
    @IBOutlet weak var billingAddressValue: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var deliveryAddressValue: UILabel!
    @IBOutlet weak var pickupLocation: UILabel!
    @IBOutlet weak var pickupLocationValue: UILabel!
    @IBOutlet weak var pickupDate: UILabel!
    @IBOutlet weak var pickupDateValue: UILabel!

    @IBOutlet weak var earnNowButton: UIButton!
    @IBOutlet weak var pointsEarnedLabel: UILabel!
    

    func configure(_ data: TransactionModel) {
        
        // Transaction No
        transactionNo.text = language.transactionNo
        transactionNoValue.text = data.id
        
        // Transaction Total Amount
        transactionTotalAmount.text = language.transactionTotal
        transactionTotalAmountValue.text = data.totalAmount + data.currencySymbol + "(" + data.currencyShortForm + ")"
        
        // Transaction Status
        transactionStatus.text = language.transactionStatus
        transactionStatusValue.text = data.transactionStatus
        if(data.transactionStatus == "Pending"){
            transactionStatusValue.textColor = UIColor.orange
        }else {
            transactionStatusValue.textColor = UIColor.blue
        }
        
        // Phone
        phone.text = language.transactionPhone
        phoneValue.text = data.phone
        
        // Email
        email.text = language.transactionEmail
        emailValue.text = data.email


		let emailTopMargin = self.contentView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "EmailTopMargin"
		}
		let billingBottomMargin = self.contentView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "BillingBottomMargin"
		}
		let billingTopMargin = self.contentView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "BillingTopMargin"
		}

		let deliveryBottomMargin = self.contentView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "DeliveryBottomMargin"
		}
		let deliveryTopMargin = self.contentView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "DeliveryTopMargin"
		}
		let pickupBottomMargin = self.contentView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "PickupBottomMargin"
		}
		let pickupTopMargin = self.contentView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "PickupTopMargin"
		}
		let pickupDateBottomMargin = self.contentView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "PickupDateBottomMargin"
		}
		let pickupDateTopMargin = self.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "PickupDateTopMargin"
		}
		emailTopMargin?.constant = 8

        // Billing Address
        if data.billingAddress.count > 0 {
			billingTopMargin?.constant = 8
			billingBottomMargin?.constant = 5

			billingAddress.text = language.transactionBilling
			billingAddressValue.text = data.billingAddress
		} else {

			billingTopMargin?.constant = 0
			billingBottomMargin?.constant = 0

			billingAddress.text = nil
			billingAddressValue.text = nil
		}

        // Delivery Address
		if data.deliveryAddress.count > 0 {
			deliveryTopMargin?.constant = 8
			deliveryBottomMargin?.constant = 5

			deliveryAddress.text = language.transactionDelivery
			deliveryAddressValue.text = data.deliveryAddress
		} else {
			deliveryTopMargin?.constant = 0
			deliveryBottomMargin?.constant = 0

			deliveryAddress.text = nil
			deliveryAddressValue.text = nil
		}

        // Coupon Discount
        if(data.couponDiscountAmount != "0") {
            couponDiscount.text = language.couponDiscountLabel
            couponDiscountValue.text =  data.couponDiscountAmount + data.currencySymbol + "(" + data.currencyShortForm + ")"
        } else {
            couponDiscount.text = language.couponDiscountLabel
            couponDiscountValue.text = "N.A."
        }
        
        // Shipping Cost
        if(data.flatRateShipping != "0") {
            shippingRate.text = language.shippingCostLabel
            shippingRateValue.text = data.flatRateShipping + data.currencySymbol + "(" + data.currencyShortForm + ")"
        } else {
            shippingRate.text = language.shippingCostLabel
            shippingRateValue.text = "N.A."
        }
        
        //There will be no charges in case of Pickup
        if(data.delivery_method == "pickup"){
            shippingRate.text = language.shippingCostLabel
            shippingRateValue.text = "N.A."
        }

		// Pickup Location Address
		if data.pickUpLocationAddress.count > 0 {
			pickupTopMargin?.constant = 8
			pickupBottomMargin?.constant = 5

			pickupLocation.text = language.transactionPickupLocation
			pickupLocationValue.text = data.pickUpLocationAddress
		} else {
			pickupTopMargin?.constant = 0
			pickupBottomMargin?.constant = 0

			pickupLocation.text = nil
			pickupLocationValue.text = nil
		}

		// Pickup Date Time
		if data.pickUpDate.count > 0 {
			pickupDateTopMargin?.constant = 8
			pickupDateBottomMargin?.constant = 5

		   pickupDate.text = language.transactionPickupDateTime
		   pickupDateValue.text = "\(data.pickUpDate) \(data.pickUpTime)"
		} else {
			pickupDateTopMargin?.constant = 0
			pickupDateBottomMargin?.constant = 0

		   pickupDate.text = nil
		   pickupDateValue.text = nil
		}
    }
}

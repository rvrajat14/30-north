//
//  TransactionModel.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 31/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class TransactionModel {
    var id: String
	var acceptPaymentKey: String
    var shopId: String
    var userId: String
    var paymentTransId: String
    var totalAmount: String
    var deliveryAddress: String
    var billingAddress: String
    var transactionStatus: String
    var email: String
    var phone: String
    var paymentMethod: String
    var couponDiscountAmount: String
    var flatRateShipping: String
    var added: String
    var currencySymbol: String
    var currencyShortForm: String
    var rewardsStatus: String
    var pointsEarned: String
    var pickUpLocation: String
    var pickUpLocationAddress: String
	var pickUpDate:String
	var pickUpTime:String

	var is_subscription: String
    var is_gift: String
    var subscription_type: String
    var subscription_frequency: String
    var subscription_quantity: String
    var subscription_grind_type: String
	var subscription_ended_date: String
    var delivery_method: String


    var transactionDetail = [TransactionDetail]()
    
    init(id: String, acceptOrderId:String, shopId: String, userId: String, paymentTransId: String, totalAmount: String, deliveryAddress: String, billingAddress: String, transactionStatus: String, email: String, phone: String, paymentMethod: String, couponDiscountAmount: String, flatRateShipping: String, added: String, currencySymbol: String, currencyShortForm: String, rewardsStatus:String, pointsEarned:String, transactionDetail : [TransactionDetail], pickUpLocation:String, pickUpLocationAddress:String, pickUpDate:String, pickUpTime:String, is_subscription:String, subscription_type:String, subscription_quantity:String, subscription_frequency:String, subscription_grind_type:String, subscription_ended_date:String, delivery_method: String, is_gift:String ) {
        
        self.id = id
		self.acceptPaymentKey = acceptOrderId
        self.shopId = shopId
        self.userId = userId
        self.paymentTransId = paymentTransId
        self.totalAmount = totalAmount
        self.deliveryAddress = deliveryAddress
        self.billingAddress = billingAddress
        self.transactionStatus = transactionStatus
        self.email = email
        self.phone = phone
        self.paymentMethod = paymentMethod
        self.couponDiscountAmount = couponDiscountAmount
        self.flatRateShipping = flatRateShipping
        self.added = added
        self.transactionDetail = transactionDetail
        self.currencySymbol = currencySymbol
        self.currencyShortForm = currencyShortForm
        self.rewardsStatus = rewardsStatus
        self.pointsEarned = pointsEarned
        self.pickUpLocation = pickUpLocation
		self.pickUpLocationAddress = pickUpLocationAddress
		self.pickUpDate = pickUpDate
		self.pickUpTime = pickUpTime

		self.is_subscription = is_subscription
        self.is_gift = is_gift
		self.subscription_type = subscription_type
		self.subscription_quantity = subscription_quantity
		self.subscription_frequency = subscription_frequency
		self.subscription_grind_type = subscription_grind_type
		self.subscription_ended_date = subscription_ended_date
        self.delivery_method = delivery_method
    }
    
    convenience init(transData: Transaction) {
        
        let id = transData.id
		let acceptOrderId = transData.acceptPaymentKey ?? ""
        let shopId = transData.shopId
        let userId = transData.userId
        let paymentTransId = ""
        let totalAmount = transData.totalAmount
        let deliveryAddress = transData.deliveryAddress
        let billingAddress = transData.billingAddress
        let transactionStatus = transData.transactionStatus
        let email = transData.email
        let phone = transData.phone
        let paymentMethod = transData.paymentMethod
        let couponDiscountAmount = transData.couponDiscountAmount
        let flatRateShipping = transData.flatRateShipping
        let added = transData.added
        let currencySymbol = transData.currencySymbol
        let currencyShortForm = transData.currencyShortForm
        let rewardsStatus = transData.rewardsStatus
        let pointsEarned = transData.pointsEarned
        let pickuplocation = transData.pickupLocationId
		let pickUpLocationAddress = transData.pickUpLocationAddress
		let pickUpDate = transData.pickUpDate
		let pickUpTime = transData.pickUpTime

		let is_subscription = transData.is_subscription
        let is_gift = transData.is_gift
		let subscription_type = transData.subscription_type
		let subscription_quantity = transData.subscription_quantity
		let subscription_frequency = transData.subscription_frequency
		let subscription_grind_type = transData.subscription_grind_type
		let subscription_ended_date = transData.subscription_ended_date
		
        let detailArray: [TransactionDetail] = transData.details
        let delivery_method = transData.delivery_method
        
		self.init(id: id!, acceptOrderId:acceptOrderId, shopId: shopId!, userId: userId!, paymentTransId: paymentTransId, totalAmount: totalAmount!, deliveryAddress: deliveryAddress!, billingAddress: billingAddress!, transactionStatus: transactionStatus!, email: email!, phone: phone!, paymentMethod: paymentMethod!, couponDiscountAmount: couponDiscountAmount!, flatRateShipping: flatRateShipping!, added: added!, currencySymbol: currencySymbol!, currencyShortForm: currencyShortForm!, rewardsStatus: rewardsStatus!, pointsEarned: pointsEarned!, transactionDetail: detailArray, pickUpLocation: pickuplocation!, pickUpLocationAddress: pickUpLocationAddress!, pickUpDate:pickUpDate!, pickUpTime:pickUpTime!, is_subscription: is_subscription!, subscription_type:subscription_type!, subscription_quantity: subscription_quantity!, subscription_frequency: subscription_frequency!, subscription_grind_type: subscription_grind_type!, subscription_ended_date: subscription_ended_date!, delivery_method:delivery_method!, is_gift: is_gift!)
    }
}

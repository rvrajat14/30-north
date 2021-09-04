//
//  Transaction.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 30/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class Transaction: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    var id: String?
	var acceptPaymentKey:String?
    var shopId: String?
    var userId: String?
    var paymentTransId: String?
    var totalAmount: String?
    var deliveryAddress: String?
    var billingAddress: String?
    var transactionStatus: String?
    var email: String?
    var phone: String?
    var paymentMethod: String?
    var couponDiscountAmount: String?
    var flatRateShipping: String?
    var added: String?
    var currencySymbol: String?
    var currencyShortForm: String?
    var rewardsStatus: String?
    var pointsEarned: String?
    var pickupLocationId: String?
	var pickUpLocationAddress:String?
	var pickUpDate:String?
	var pickUpTime:String?
	
	var is_subscription:String?
    var is_gift:String?
	var subscription_type:String?
	var subscription_quantity:String?
	var subscription_frequency:String?
	var subscription_grind_type:String?
	var subscription_ended_date:String?
    var delivery_method:String?

    var details: [TransactionDetail] = []
    
    init(transData: NSDictionary) {
        super.init()
        self.setData(transData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let itemData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(itemData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Transaction] {
        var trans = [Transaction]()
        
        if var _ = (representation as AnyObject).value(forKey: "data") as? [NSDictionary]{
            
            for tran in ((representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary]) {
                trans.append(Transaction(transData: tran))
            }
        }
        return trans
    }
    
    
    func setData(_ transData: NSDictionary) {
        self.id                     = transData["id"] as? String
		self.acceptPaymentKey		= transData["accept_payment_key"] as? String
        self.shopId                 = transData["shop_id"] as? String
        self.userId                 = transData["user_id"] as? String
        self.paymentTransId         = transData["payment_trans_id"] as? String
        self.totalAmount            = transData["total_amount"] as? String
        self.deliveryAddress        = transData["delivery_address"] as? String
        self.billingAddress         = transData["billing_address"] as? String
        self.transactionStatus      = transData["transaction_status"] as? String
        self.email                  = transData["email"] as? String
        self.phone                  = transData["phone"] as? String
        self.paymentMethod          = transData["payment_method"] as? String
        self.couponDiscountAmount   = transData["coupon_discount_amount"] as? String
		if let rate = transData["flat_rate_shipping"] as? String {
			self.flatRateShipping       = rate
		} else {
			self.flatRateShipping       = settingsDetailModel!.flat_rate_shipping!
		}

        self.added                  = settingsDetailModel!.added!
        self.currencySymbol         = settingsDetailModel!.currency_symbol!
        self.currencyShortForm      = settingsDetailModel!.currency_short_form!
        self.rewardsStatus          = transData["rewards_status"] as? String ?? "0"
        self.pointsEarned           = transData["points_earned"] as? String ?? "0"
        self.pickupLocationId       = transData["pickup_location"] as? String ?? "0"
		self.pickUpLocationAddress = transData["pickup_outlet_name"] as? String ?? ""
		self.pickUpDate = transData["pickup_date"] as? String ?? ""
		self.pickUpTime = transData["pickup_time"] as? String ?? ""

        self.is_subscription = transData["is_subscription"] as? String ?? "0"
        self.is_gift = transData["is_gift"] as? String ?? "0"
		self.subscription_type = transData["subscription_type"] as? String ?? ""
		self.subscription_quantity = transData["subscription_quantity"] as? String ?? ""
		self.subscription_frequency = transData["subscription_frequency"] as? String ?? ""
		self.subscription_grind_type = transData["subscription_grind_type"] as? String ?? ""
		self.subscription_ended_date = transData["subscription_ended_date"] as? String ?? ""
        self.delivery_method = transData["delivery_method"] as? String ?? ""


        for transDetail in transData["details"] as! [NSDictionary] {
            self.details.append(TransactionDetail(transDetailData: transDetail))
        }
    }
    
    /*
    func setData(_ transData: NSDictionary) {
        self.id                     = transData["id"] as? String
        self.shopId                 = transData["shop_id"] as? String
        self.userId                 = transData["user_id"] as? String
        self.paymentTransId         = transData["payment_trans_id"] as? String
        self.totalAmount            = transData["total_amount"] as? String
        self.deliveryAddress        = transData["delivery_address"] as? String
        self.billingAddress         = transData["billing_address"] as? String
        self.transactionStatus      = transData["transaction_status"] as? String
        self.email                  = transData["email"] as? String
        self.phone                  = transData["phone"] as? String
        self.paymentMethod          = transData["payment_method"] as? String
        self.couponDiscountAmount   = transData["coupon_discount_amount"] as? String
        self.flatRateShipping       = transData["flat_rate_shipping"] as? String
        self.added                  = transData["added"] as? String
        self.currencySymbol         = transData["currency_symbol"] as? String
        self.currencyShortForm      = transData["currency_short_form"] as? String
        self.rewardsStatus          = transData["rewards_status"] as? String ?? "0"
        self.pointsEarned           = transData["points_earned"] as? String ?? "0"
        
        for transDetail in transData["details"] as! [NSDictionary] {
            self.details.append(TransactionDetail(transDetailData: transDetail))
        }
    }
     */
    
}

//
//  Coupons.swift
//  30 NORTH
//
//  Created by vinay on 28/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation

struct Coupons: Decodable {
    let status: String?
    let data: [CouponDetail]?
}

struct CouponDetail: Decodable {
    let id: String?
    let couponName: String?
    let couponCode: String?
    let couponAmount: String?
    let shopId: String?
    let isPublished: String?
    let added: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case couponName = "coupon_name"
        case couponCode = "coupon_code"
        case couponAmount = "coupon_amount"
        case shopId = "shop_id"
        case isPublished = "is_published"
        case added = "added"
    }
}


struct Settings: Decodable {
    let status: String?
    let data: SettingsDetail?
}

struct SettingsDetail: Decodable {
  
    let id : String?
    let paypal_email : String?
    let paypal_payment_type : String?
    let paypal_environment : String?
    let paypal_appid_live : String?
    let paypal_merchantname : String?
    let paypal_customerid : String?
    let paypal_ipnurl : String?
    let paypal_memo : String?
    let bank_account : String?
    let bank_name : String?
    let bank_code : String?
    let branch_code : String?
    let swift_code : String?
    let cod_email : String?
    let stripe_publishable_key : String?
    let stripe_secret_key : String?
    let currency_symbol : String?
    let currency_short_form : String?
    let sender_email : String?
    let flat_rate_shipping : String?
    let added : String?
    let paypal_enabled : String?
    let stripe_enabled : String?
    let cod_enabled : String?
    let banktransfer_enabled : String?
    let cash_pickup_enabled : String?
    let working_hours : String?
    let amenities : String?
    let vat : String?

	let online_payment_enabled : String?
	let pickup_enabled : String?
	let delivery_enabled : String?

	let is_tipping_enabled:String?
}

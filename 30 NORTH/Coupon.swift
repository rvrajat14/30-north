//
//  Coupon.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 20/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class Coupon: NSObject, ResponseObjectSerializable {
    var id: String?
    var couponName: String?
    var couponCode: String?
    var couponAmount: String?
    var shopId: String?
    var isPublished: String?
    var added: String?
    
    init(couponData: NSDictionary) {
        super.init()
        self.setData(couponData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        super.init()
        if let couponData = (representation as AnyObject).value(forKeyPath: "data") as? NSDictionary {
            self.setData(couponData)
        } else {
            return nil
        }
    }
    
    func setData(_ couponData: NSDictionary) {
        self.id         = couponData["id"] as? String
        self.couponName = couponData["coupon_name"] as? String
        self.couponCode = couponData["coupon_code"] as? String
        self.couponAmount = couponData["coupon_amount"] as? String
        self.shopId       = couponData["shop_id"] as? String
        self.isPublished  = couponData["is_published"] as? String
        self.added        = couponData["added"] as? String
    }

}

//
//  Attributes.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 23/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class ShopAvailability: NSObject{
    
    var shopId: String?
    var shopName: String?
    
    init(attributeData: NSDictionary) {
        super.init()
        self.setData(attributeData)
    }
    
    func setData(_ attributeData: NSDictionary) {
        self.shopId = attributeData["shop_id"] as? String
        self.shopName = attributeData["shop_name"] as? String
    }
}

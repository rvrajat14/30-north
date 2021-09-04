//
//  DataModels.swift
//  cdapi
//
//  Created by Panacea-soft on 6/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

final class Shop: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var name: String?
    var desc: String?
    var phone: String?
    var email: String?
    var address: String?
    var lat: String?
    var lng: String?
    
    var paypalEmail: String?
    var paypalEnvironment: String?
    var paypalMerchantname: String?
    var paypalCustomerId: String?
    
    var bankAccount: String?
    var bankName: String?
    var bankCode: String?
    var branchCode: String?
    var swiftCode: String?
    
    var codEmail: String?
    var currencySymbol: String?
    var currencyShortForm: String?
    var senderEmail: String?
    
    var added: String?
    var status: String?
    
    var itemCount: Int?
    var categoryCount: Int?
    var subCategoryCount: Int?
    var followCount: Int?
    
    var coverImageFile: String?
    var coverImageWidth: String?
    var coverImageHeight: String?
    var coverImageDescription: String?
    
    var paypalEnabled: String?
    var stripeEnabled: String?
    var codEnabled: String?
    var bankTransferEnabled: String?
    var cashPickupEnabled: String?

    var stripePublishableKey: String?
    var flatRateShipping: String?
    var searchKeyword: String?
    
    var working_hours: String?
    var amenities: String?

    var show_in_list: Int?

    var categories: [Category] = []
    var feeds: [NewsFeed] = []
    var outlets: [Outlet] = []

    init(shopData: NSDictionary) {
        super.init()
        self.setData(shopData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let shopData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(shopData)
    }


    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Shop] {
        var shops = [Shop]()
        
        if var _ = (representation as AnyObject).value(forKeyPath: "data") as? [NSDictionary]{
            for shop in (representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary] {
                shops.append(Shop(shopData: shop))
            }
        } else if var data = (representation as AnyObject).value(forKeyPath: "data") as? NSDictionary {
			//If 1 shop data is returned i.e. for Outlets
			shops.append(Shop(shopData: data))
		}
        return shops
	}
    
    func setData(_ shopData: NSDictionary) {
        self.id = shopData["id"] as? String
        self.name = shopData["name"] as? String
        self.desc = shopData["description"] as? String
        self.phone = shopData["phone"] as? String
        self.email = shopData["email"] as? String
        self.address = shopData["address"] as? String
        self.lat = shopData["lat"] as? String
        self.lng = shopData["lng"] as? String
        
        self.paypalEmail = settingsDetailModel!.paypal_email!
        self.paypalEnvironment = settingsDetailModel!.paypal_environment!
        self.paypalMerchantname = settingsDetailModel!.paypal_merchantname!
        self.paypalCustomerId = settingsDetailModel!.paypal_customerid!
        
        self.bankAccount = settingsDetailModel!.bank_account!
        self.bankCode = settingsDetailModel!.bank_code!
        self.bankName = settingsDetailModel!.bank_name!
        self.branchCode = settingsDetailModel!.branch_code!
        self.swiftCode = settingsDetailModel!.swift_code!
        
        self.codEmail = settingsDetailModel!.cod_email!
        
        self.added = settingsDetailModel!.added!
        self.status = shopData["status"] as? String
        self.itemCount = shopData["item_count"] as? Int
        self.categoryCount = shopData["category_count"] as? Int
        self.subCategoryCount = shopData["sub_category_count"] as? Int
        self.followCount = shopData["follow_count"] as? Int
        
        self.coverImageFile = shopData["cover_image_file"] as? String
        self.coverImageWidth = shopData["cover_image_width"] as? String
        self.coverImageHeight = shopData["cover_image_height"] as? String
        self.coverImageDescription = shopData["cover_image_description"] as? String
        if let showInList = shopData["show_in_list"] as? String {
            self.show_in_list = Int(showInList)
        }
        self.paypalEnabled = settingsDetailModel!.paypal_enabled!
        self.stripeEnabled = settingsDetailModel!.stripe_enabled!
        self.codEnabled = settingsDetailModel!.cod_enabled!
        self.bankTransferEnabled = settingsDetailModel!.banktransfer_enabled!
        self.cashPickupEnabled = settingsDetailModel!.cash_pickup_enabled!

        self.currencySymbol = settingsDetailModel!.currency_symbol!
        self.currencyShortForm = settingsDetailModel!.currency_short_form!
        self.stripePublishableKey = settingsDetailModel!.stripe_publishable_key!
        self.flatRateShipping = settingsDetailModel!.flat_rate_shipping!
        self.searchKeyword = shopData["keyword"] as? String
        self.working_hours = settingsDetailModel!.working_hours!
        self.amenities = settingsDetailModel!.amenities!

        for category in shopData["categories"] as! [NSDictionary] {
            self.categories.append(Category(categoryData: category))
        }
        
        for feed in shopData["feeds"] as! [NSDictionary] {
            self.feeds.append(NewsFeed(newsData : feed))
        }

		for outlet in shopData["outlets"] as! [NSDictionary] {
			self.outlets.append(Outlet(data: outlet))
		}
    }
    
//    self.currencySymbol = settingsDetailModel!.currency_symbol! //shopData["currency_symbol"] as? String
//    self.currencyShortForm = settingsDetailModel!.currency_short_form! //shopData["currency_short_form"] as? String

    /*
    func setData(_ shopData: NSDictionary) {
        self.id = shopData["id"] as? String
        self.name = shopData["name"] as? String
        self.desc = shopData["description"] as? String
        self.phone = shopData["phone"] as? String
        self.email = shopData["email"] as? String
        self.address = shopData["address"] as? String
        self.lat = shopData["lat"] as? String
        self.lng = shopData["lng"] as? String
        
        self.paypalEmail = shopData["paypal_email"] as? String
        self.paypalEnvironment = shopData["paypal_environment"] as? String
        self.paypalMerchantname = shopData["paypal_merchantname"] as? String
        self.paypalCustomerId = shopData["paypal_customerid"] as? String
        
        self.bankAccount = shopData["bank_account"] as? String
        self.bankCode = shopData["bank_code"] as? String
        self.bankName = shopData["bank_name"] as? String
        self.branchCode = shopData["branch_code"] as? String
        self.swiftCode = shopData["swift_code"] as? String
        
        self.codEmail = shopData["cod_email"] as? String
        
        self.added = shopData["added"] as? String
        self.status = shopData["status"] as? String
        self.itemCount = shopData["item_count"] as? Int
        self.categoryCount = shopData["category_count"] as? Int
        self.subCategoryCount = shopData["sub_category_count"] as? Int
        self.followCount = shopData["follow_count"] as? Int
        
        self.coverImageFile = shopData["cover_image_file"] as? String
        self.coverImageWidth = shopData["cover_image_width"] as? String
        self.coverImageHeight = shopData["cover_image_height"] as? String
        self.coverImageDescription = shopData["cover_image_description"] as? String
        
        self.paypalEnabled = shopData["paypal_enabled"] as? String
        self.stripeEnabled = shopData["stripe_enabled"] as? String
        self.codEnabled = shopData["cod_enabled"] as? String
        self.bankTransferEnabled = shopData["banktransfer_enabled"] as? String
        self.cashPickupEnabled = shopData["cash_pickup_enabled"] as? String

        self.currencySymbol = shopData["currency_symbol"] as? String
        self.currencyShortForm = shopData["currency_short_form"] as? String
        self.stripePublishableKey = shopData["stripe_publishable_key"] as? String
        self.flatRateShipping = shopData["flat_rate_shipping"] as? String
        self.searchKeyword = shopData["keyword"] as? String
        self.working_hours = shopData["working_hours"] as? String
        self.amenities = shopData["amenities"] as? String

        for category in shopData["categories"] as! [NSDictionary] {
            self.categories.append(Category(categoryData: category))
        }
        
        for feed in shopData["feeds"] as! [NSDictionary] {
            self.feeds.append(NewsFeed(newsData : feed))
        }
    }
    */
}


//
//  ItemModel.swift
//  Restaurateur
//
//  Created by Panacea-soft on 9/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class ItemModel {
    
    var itemId: String
//    var itemShopId : String
    var itemName: String
    var itemDesc: String
    var itemImage: String
    var itemLikeCount: Int
    var itemReviewCount: Int
    var itemImageBlob : UIImage?
    var itemImageHeight : CGFloat
    var itemImageWidth : CGFloat
    var itemPrice: String
    var currency: String
    var isFeatured: String
    var reviews: [Review] = []
    var images: [Image30North] = []
    var attributes: [ItemAttribute] = []
    var ratingCount: Float
    var discountTypeId: String
    var discountPercent: String
    var discountName: String
    var body: String
    var acidity: String
    var taste: String
    var aroma: String
    var profile: String
    var price_note: String
    var shops: [ShopAvailability] = []
    var is_selection: String

    init(itemId: String, itemName: String,itemDesc: String,itemImage: String, itemLikeCount: Int, itemReviewCount: Int, itemImageHeight : CGFloat, itemImageWidth : CGFloat, itemPrice: String,currency:String,isFeatured : String, reviews: [Review], images: [Image30North], attributes: [ItemAttribute], ratingCount: Float, discountTypeId: String,discountPercent: String , discountName: String, body: String, acidity: String, taste: String, aroma: String, profile: String, price_note: String, shops: [ShopAvailability], is_selection: String) {
        self.itemId = itemId
        self.itemDesc = itemDesc
//        self.itemShopId = itemShopId
        self.itemName = itemName
        self.itemImage = itemImage
        self.itemLikeCount = itemLikeCount
        self.itemReviewCount = itemReviewCount
        self.itemImageHeight = itemImageHeight
        self.itemImageWidth = itemImageWidth
        self.itemPrice = itemPrice
        self.currency = currency
        self.isFeatured = isFeatured
        self.reviews = reviews
        self.images = images
        self.attributes = attributes
        self.ratingCount = ratingCount
        self.discountTypeId = discountTypeId
        self.discountPercent = discountPercent
        self.discountName = discountName
        self.body = body
        self.acidity = acidity
        self.taste = taste
        self.aroma = aroma
        self.profile = profile
        self.price_note = price_note
        self.shops = shops
        self.is_selection = is_selection
    }
    
    convenience init(item: Item) {
        let id = item.id
        let name = item.name
//        let shopId = item.shopId
        var imageName : String = ""
        var imageHeight : CGFloat = 0
        var imageWidth : CGFloat = 0
        if item.images.count > 0 {
            imageName = item.images[0].path! as String
            
            if let n = NumberFormatter().number(from: item.images[0].height!) {
                imageHeight = CGFloat(truncating: n)
            }
            
            if let n2 = NumberFormatter().number(from: item.images[0].width!) {
                imageWidth = CGFloat(truncating: n2)
            }
            
        }else{
            //TODO: Need to add default image
        }
       
        let likeCount = item.likeCount ?? 0
        let reviewCount = item.reviewCount ?? 0
        let itemPrice = item.price ?? "0"
        let currencySymbol = item.currencySymbol
        let isFeatured = item.isFeatured
        let reviews = item.reviews
        let images = item.images
        let attributes = item.attributes
        let ratingCount = item.ratingCount ?? 0.0
        let discountTypeId = item.discountTypeId ?? "0"
        let discountPercent = item.discountPercent ?? "0"
        let discountName = item.discountName ?? ""
        let body = item.body ?? ""
        let acidity = item.acidity ?? ""
        let taste = item.taste ?? ""
        let aroma = item.aroma ?? ""
        let profile = item.profile ?? ""
        let price_note = item.price_note ?? ""
        let shops = item.shops
        let is_selection = item.is_selection ?? ""

        self.init(itemId: id!, itemName: name!, itemDesc: item.desc ?? "", itemImage: imageName, itemLikeCount: likeCount, itemReviewCount: reviewCount, itemImageHeight: imageHeight, itemImageWidth: imageWidth, itemPrice: itemPrice,currency : currencySymbol!,isFeatured:isFeatured!,reviews: reviews, images: images, attributes: attributes, ratingCount: ratingCount, discountTypeId: discountTypeId, discountPercent: discountPercent, discountName: discountName, body: body, acidity: acidity, taste: taste, aroma: aroma, profile: profile, price_note: price_note, shops: shops, is_selection: is_selection)
    }
    
}

//
//  NewsFeedModel.swift
//  Restaurateur
//
//  Created by Panacea-soft on 22/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class NewsFeedModel {
    var newsFeedId: String
    var newsFeedTitle: String
    var newsFeedDesc : String
    var newsFeedAdded: String
    var newsFeedImage: String
    var newsType: String
    var newsItemId: String
    var newsShopId: String
    var hasDetail: String

    
    var newsFeedImages = [Image30North]()
    var newsFeedImagesTwo: [Images]?

    init(newsFeedId: String, newsFeedTitle: String, newsFeedDesc: String,newsFeedAdded: String, newsFeedImage: String, NewsFeedImages:[Image30North], _ newFeedImagesTwo: [Images] = [Images](), newsType: String, newsItemId: String, newsShopId: String, hasDetail: String ) {
        self.newsFeedId = newsFeedId
        self.newsFeedTitle = newsFeedTitle
        self.newsFeedDesc = newsFeedDesc
        self.newsFeedAdded = newsFeedAdded
        self.newsFeedImage = newsFeedImage
        self.newsType = newsType
        self.newsItemId = newsItemId
        self.newsShopId = newsShopId
        self.hasDetail = hasDetail
        
        self.newsFeedImages = NewsFeedImages
        self.newsFeedImagesTwo  =  newFeedImagesTwo
    }
    
    convenience init(newsFeed: NewsFeed) {
        let id = newsFeed.id
        let title = newsFeed.title
        let desc = newsFeed.desc ?? ""
        let added = newsFeed.added
        let imageName = newsFeed.images[0].path
        let type = newsFeed.type ?? "1"
        let itemId = newsFeed.itemId ?? "0"
        let shopId = newsFeed.shopId ?? "0"
        let hasDetails = newsFeed.hasDetail ?? "0"
        
//        let imageArrayTwo: [Images] = newsFeed.images
        let imageArray:[Image30North] = newsFeed.images
        
        self.init(newsFeedId: id!, newsFeedTitle: title!, newsFeedDesc: desc, newsFeedAdded: added!, newsFeedImage: imageName!, NewsFeedImages: imageArray, newsType: type, newsItemId: itemId, newsShopId: shopId, hasDetail: hasDetails)
        
        
    }
}

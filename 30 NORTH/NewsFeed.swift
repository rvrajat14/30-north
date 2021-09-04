//
//  NewsFeed.swift
//  Restaurateur
//
//  Created by Panacea-soft on 22/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class NewsFeed: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var shopId: String?
    var title: String?
    var desc: String?
    var isPublished: String?
    var added: String?
    var type: String?
    var itemId: String?
    var images: [Image30North] = []
    var hasDetail: String?

    
    init(newsData: NSDictionary) {
        super.init()
        self.setData(newsData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let newsData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(newsData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [NewsFeed] {
        var newsFeeds = [NewsFeed]()
        
        if var _ = (representation as AnyObject).value(forKeyPath: "data") as? [NSDictionary]{
            for newsFeed in (representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary] {
                newsFeeds.append(NewsFeed(newsData: newsFeed))
            }
        }
        
        return newsFeeds
    }
    
    func setData(_ newsData: NSDictionary) {
        self.id = newsData["id"] as? String
        self.shopId = newsData["shop_id"] as? String
        self.title = newsData["title"] as? String
        self.desc = newsData["description"] as? String
        self.isPublished = newsData["is_published"] as? String
        self.added = newsData["added"] as? String
        self.hasDetail = newsData["has_detail"] as? String
        
        for image in newsData["images"] as! [NSDictionary] {
            self.images.append(Image30North(imageData: image))
        }
        
    }
}



struct Rewards: Decodable {
    let status: String?
    let data: ShopData?
}



final class ShopData: Decodable {
    var id: String?
    var name: String?
    var rewardfeeds: [RewardsFeeds]?
    var feeds: [Feeds]?
}

class Feeds: Decodable{
    let id: String?
    let shopId: String?
    let title: String?
    let desc: String?
    let isPublished: String?
    let added: String?
    let images: [Images]?
    let type: String?
    let itemId: String?

    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case shopId = "shop_id"
        case title = "title"
        case desc = "description"
        case isPublished = "is_published"
        case added = "added"
        case images = "images"
        case type = "type"
        case itemId = "item_id"

}
    
}


class RewardsFeeds: Decodable{
    let id: String?
    let shopId: String?
    let title: String?
    let desc: String?
    let isPublished: String?
    let added: String?
    let images: [Images]?
    let type: String?
    let itemId: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case shopId = "shop_id"
        case title = "title"
        case desc = "description"
        case isPublished = "is_published"
        case added = "added"
        case images = "images"
        case type = "type"
        case itemId = "item_id"
    }
    
}


class Images: Decodable {
    var id: String?
    var parentId: String?
    var shopId: String?
    var type: String?
    var path: String?
    var width: String?
    var height: String?
    var desc: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case parentId = "parent_id"
        case shopId = "shop_id"
        case type = "type"
        case path = "path"
        case width = "width"
        case height = "height"
        case desc = "description"
    }
}

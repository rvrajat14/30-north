//
//  Catalog.swift
//  30 NORTH
//
//  Created by SOWJI on 20/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation
final class Catalog: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var itemId: String?
    var name: String?
    var catDescription: String?
    var imagePath: String?
    var points: String?
    var rewardType: String?
    
    init(catData: NSDictionary) {
        super.init()
        self.setData(catData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let itemData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(itemData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Catalog] {
        var catalogs = [Catalog]()
        
        if var _ = (representation as AnyObject).value(forKey: "data") as? [NSDictionary]{
            
            for cat in ((representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary]) {
                catalogs.append(Catalog(catData: cat))
                
            }
        }
        return catalogs
    }
    
    func setData(_ itemData: NSDictionary) {
        self.id = itemData["id"] as? String
        self.itemId = itemData["item_id"] as? String
        self.name = itemData["name"] as? String ?? ""
        self.catDescription = itemData["description"] as? String
        self.points = itemData["points"] as? String ?? "0"
        self.imagePath = itemData["image"] as? String
        self.rewardType = itemData["reward_type"] as? String
    }
    
    
}

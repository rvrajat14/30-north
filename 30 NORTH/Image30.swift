//
//  Image.swift
//  Restaurateur
//
//  Created by Panacea-soft on 16/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//


class Image30North: NSObject {
    var id: String?
    var parentId: String?
    var shopId: String?
    var type: String?
    var path: String?
    var width: String?
    var height: String?
    var desc: String?
    
    init(imageData: NSDictionary){
        super.init()
        self.setData(imageData)
    }
    
    init(imageData: Images){
        super.init()
        self.setImagesDataUsingModel(imageData)
    }
    
    func setData(_ imageData: NSDictionary) {
        self.id = imageData["id"] as? String
        self.parentId = imageData["parent_id"] as? String
        self.shopId = imageData["shop_id"] as? String
        self.type = imageData["type"] as? String
        self.path = imageData["path"] as? String
        self.width = imageData["width"] as? String
        self.height = imageData["height"] as? String
        self.desc = imageData["description"] as? String
    }
    
    func setImagesDataUsingModel(_ imageData: Images) {
        self.id = imageData.id
        self.parentId = imageData.parentId
        self.shopId = imageData.shopId
        self.type = imageData.type
        self.path = imageData.path
        self.width = imageData.width
        self.height = imageData.height
        self.desc = imageData.desc
    }
}

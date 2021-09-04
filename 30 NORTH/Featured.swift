//
//  Featured.swift
//  30 NORTH
//
//  Created by ManiKarthi on 09/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation

public struct FeaturedDataResponse : Codable {
    
    let code : Int?
    let featured :[Featured]?
}

public struct Featured : Codable {
    
    let id : Int?
    let name : String?
    let description : String?
    let points : Double?
    let path : String?
    let category_id : Int?
    let category_name : String?
    let subcategory_id : Int?
    let subcategory_name : String?
}

struct FeaturedCategories : Codable {
    
    var categoriesName : String?
    var categoriesID : Int?
    var subcategories : [Featured]?
}



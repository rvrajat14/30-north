//
//  CategoryModel.swift
//  Restaurateur
//
//  Created by Panacea-soft on 5/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

struct CategoryModel {
    static let sharedInstance = CategoryModel()
    var categories: [Categories]? = nil
}

struct SubCategories {
    let id: String
    let catId : String
    let name: String
    let description: String
    let imageURL: String
    let items: [ItemModel]
}

struct Categories {
    let id: String
    let name: String
    let desc: String
    let imageURL: String
    let subCategory: [SubCategories]
}

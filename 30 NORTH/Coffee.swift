//
//  Coffee.swift
//  30 NORTH
//
//  Created by Anil Kumar on 18/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation

class Coffee {
	var title:String!
	var description:String!
	var smallDescription:String!
	var smallImage:String!
	var bigImage:String!
	var htmlPage:String!

	init(data:[String:String]) {

        self.title = data["title"]
        self.description = data["description"]
		self.smallDescription = data["smallDescription"]
		self.bigImage = data["bigImage"]
		self.smallImage = data["smallImage"]
		self.htmlPage = data["htmlPage"]

	}

}

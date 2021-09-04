//
//  Cupping.swift
//  30 NORTH
//
//  Created by Anil Kumar on 30/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation


public final class Cupping: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var coffee_id: String?
    var country: String?
    var title: String?
    var desc: String?

	var cupping_profile_title: String?
    var cupping_profile_text: String?

    var flag_path: String?
	var banner_path: String?
    var text_1_title: String?
	var text_2_title: String?
	var text_3_title: String?
	var text_4_title: String?
	var text_5_title: String?
	var text_6_title: String?
	var text_1: String?
	var text_2: String?
	var text_3: String?
	var text_4: String?
	var text_5: String?
	var text_6: String?

	var ordering:String?
	var is_published:String?
	var added:String?
    var updated: String?
	var status: String?

    init(data: NSDictionary) {
        super.init()
        self.setData(data)
    }

    func setData(_ data: NSDictionary) {
        self.coffee_id = data["coffee_id"] as? String
        self.title = data["title"] as? String
        self.country = data["country"] as? String
        self.desc = data["description"] as? String
		self.cupping_profile_text = data["cupping_profile_text"] as? String
		self.cupping_profile_title = data["cupping_profile_title"] as? String

        self.flag_path = data["flag_path"] as? String
        self.banner_path = data["banner_path"] as? String
        self.text_1 = data["text_1"] as? String
		self.text_2 = data["text_2"] as? String
		self.text_3 = data["text_3"] as? String
		self.text_4 = data["text_4"] as? String
		self.text_5 = data["text_5"] as? String
		self.text_6 = data["text_6"] as? String
		self.text_1_title = data["text_1_title"] as? String
		self.text_2_title = data["text_2_title"] as? String
		self.text_3_title = data["text_3_title"] as? String
		self.text_4_title = data["text_4_title"] as? String
		self.text_5_title = data["text_5_title"] as? String
		self.text_6_title = data["text_6_title"] as? String
        self.ordering = data["ordering"] as? String
        self.is_published = data["is_published"] as? String
        self.added = data["added"] as? String
		self.updated = data["updated"] as? String
		self.status = data["status"] as? String
	}

	init?(response: HTTPURLResponse, representation: Any) {
        super.init()
		guard let data = (representation as? NSDictionary) else {
			return nil
		}
        self.setData(data)
	}

	internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Cupping] {
        var coffeeProfiles = [Cupping]()

		if let data = representation as? [NSDictionary] {
			for coffeeProfile in data  {
                coffeeProfiles.append(Cupping(data: coffeeProfile))
            }
		} else if let data = (representation as AnyObject).value(forKeyPath: "data") as? NSDictionary {
			coffeeProfiles.append(Cupping(data: data))
		}
        return coffeeProfiles
	}
}


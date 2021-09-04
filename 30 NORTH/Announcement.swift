//
//  Announcement.swift
//  30 NORTH
//
//  Created by Anil Kumar on 28/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation

public final class Announcement: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var title: String?
    var desc: String?
    var image_path: String?
    var action_screen: String?
	var notes:String?
	var ordering:String?
	var is_white_title:String?
	var is_white_description:String?
	var is_white_notes:String?

	var hide_title:String?
	var hide_description:String?
	var hide_notes:String?

	var is_published:String?
	var added:String?
    var updated: String?
	var status: String?

    init(data: NSDictionary) {
        super.init()
        self.setData(data)
    }

    func setData(_ data: NSDictionary) {
        self.id = data["id"] as? String
        self.title = data["title"] as? String
        self.desc = data["description"] as? String 
        self.image_path = data["image_path"] as? String
        self.action_screen = data["action_screen"] as? String
        self.notes = data["notes"] as? String
        self.ordering = data["ordering"] as? String
        self.is_published = data["is_published"] as? String

		self.is_white_title = data["is_white_title"] as? String
		self.is_white_description = data["is_white_description"] as? String
		self.is_white_notes = data["is_white_notes"] as? String
		self.hide_title = data["hide_title"] as? String
		self.hide_description = data["hide_description"] as? String
		self.hide_notes = data["hide_notes"] as? String

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

	internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Announcement] {
        var announcements = [Announcement]()

		if let data = representation as? [NSDictionary] {
			for announcement in data  {
                announcements.append(Announcement(data: announcement))
            }
		} else if let data = (representation as AnyObject).value(forKeyPath: "data") as? NSDictionary {
			announcements.append(Announcement(data: data))
		}
        return announcements
	}

}


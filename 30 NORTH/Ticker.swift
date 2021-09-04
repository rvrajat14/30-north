//
//  Announcement.swift
//  30 NORTH
//
//  Created by Anil Kumar on 17/06/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation

public final class Ticker: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var title: String?
    var ordering: String?
    var action_screen: String?

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
        self.action_screen = data["action_screen"] as? String
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

	internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Ticker] {
        var tickers = [Ticker]()

		if let data = representation as? [Ticker] {
			tickers = data
		} else if let data = representation as? [NSDictionary] {
			for ticker in data {
				tickers.append(Ticker(data: ticker))
			}
		}
        return tickers
	}

}


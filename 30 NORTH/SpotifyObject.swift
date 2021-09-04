//
//  SpotifyObject.swift
//  30 NORTH
//
//  Created by ManiKarthi on 14/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation

struct SpotifyObject<T : Codable>: Codable {
    var href: String?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
    var items: [T]?
    
    enum CodingKeys: String, CodingKey
    {
        case href = "href"
        case limit = "limit"
        case next = "next"
        case offset = "offset"
        case previous = "previous"
        case total =  "total"
        case items = "items"
    }
}

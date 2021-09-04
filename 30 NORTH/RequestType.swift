//
//  RequestType.swift
//  30 NORTH
//
//  Created by admin on 02/11/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation

struct RequestType: Decodable {
    let status: String?
    let data: [RequestTypeDetail]?
}

struct RequestTypeDetail: Decodable {
    let id: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}


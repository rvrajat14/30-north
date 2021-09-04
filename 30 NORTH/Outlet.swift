//
//  Outlet.swift
//  30 NORTH
//
//  Created by Anil Kumar on 22/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation

typealias Amenity = [String:String]

public final class Outlet: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var name: String?
    var open_from: String?
    var open_to: String?
    var open_days: String?
    var lat:String?
    var lon:String?

    var is_open:Int?
    var show_in_list: Int?
    var has_pickup: Int?

    var has_snacks:String?
    var has_seating:String?
    var has_food:String?
    var has_contactless:String?
    var is_opening_soon:String?

    var display_food:String?
    var display_pickup:String?
    var display_seating:String?

    var phone:String?
    var email:String?
    var address:String?
    var area:String?
    var ordering:String?
    var notes:String?
    var is_published:String?
    var added:String?
    var updated: String?

    var amenities: [Amenity]? = nil

    init(data: NSDictionary) {
        super.init()
        self.setData(data)
    }
       
    internal init?(response: HTTPURLResponse, representation: Any) {
           let outletData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
           super.init()
           self.setData(outletData)
       }


       internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Outlet] {
           var outlets = [Outlet]()
           
           if var _ = (representation as AnyObject).value(forKeyPath: "data") as? [NSDictionary]{
               for outlet in (representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary] {
                   outlets.append(Outlet(data: outlet))
               }
           } else if var data = (representation as AnyObject).value(forKeyPath: "data") as? NSDictionary {
               //If 1 shop data is returned i.e. for Outlets
               outlets.append(Outlet(data: data))
           }
           return outlets
       }
    
    
    
    

    func setData(_ data: NSDictionary) {
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.email = data["email"] as? String ?? ""
        self.phone = data["phone"] as? String
        self.address = data["address"] as? String
        self.lat = data["lat"] as? String
        self.lon = data["lon"] as? String

        self.open_to = data["open_to"] as? String
        self.open_from = data["open_from"] as? String
        self.open_days = data["open_days"] as? String

        self.notes = data["notes"] as? String
        self.added = data["added"] as? String
        self.updated = data["updated"] as? String

        self.has_food = data["has_food"] as? String
        self.has_snacks = data["has_snacks"] as? String
        self.has_seating = data["has_seating"] as? String
        self.has_contactless = data["has_contactless"] as? String
        self.is_opening_soon = data["is_opening_soon"] as? String

        self.display_food = data["display_food"] as? String
        self.display_pickup = data["display_pickup"] as? String
        self.display_seating = data["display_seating"] as? String

        if let is_open = data["is_open"] as? String {
            self.is_open = Int(is_open)
        }
        if let showInList = data["show_in_list"] as? String {
            self.show_in_list = Int(showInList)
        }
        if let hasPickup = data["has_pickup"] as? String {
            self.has_pickup = Int(hasPickup)
        }

        if let amenities = data["amenities"] as? [Amenity] {
            self.amenities = amenities
        }
    }
}



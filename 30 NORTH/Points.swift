//
//  Points.swift
//  30 NORTH
//
//  Created by SOWJI on 18/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//


final class Points: NSObject,ResponseCollectionSerializable, ResponseObjectSerializable {
    var id: Int?
    var user_id: Int?
    var points: UInt64?
    var type: Int?
    var isRedeemed: Int?

    
    init(pointsData: NSDictionary) {
        super.init()
        self.setData(pointsData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        super.init()
        if let pointsData = (representation as AnyObject).value(forKeyPath: "points") as? [Any] , let data = pointsData[0] as? NSDictionary{
            self.setData(data)
        } else {
            return nil
        }
    }
    
    
    func setData(_ pointsData: NSDictionary) {
        self.id       = pointsData["id"] as? Int
        self.user_id = pointsData["user_id"] as? Int
        self.points = pointsData["points_balance"] as? UInt64 ?? 0
        self.type    = pointsData["type"] as? Int
        self.isRedeemed    = pointsData["is_redeemed"] as? Int

    }
    
}

//
//  Reservation.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 29/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class Reservation: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var resvDate: String?
    var resvTime: String?
    var note: String?
    var shopId: String?
    var userId: String?
    var userEmail: String?
    var userPhone: String?
    var userName: String?
    var status: String?
    
    init(resvData: NSDictionary) {
        super.init()
        self.setData(resvData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let itemData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(itemData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Reservation] {
        var resvs = [Reservation]()
        
        if var _ = (representation as AnyObject).value(forKey: "data") as? [NSDictionary]{
            
            for resv in ((representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary]) {
                resvs.append(Reservation(resvData: resv))
                
            }
        }
        return resvs
    }
    
    func setData(_ resvData: NSDictionary) {
        self.id         = resvData["id"] as? String
        self.resvDate   = resvData["resv_date"] as? String
        self.resvTime   = resvData["resv_time"] as? String
        self.note       = resvData["note"] as? String
        self.shopId     = resvData["shop_id"] as? String
        self.userId     = resvData["user_id"] as? String
        self.userEmail  = resvData["user_email"] as? String
        self.userPhone  = resvData["user_phone_no"] as? String
        self.userName   = resvData["user_name"] as? String
        self.status     = resvData["status"] as? String
    }
}

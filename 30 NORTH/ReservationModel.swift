//
//  ReservationModel.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 29/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class ReservationModel {
    var id: String
    var resvDate: String
    var resvTime: String
    var note: String
    var shopId: String
    var userId: String
    var userEmail: String
    var userPhone: String
    var userName: String
    var status: String
    
    init(id: String, resvDate: String, resvTime: String, note: String, shopId: String, userId: String, userEmail: String, userPhone: String, userName: String, status: String) {
        self.id        = id
        self.resvDate  = resvDate
        self.resvTime  = resvTime
        self.note      = note
        self.shopId    = shopId
        self.userId    = userId
        self.userEmail = userEmail
        self.userPhone = userPhone
        self.userName  = userName
        self.status    = status
    }
    
    convenience init(resvData: Reservation) {
        let id            = resvData.id
        let resvDate      = resvData.resvDate
        let resvTime      = resvData.resvTime
        let note          = resvData.note
        let shopId        = resvData.shopId
        let userId        = resvData.userId
        let userEmail     = resvData.userEmail
        let userPhone     = resvData.userPhone
        let userName      = resvData.userName
        let status        = resvData.status
        
        self.init(id: id!, resvDate: resvDate!, resvTime: resvTime!, note: note!, shopId: shopId!, userId: userId!, userEmail: userEmail!, userPhone: userPhone!, userName: userName!, status: status!)
        
        
    }
}

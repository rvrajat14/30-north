//
//  ReservationCell.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 29/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

class ReservationCell: UITableViewCell {
    
    @IBOutlet weak var resvId: UILabel!
    @IBOutlet weak var resvDate: UILabel!
    @IBOutlet weak var resvTime: UILabel!
    @IBOutlet weak var resvStatus: UILabel!
    
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactEmail: UILabel!
    @IBOutlet weak var contactPhone: UILabel!
    @IBOutlet weak var note: UILabel!
    
    func configure(_ id: String, date: String, time: String, status: String, name: String, email: String, phone: String, additionalNote: String) {
        resvId.text         = language.resvId + id
        resvDate.text       = language.resvDate + date
        resvTime.text       = language.resvTime + time
        resvStatus.text     = language.resvStatus + status
        
        contactName.text    = language.contactName + name
        contactEmail.text   = language.contactEmail + email
        contactPhone.text   = language.contactPhone + phone
        note.text           = language.note + additionalNote
    }
    
}

//
//  FeedCell.swift
//  Restaurateur
//
//  Created by Panacea-soft on 23/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class FeedCell: UITableViewCell {
    
    
    @IBOutlet weak var feedCoverImage: UIImageView!
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var feedDesc: UILabel!
    @IBOutlet weak var feedAdded: UILabel!
    
    var feedImages = [Image30North]()
    var feedImages1 = [Images]()
    var request : Alamofire.Request?
    
    func configure(_ title: String, desc: String, added: String, imageName: String, feedImgs: [Image30North]) {
        
        feedTitle.text = title
        feedDesc.text = desc
        feedAdded.text = added
        feedImages = feedImgs
    }
}

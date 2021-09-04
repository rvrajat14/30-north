
//
//  SubcategoryItemCell.swift
//  30 NORTH
//
//  Created by SOWJI on 30/01/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire
class SubcategoryItemCell: UITableViewCell {

    @IBOutlet weak var subitemDesc: UILabel!
    @IBOutlet weak var basketButton: UIButton!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var subitemPrice: UILabel!
    @IBOutlet weak var subitemName: UILabel!
    @IBOutlet weak var subitemImage: UIImageView!
    
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var acidityView: UIView!
    @IBOutlet weak var aromaView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var tasteView: UIView!
    
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var acidityLabel: UILabel!
    @IBOutlet weak var aromaLabel: UILabel!
    @IBOutlet weak var tasteLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    
    
    var itemImage : String = ""
    var itemName : String = ""
    var request: Alamofire.Request?
    var item: ItemModel? {
        didSet {
            if let item = item {
                itemImage = item.itemImage
                itemName = item.itemName
//                subitemDesc.text = item.itemDesc
                subitemName.text = item.itemName
//                likeCount.text = String(item.itemLikeCount)
//                reviewCount.text = String(item.itemReviewCount)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        subitemImage.rectangularImage()
        // Initialization code
    }

 

}


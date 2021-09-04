//
//  CategoryRow.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import Alamofire


class CategoryRow : UICollectionViewCell {

//    @IBOutlet weak var subitemDesc: UILabel!
    @IBOutlet weak var basketButton: UIButton!
    @IBOutlet weak var messageCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var subitemPrice: UILabel!
	@IBOutlet weak var subitemName: UILabel! {
		didSet {
			subitemName.textAlignment = .center
			subitemName.font = UIFont(name: AppFontName.nexaBlack, size: 18)
            subitemName.minimumScaleFactor = 0.5
			subitemName.textColor = UIColor.white
            subitemName.adjustsFontSizeToFitWidth = true
		}
	}
    @IBOutlet weak var subitemImage: UIImageView!
    @IBOutlet weak var subItemsStackView: UIStackView!
    
    @IBOutlet weak var categoryBottomConstraint: NSLayoutConstraint!
    
    var subCategoryId: String = ""
    var subCategoryName: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
//        subitemImage.rectangularImage()
        // Initialization code
    }
    var isItem = false {
        didSet {
            if isItem == true {
                self.subItemsStackView?.isHidden = false
            } else {
                self.subItemsStackView?.isHidden = true
            }
        }
    }
    
}


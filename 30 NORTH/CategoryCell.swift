//
//  VideoCell.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import Alamofire

class CategoryCell : UICollectionViewCell {
    
    @IBOutlet weak var subCatName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    
    var subCategoryId: String = ""
    var subCategoryName: String = ""
    var request: Alamofire.Request?
    var isItem = false
    func loadCell() {
    
    }
}

class CategoryTabCell : UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var catName: UILabel!
    
    override var isSelected: Bool {
        
        didSet{
            UIView.animate(withDuration: 0.30) {
				self.catName.textColor = self.isSelected ? UIColor.gold: .white
                self.bgView.backgroundColor = self.isSelected ? UIColor.gold : .clear
                self.layoutIfNeeded()
            }
        }
        
    }
}

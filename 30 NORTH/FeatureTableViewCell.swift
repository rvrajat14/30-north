//
//  FeatureTableViewCell.swift
//  30 NORTH
//
//  Created by SOWJI on 05/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
/*
 @objc protocol featureDelegate {
    func segueToDetailController(_ isItem : Bool, _ subCategoryId : String, _ subCategoryName : String )
}

class FeatureTableViewCell: UITableViewCell {
    var itemCount = 0
    var itemsArray = [ItemModel]()
    var subCategories = [SubCategories]()
    var itemCategories = [SubCategories]()
    weak var delegate : featureDelegate?
    
    @IBOutlet weak var ItemsCollectionView: UICollectionView!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fetchSubItems(_ selectedCategory : Categories , _ index : Int) {
        if self.tag == index {
        self.itemCount = 0
        self.itemsArray.removeAll()
        self.subCategories.removeAll()
        self.itemCategories.removeAll()
        
        self.subCategories = selectedCategory.subCategory.filter({ (item) -> Bool in
            return item.name != selectedCategory.name
        })
        self.itemCategories = selectedCategory.subCategory.filter({ (item) -> Bool in
            return item.name == selectedCategory.name
        })
        for subCat in self.itemCategories {
            self.itemsArray.append(contentsOf: subCat.items)
            self.itemCount += subCat.items.count
        }
        self.itemCount += self.subCategories.count
       //print("******************* \(itemCount)")
        ItemsCollectionView.delegate = self
        ItemsCollectionView.dataSource = self
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:10,left:15,bottom:10,right:15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 25
        self.ItemsCollectionView?.isPrefetchingEnabled = false
        layout.scrollDirection = .horizontal
        self.ItemsCollectionView?.collectionViewLayout = layout
        self.ItemsCollectionView?.backgroundColor = .white
     
        self.addSubview(self.ItemsCollectionView!)
        }
        
    }
    
}
extension FeatureTableViewCell : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("*******************2 \(itemCount)")
        return self.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! FeaturedCollectionViewCell
        cell.tag = indexPath.row
        if  (indexPath.row >= 0 && indexPath.row <= self.subCategories.count - 1) {
           cell.isItem = false
            let subCat = self.subCategories[indexPath.row]
            cell.itemLabel.text = subCat.name
            let backgroundName =  subCat.imageURL as String
            let imageURL = configs.imageUrl + backgroundName
            
            cell.itemImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                if(status == STATUS.success) {
                   //print(url + " is loaded successfully.")
                    
                }else {
                   //print("Error in loading image" + msg)
                }
            }
            cell.subCategoryId = subCat.id
            cell.subCategoryName = subCat.name
        } else {
            cell.isItem = true
            let row = indexPath.item - self.subCategories.count
            let itemCat = self.itemsArray[row]
           //print(itemCat.itemName)
            cell.itemLabel.text = itemCat.itemName
            let backgroundName =  itemCat.itemImage as String
            let imageURL = configs.imageUrl + backgroundName
            
            cell.itemImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                if(status == STATUS.success) {
                   //print(url + " is loaded successfully.")
                    
                }else {
                   //print("Error in loading image" + msg)
                }
            }
            cell.subCategoryId = itemCat.itemId
            cell.subCategoryName = itemCat.itemName
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FeaturedCollectionViewCell
        if cell.isItem {
            self.delegate?.segueToDetailController(cell.isItem, cell.subCategoryId, cell.subCategoryName)
        } else {
             self.delegate?.segueToDetailController(cell.isItem, cell.subCategoryId, cell.subCategoryName)
        }
    }
}

class FeaturedCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    var isItem = false
    var subCategoryId: String = ""
    var subCategoryName: String = ""
}
*/

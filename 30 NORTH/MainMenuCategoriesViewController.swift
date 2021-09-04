//
//  MainMenuCategoriesViewController.swift
//  30 NORTH
//
//  Created by AnilKumar on 07/08/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation

class MainMenuCategoriesViewController: UIViewController {
    var selectedCategoryIndex = 0
    var allMainCategoriesForMenu = [Categories]()
    var selectedOulet : Outlet? = nil


    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            if(self.selectedOulet != nil){
                headerLabel.text = selectedOulet?.name
            }
        }
    }
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!{
           didSet {
               categoriesCollectionView.backgroundColor = UIColor.clear
           }
       }
    
    @IBOutlet weak var subCategoryCollectionView: UICollectionView! {
           didSet {
               subCategoryCollectionView.backgroundColor = UIColor.mainViewBackground
           }
       }
    
    @IBOutlet weak var subTitleLabel: UILabel! {
              didSet {
               subTitleLabel.font =  UIFont(name: AppFontName.bold, size: 14)
                subTitleLabel.isHidden = true
              }
          }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
           self.showCartButton()
       }
    
}


//MARK: Collection View Delegates and Data source
extension MainMenuCategoriesViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMainCategoriesForMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryRow", for: indexPath) as? CategoryRow else {
                return UICollectionViewCell()}
            cell.tag = indexPath.row
            
            cell.categoryBottomConstraint.constant = 12
                let cat = self.allMainCategoriesForMenu[indexPath.row]
                cell.subitemName.text = cat.name
                cell.isItem = false
                let backgroundName =  cat.imageURL as String
                let imageURL = configs.imageUrl + backgroundName
                cell.subitemImage.kf.setImage(with: URL(string: imageURL), placeholder: nil, options: .none, progressBlock: .none)
                cell.backgroundColor = .clear
                return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        self.openOrder()
        return
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     if collectionView == subCategoryCollectionView{
            let width = ((self.view.frame.width - 30) / 2)
            //            //print("cell width : \(width)")
            return CGSize(width: width, height: width)
        }
        return CGSize(width: 121, height: 155)
    }
    
    func openOrder () {
      
        let cat = self.allMainCategoriesForMenu[selectedCategoryIndex]
        //let cat = self.categoryWithAllSubCatsFromAllMainCategories
        /*if cat.subCategory.count == 1 {
         let subCat = cat.subCategory[0]
         let catName = cat.id
         let subCatName = subCat.catId
         if (subCatName == catName) {
         items = cat.subCategory[0].items
         }
         }*/
        let orderVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderTabViewController") as! OrderTabViewController
        orderVC.category = cat
        orderVC.shopModel = shopModel
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
}

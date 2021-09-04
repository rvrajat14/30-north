//
//  SingleShopViewController.swift
//  Restaurateur
//
//  Created by Thet Paing Soe on 11/29/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

class SingleShopViewController : UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ShopImage: UIImageView!
    @IBOutlet weak var AboutUsLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var FoodLabel: UILabel!
    @IBOutlet weak var SubCategoryLabel: UILabel!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var shop : Shop? = nil
    private var location : String = ""
    private var aboutUs : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
    }
    
    @IBAction func btnClicked(_ sender: Any) {
        
        weak var selectedShopController = self.storyboard?.instantiateViewController(withIdentifier: "SelectedShop") as? SelectedShopViewController
        self.navigationController?.pushViewController(selectedShopController!, animated: true)
//        selectedShopController?.shopModel = shopModel
        selectedShopController!.selectedShopArrayIndex = 0
        
    }
    
    func initUI(_ _shop: Shop) {
        // Shop Data
        shop = _shop
        
        // Location
        LocationLabel.text = self.shop?.address
        location = (self.shop?.address)!
        
        // About Us
        AboutUsLabel.text = (self.shop?.desc)!
        aboutUs = (self.shop?.desc)!
      
        // Shop Image
        let imageURL = configs.imageUrl + (self.shop?.coverImageFile)!
        ShopImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
                
            }else {
               //print("Error in loading image" + msg)
            }
        }
        
        // Counts
        let catCount = Int((self.shop?.categoryCount)!)
        let subCatCount = Int((self.shop?.subCategoryCount)!)
        let itemCount = Int((self.shop?.itemCount)!)
        CategoryLabel.text = "\(catCount) Categories"
        SubCategoryLabel.text = "\(subCatCount) Sub Categories"
        FoodLabel.text = "\(itemCount) Foods"

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       //print("content view height \(contentView.bounds.height)")
        
        // Prepare for estimate label height
        // Estimating the size of note
        let fontSize : CGFloat = 14
        let leftMargin : CGFloat = 8
        let rightMargin : CGFloat = 8
        
        let approximateWidthOfBioTextView = contentView.frame.width - leftMargin - rightMargin
        let size = CGSize(width: approximateWidthOfBioTextView, height : 1000)
        let attributesWithFontAndSize = [NSAttributedString.Key.font: UIFont.init(name: "NexaLight", size: fontSize)!]
        
        // Est Location height
        let estimateLocation = NSString(string: location).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributesWithFontAndSize, context: nil)
        let estLocationHeight : CGFloat = estimateLocation.height
        
        // Est About Us Height
        let estimateAboutUs = NSString(string: aboutUs).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributesWithFontAndSize, context: nil)
        let estAboutUsHeight : CGFloat = estimateAboutUs.height
        
        scrollView.contentSize.height = contentView.bounds.height + estLocationHeight + estAboutUsHeight
        
    }
}

//
//  CityListControllerViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 11/19/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire


class ShopsListViewController: UICollectionViewController{

//    @IBOutlet weak var menuButton: UIBarButtonItem!

    var populationPhotos = false
    var currentPage = 1
    var selectedShopArrayIndex: Int!
    var allShops = [ShopModel]()
    weak var sendMessageDelegate : SendMessageDelegate?
    var singlePageDelegate : SinglePageDelegate?
    var refresher = UIRefreshControl()
    var defaultValue: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        
        if #available(iOS 10.0, *) {
            collectionView!.isPrefetchingEnabled = false
        }
        
        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
        }
        
        _ = Common.instance.loadBackgroundImage(view)
        
        
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView!.register(ShopCell.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ShopCell")
        
        self.collectionView!.alwaysBounceVertical = true
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(loadAllShopsFromPullRefresh), for: .valueChanged)
        collectionView!.addSubview(refresher)
        
        defaultValue = collectionView?.frame.origin
        animateCollectionView()
        
    }
    
    func loadShops(_ type : String, keyword : String) {
        
        if(type == "all") {
           //print("load all shops")
            loadAllShops()
        }else {
           //print("search shops")
            loadAllShopsByKeyword(searchKeyword: keyword)
        }
        
    }
    
    @objc func loadAllShopsFromPullRefresh() {
        self.allShops.removeAll()
        loadAllShops()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedShop" {
//            weak var cityCell = sender as? ShopCell
//            weak var selectedShopController = segue.destination as? SelectedShopViewController
//            weak var shopModel = cityCell!.shopmodel
//            selectedShopController!.shopModel = shopModel
//            selectedShopController!.selectedShopArrayIndex = selectedShopArrayIndex
            
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allShops.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCell", for: indexPath) as? ShopCell
//        cell!.shopmodel = allShops[(indexPath as NSIndexPath).item]
        let imageURL = configs.imageUrl + allShops[(indexPath as NSIndexPath).item].backgroundImage
        
        cell!.imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
                
            }else {
               //print("Error in loading image" + msg)
            }
        }
        
        cell?.imageView.alpha = 0
        
        cell?.imageView.alpha = 1.0
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = collectionViewLayout as! PallaxLayout
        let offset = layout.dragOffset * CGFloat((indexPath as NSIndexPath).item)
        
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
        selectedShopArrayIndex = (indexPath as NSIndexPath).row
        
        let cell = collectionView.cellForItem(at: indexPath) as! ShopCell
        performSegue(withIdentifier: "selectedShop", sender: cell)
    }
    
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateLabelFrame(_ text:NSString!, font:UIFont!) -> CGFloat {
        let maxSize = CGSize(width: 320, height: CGFloat(MAXFLOAT)) as CGSize
        let expectedSize = NSString(string: text!).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:  [NSAttributedString.Key.font: font], context: nil).size as CGSize
        return expectedSize.height;
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.homePageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    
    
    func showNotiIfExists(){
        let prefs = UserDefaults.standard
        
        let keyValue = prefs.string(forKey: notiKey.notiMessageKey)
        if keyValue != nil {
            
            let alert = UIAlertController(title: "", message:keyValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
            
            prefs.removeObject(forKey: notiKey.notiMessageKey)
        }
    }
    
    
    func loadAllShops() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        Alamofire.request(APIRouters.GetShopByID(1)).responseCollection {
            (response: DataResponse<[Shop]>) in
            
            self.refresher.endRefreshing()
            
            if response.result.isSuccess {
                if let shops: [Shop] = response.result.value {
                    
                    
                    if shops.count > 0 {
                        
                        if shops.count == 1 {
                            self.singlePageDelegate?.openSinglePage(shops[0])
                            
                            let oneShop = ShopModel(shop: shops[0])
                            self.allShops.append(oneShop)
//                            ShopsListModel.sharedManager.shops = self.allShops
                            
                            _ = EZLoadingActivity.hide()
                        }else {
                            
                            for shop in shops {
                                
                                let oneShop = ShopModel(shop: shop)
                                self.allShops.append(oneShop)
                            }

//                            self.collectionView?.reloadData()
//                            ShopsListModel.sharedManager.shops = self.allShops
                            _ = EZLoadingActivity.hide()
                            self.singlePageDelegate?.openSinglePage(shops[0])
                        }
                    } else {
//                        self.menuButton.isEnabled = false
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noShops, style: AlertStyle.customImag(imageFile: "Logo"))
                    }
//                    ShopsListModel.sharedManager.shopsCount = shops.count
                }
                
                //Show noti message, if there is new noti message
                self.showNotiIfExists();
                
                
            } else {
               //print("Response is fail.")
                _ = EZLoadingActivity.hide()
                _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.tryAgainToConnect, style: AlertStyle.customImag(imageFile: "Logo"))
            }
        }
        
    }
    
    func loadAllShopsByKeyword(searchKeyword : String) {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        let params: [String: AnyObject] = [
            "keyword"   : searchKeyword as AnyObject
        ]
        
        Alamofire.request(APIRouters.SearchByKeyword(params)).responseCollection {
            (response: DataResponse<[Shop]>) in
            
            if response.result.isSuccess {
                if let shops: [Shop] = response.result.value {
                    
                    
                    if shops.count >= 1 {
                        
                        for shop in shops {
                            
//                            let oneShop = ShopModel(shop: shop)
//                            self.allShops.append(oneShop)
                            
                        }
                        
                        self.collectionView?.reloadData()
                        _ = EZLoadingActivity.hide()
//                        ShopsListModel.sharedManager.shops = self.allShops
                        
                    } else {
//                        self.menuButton.isEnabled = false
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noShops, style: AlertStyle.customImag(imageFile: "Logo"))
                    }
                    
                   //print(shops.count)
                    
                }
                
                //Show noti message, if there is new noti message
                self.showNotiIfExists();
                
                
            } else {
               //print("Response is fail.")
                _ = EZLoadingActivity.hide()
                _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.tryAgainToConnect, style: AlertStyle.customImag(imageFile: "Logo"))
            }
        }
        
    }
    
    func animateCollectionView() {
        
        moveOffScreen()
        
        self.collectionView?.frame.origin = self.defaultValue
        
    }
    
    fileprivate func moveOffScreen() {
        collectionView?.frame.origin = CGPoint(x: (collectionView?.frame.origin.x)!,
                                               y: (collectionView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
}








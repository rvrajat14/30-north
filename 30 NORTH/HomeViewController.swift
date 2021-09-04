//
//  HomeViewController.swift
//  30 NORTH
//
//  Created by SOWJI on 05/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
//import CarbonKit
import XLPagerTabStrip

@objc protocol HomeShopBasketCountUpdateDelegate: class {
    func updateBasketCount()
}

class HomeViewController: ButtonBarPagerTabStripViewController {

    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)

//    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = [String]()
    var selectedIndexVC = 0
    var basketButton = MIBadgeButton()
    var loginUserId: Int = 0
    var selectedItemCurrencySymbol: String = ""
    var selectedItemCurrencyShortform: String = ""
    var selectedShopId = 1

    enum OrderList {
        case menu, featured, previous, favorites, offers
    }
        
//    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        if let _ = settingsDetailModel{
        }else{
            appDelegate.doSettingsAPI()
        }
        
        loadInitialSetup()
        
//        loadItemsList()
        
//        if Common.instance.isUserLogin() == false{
//            items = ["MENU", "FEATURED","OFFERS"]
//        }else{
//            items = ["MENU", "FEATURED","PREVIOUS","FAVORITES","OFFERS"]
//            setupBasketButton()
//        }
        
//        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
//        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: swipeView)
        self.style()
    }
    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loadButtonStyle()
		//self.showCartButton()
    }

    @objc func loadInitialSetup(){
        
        loadLoginUserId()
        
        self.updateNavigationStuff()
        if Common.instance.isUserLogin() == false{
            is_previous = true
            is_favorites = true
        }else{
            setupBasketButton()
        }
    }
    
    func loadItemsList(){
        
//        if !is_menu{
            items.append("MENU")
//        }
        if !is_featured{
            items.append("FEATURED")
        }
        if !is_previous{
            items.append("PREVIOUS")
        }
        if !is_favorites{
            items.append("FAVORITES")
        }
        if !is_offers{
            items.append("OFFERS")
        }
    }
    
    
    func loadButtonStyle(){
              settings.style.buttonBarBackgroundColor = .white
              settings.style.buttonBarItemBackgroundColor = .white
		settings.style.selectedBarBackgroundColor = UIColor.gold
              settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 11)
              settings.style.selectedBarHeight = 2.0
              settings.style.buttonBarMinimumLineSpacing = 0
              settings.style.buttonBarItemTitleColor = .white
              settings.style.buttonBarItemsShouldFillAvailableWidth = true
              settings.style.buttonBarLeftContentInset = 0
              settings.style.buttonBarRightContentInset = 0

              changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
                  guard changeCurrentIndex == true else { return }
                  oldCell?.label.textColor = .white
                  newCell?.label.textColor = UIColor.gold
//                   //print("changeCurrentIndex: ", changeCurrentIndex)
              }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var vcArray = [UIViewController]()
        
        var child_1: HomeContainerViewController!
//            if !is_menu{
        child_1 = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeContainer") as! HomeContainerViewController)
                  child_1.itemInfo = "MENU"
                vcArray.append(child_1)
//              }
        
        var child_2: HomeContainerViewController!
              if !is_featured{
                child_2 = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeContainer") as! HomeContainerViewController)
                  child_2.itemInfo = "FEATURED"
                  child_2.isFeatured = true
                    vcArray.append(child_2)
              }
        
        var child_3: TransactionHistoryTableViewController!
              if !is_previous && Common.instance.isUserLogin() == true{
                child_3 = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionHistory") as! TransactionHistoryTableViewController)
                vcArray.append(child_3)
              }

        var child_4: FavouriteItemsViewController!
              if !is_favorites && Common.instance.isUserLogin() == true{
                child_4 = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FavouriteItems") as! FavouriteItemsViewController)
                vcArray.append(child_4)
              }
        
        var child_5: CouponsViewController!
              if !is_offers{
                child_5 = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CouponsViewController") as! CouponsViewController)
                vcArray.append(child_5)
              }
        
        
//        if Common.instance.isUserLogin() == false{
//
//            if !is_featured && !is_offers{
//                return [child_1, child_2, child_5]
//            }else if is_featured && !is_offers{
//                return [child_1, child_5]
//            }else if !is_featured && is_offers{
//                return [child_1, child_2]
//            }
//        }
  
        return vcArray
    }

    
    func setupBasketButton() {
    
        if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {

            basketButton = MIBadgeButton()
            basketButton.badgeString = String(BasketTable.getByShopIdAndUserId(String(1), loginUserId: String(loginUserId)).count)
            basketButton.badgeTextColor = UIColor.black
            basketButton.badgeBackgroundColor = UIColor.white
            basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 35, bottom: 0, right: 10)
            basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            basketButton.setImage(UIImage(named: "bag-1"), for: UIControl.State())
            
            basketButton.addTarget(self, action: #selector(ItemsGridViewController.loadBasketViewController(_:)), for: UIControl.Event.touchUpInside)
            
            let itemNaviBasket = UIBarButtonItem()
            itemNaviBasket.customView = basketButton
            self.navigationItem.rightBarButtonItem = itemNaviBasket
            
        }
        
    }
  
    
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: plistPath)) {
            if let bundlePath = Bundle.main.path(forResource: "LoginUserInfo", ofType: "plist") {
                
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: plistPath)
                } catch{
                    
                }
                
                
            } else {
                //print("LoginUserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
            
        } else {
            //print("LoginUserInfo.plist already exits at path.")
        }
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        loginUserId = 0

        if let dict = myDict {
            
           loginUserId = Common.instance.getLoginUserId(dict: dict)
        } else {
            
            if let dict = myDict {
              loginUserId = Common.instance.getLoginUserId(dict: dict)
            } else {
//                loginUserId = 0
               //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
            }
           //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    func updateNavigationStuff() {
           self.navigationController?.navigationBar.topItem?.title = language.aboutPageTitle
           //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor: UIColor.white]
       }
    func style() {
//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
        /*
        
        carbonTabSwipeNavigation.pagesScrollView?.isScrollEnabled = false
        carbonTabSwipeNavigation.setIndicatorColor(goldColor)
        for i in stride(from: 0, to: 3, by: 1) {
              carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(85, forSegmentAt: i)
        }
        carbonTabSwipeNavigation.carbonTabSwipeScrollView.isScrollEnabled = false
        carbonTabSwipeNavigation.setSelectedColor(goldColor, font: UIFont.boldSystemFont(ofSize: 14))
        carbonTabSwipeNavigation.setNormalColor(.white, font: UIFont.boldSystemFont(ofSize: 14))
        carbonTabSwipeNavigation.toolbar.barTintColor = UIColor.black

         */
    }
}
/*
extension HomeViewController: CarbonTabSwipeNavigationDelegate {
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        
        case 0:
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeContainer") as! HomeContainerViewController
            vc.carbonNavigation = self.carbonTabSwipeNavigation
            return vc
        case 1 :
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeContainer") as! HomeContainerViewController
            vc.isFeatured = true
            vc.carbonNavigation = self.carbonTabSwipeNavigation
            return vc
        case 2 :
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransactionHistory") as! TransactionHistoryTableViewController
            vc.carbonNavigation = self.carbonTabSwipeNavigation
            return vc
        case 3 :
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "FavouriteItems") as! FavouriteItemsViewController
            vc.carbonNavigation = self.carbonTabSwipeNavigation
            return vc
        case 4:
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "CouponsViewController") as! CouponsViewController
            vc.carbonNavigation = self.carbonTabSwipeNavigation
            return vc
            
            
        default:
            return self.storyboard!.instantiateViewController(withIdentifier: "FavouriteItems") as! FavouriteItemsViewController
            
        }
        
    }
   

}
*/

extension HomeViewController: HomeShopBasketCountUpdateDelegate {
    func updateBasketCount() {
        basketCountUpdate(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)
    }
    func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
    }
    @objc func loadBasketViewController(_ sender:UIButton) {
        
        if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {
            
            weak var BasketManagementViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Basket") as? BasketViewController
            BasketManagementViewController?.title = "Basket"
            BasketManagementViewController?.selectedItemCurrencySymbol = selectedItemCurrencySymbol
            BasketManagementViewController?.selectedShopArrayIndex = 0
            BasketManagementViewController?.selectedItemCurrencyShortForm = selectedItemCurrencyShortform
            BasketManagementViewController?.selectedShopId = 1
            BasketManagementViewController?.loginUserId = Int(loginUserId)
            BasketManagementViewController?.homeShopBasketCountUpdateDelegate = self
            BasketManagementViewController?.fromWhere = "home"
            
            self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
        }
    }
}



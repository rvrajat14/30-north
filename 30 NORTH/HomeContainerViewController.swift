//
//  HomeContainerViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 15/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import XLPagerTabStrip

@objc protocol SearchDelegate: class {
    @objc optional  func searchMsg(_ msg:String)
    func closePopup()
    @objc optional func returnCode(_ code:integer_t)
}

@objc protocol SinglePageDelegate: class {
    func openSinglePage(_ shop : Shop)
}

class HomeContainerViewController: UIViewController, SearchDelegate, SinglePageDelegate{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    
    var itemInfo: IndicatorInfo = ""

    var currentViewController: UIViewController?
    var searchString : String = ""
    var shopData : Shop?
    var basketButton = MIBadgeButton()
    var loginUserId:Int = 0
    var isFeatured = false
    // var carbonNavigation : CarbonTabSwipeNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        self.perform(#selector(loadViewWithDelay), with: nil, afterDelay: 1.0)
    }
	
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadLoginUserId()
        if isFeatured{
            itemInfo = "FEATURED"
        }else{
            itemInfo = "MENU"
        }
    }

//    override func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear(animated)
//		self.showCartButton()
//    }
    
    internal static func instantiate(with  itemInfo: IndicatorInfo) -> HomeContainerViewController {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeContainer") as! HomeContainerViewController
        vc.itemInfo = itemInfo
        return vc
    }
    @objc func loadViewWithDelay(){
        
        if(configs.startUpMode == "list") {
            loadComponent("ComponentShopsList", action: "")
            addNavigationMenuItem("map")
        } else if (configs.startUpMode == "map") {
            loadComponent("ComponentShopsMap", action: "")
            addNavigationMenuItem("list")
        }
        
        
//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
//        }
        
        updateNavigationStuff()
        
        self.addNavigationMenuItem("search")
    }
    func loadComponent(_ componentName: String, action: String) {
        
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: componentName)
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(self.currentViewController!)
        
        if(componentName == "ComponentShopsList" && action != "Search")  {
            let shopListView = self.currentViewController as? ShopsListViewController
            shopListView?.singlePageDelegate = self
            shopListView?.loadShops("all", keyword: "")
            
            searchString = ""
            
            self.addSubview((shopListView?.view)!, toView: self.containerView)
        } else if(componentName == "ComponentShopsList" && action == "Search") {
            let shopListView = self.currentViewController as? ShopsListViewController
            shopListView?.loadShops("search", keyword: searchString)
            
            self.addSubview((shopListView?.view)!, toView: self.containerView)
            
        } else if (componentName == "ComponentSingleShop" ) {
            let shopListView = self.currentViewController as? SingleShopViewController
            shopListView?.initUI(self.shopData!)
            self.addSubview((shopListView?.view)!, toView: self.containerView)
        } else if (componentName == "SelectedShop" ) {
            let shopView = self.currentViewController as? SelectedShopViewController
//            shopView?.shopModel = ShopModel(shop: self.shopData!)
//            shopView?.selectedShopArrayIndex = 0
//            shopView?.isFeatured = isFeatured
//            shopView?.carbonNavigation = self.carbonNavigation
//            if isFeatured {
//                shopView?.loadFeatureController()
//            } else {
                shopView?.loadMenuController()
//            }
            self.addSubview((shopView?.view)!, toView: self.containerView)
        }else if (componentName == "ComponentShopsMap") {
            let shopMapView = self.currentViewController as? ShopsMapViewController
            
            self.addSubview((shopMapView?.view)!, toView: self.containerView)
            
            searchString = ""
        }
        
        updateBackButton()
        
    }
    
    func addSubview(_ subView:UIView, toView parentView:UIView) {
        
        if parentView.subviews.count >= 1 {
            parentView.subviews[0].removeFromSuperview()
            
        }
        
        parentView.addSubview(subView)
       //print("*******\(parentView.subviews.count)")
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    
    func addNavigationMenuItem(_ menuName: String) {
        let btnNavi = UIButton()
        
        if(menuName == "map") {
            let btnNavi2 = UIButton()
            let btnNavi3 = UIButton()
            
            btnNavi.setImage(UIImage(named: "Map-Lite-White"), for: UIControl.State())
            btnNavi.addTarget(self, action: #selector(HomeContainerViewController.loadShopsMap(_:)), for: .touchUpInside)
            
            btnNavi3.setImage(UIImage(named: "Search-White"), for: UIControl.State())
            btnNavi3.addTarget(self, action: #selector(HomeContainerViewController.loadSearchPopUpView(_:)), for: .touchUpInside)
            
            btnNavi.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            btnNavi2.frame = CGRect(x: 0, y: 0, width: 4, height: 20)
            btnNavi3.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            
            let itemNavi = UIBarButtonItem()
            itemNavi.customView = btnNavi
            
            let itemNavi2 = UIBarButtonItem()
            itemNavi2.customView = btnNavi2
            
            let itemNavi3 = UIBarButtonItem()
            itemNavi3.customView = btnNavi3
            
            self.navigationItem.rightBarButtonItems = [itemNavi, itemNavi3]
        } else if (menuName == "list") {
            let btnNavi3 = UIButton()
            btnNavi.setImage(UIImage(named: "List-White"), for: UIControl.State())
            btnNavi.addTarget(self, action: #selector(HomeContainerViewController.loadShopsList(_:)), for: .touchUpInside)
            btnNavi.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            
            btnNavi3.setImage(UIImage(named: "Search-White"), for: UIControl.State())
            btnNavi3.addTarget(self, action: #selector(HomeContainerViewController.loadShopsMapWithSearch(_:)), for: .touchUpInside)
            btnNavi3.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            
            let itemNavi = UIBarButtonItem()
            itemNavi.customView = btnNavi
            
            let itemNavi3 = UIBarButtonItem()
            itemNavi3.customView = btnNavi3
            
            self.navigationItem.rightBarButtonItems = [itemNavi, itemNavi3]
            
        } else if (menuName == "search") {
            //TODO: need to change icon
            let btnSearch = UIButton()
            btnSearch.setImage(UIImage(named: "Search-White"), for: UIControl.State())
            btnSearch.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            btnSearch.addTarget(self, action: #selector(ItemsGridViewController.loadSearchPopUpView(_:)), for: .touchUpInside)
            let itemSearch = UIBarButtonItem()
            itemSearch.customView = btnSearch
            
            if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {
                basketButton = MIBadgeButton()
                basketButton.badgeString = String(BasketTable.getByShopIdAndUserId(String("1"), loginUserId: String(loginUserId)).count)
                basketButton.badgeTextColor = UIColor.black
                basketButton.badgeBackgroundColor = UIColor.white
                basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 35, bottom: 0, right: 10)
                basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                basketButton.setImage(UIImage(named: "bag-1"), for: UIControl.State())
                
                
                basketButton.addTarget(self, action: #selector(HomeContainerViewController.loadBasketViewController(_:)), for: UIControl.Event.touchUpInside)
                
                let itemNaviBasket = UIBarButtonItem()
                itemNaviBasket.customView = basketButton
                self.navigationItem.rightBarButtonItems = [itemNaviBasket, itemSearch]
            } else {
                self.navigationItem.rightBarButtonItems = [itemSearch]
            }
        } else {
            let itemNavi = UIBarButtonItem()
            itemNavi.customView = btnNavi
            
            self.navigationItem.rightBarButtonItems = [itemNavi]
        }
        
    }
    
    @objc func loadBasketViewController(_ sender:UIButton) {
        
        if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {
            
            weak var BasketManagementViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Basket") as? BasketViewController
            BasketManagementViewController?.title = "Basket"
            BasketManagementViewController?.selectedShopArrayIndex = 0
//            BasketManagementViewController?.selectedItemCurrencySymbol = self.shopData?.currencySymbol ?? ""
//            BasketManagementViewController?.selectedItemCurrencyShortForm = self.shopData?.currencyShortForm ?? ""
            BasketManagementViewController?.selectedItemCurrencySymbol = settingsDetailModel!.currency_symbol!
            BasketManagementViewController?.selectedItemCurrencyShortForm = settingsDetailModel!.currency_short_form!

            BasketManagementViewController?.selectedShopId = 1
            BasketManagementViewController?.loginUserId = loginUserId
            BasketManagementViewController?.itemsGridBasketCountUpdateDelegate = self
            BasketManagementViewController?.fromWhere = "grid"
            
            self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
            updateBackButton()
            
        } else {
            _ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.customImag(imageFile: "Logo"))
        }
        
    }
    
    @objc func loadShopsMap(_ sender: UIBarButtonItem) {
        loadComponent("ComponentShopsMap", action: "")
        addNavigationMenuItem("list")
        updateBackButton()
        
    }
    
    @objc func loadShopsList(_ sender: UIBarButtonItem) {
        loadComponent("ComponentShopsList", action: "")
        addNavigationMenuItem("map")
        updateBackButton()
    }
    
    @objc func loadShopsMapWithSearch(_ sender: UIBarButtonItem) {
        let shopMapView = self.currentViewController as? ShopsMapViewController
        
        shopMapView?.openRangePopup()
    }
    
    @objc func loadSearchPopUpView(_ sender: UIBarButtonItem) {
       //print("Opening search popup.")
        
        //        addNavigationMenuItem("")
        
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier:"SearchPopUpID") as! SearchPopUpViewController
        self.addChild(popOverVC)
        popOverVC.searchDelegate = self
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.homePageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    internal func closePopup() {
        addNavigationMenuItem("map")
    }
    
    internal func searchMsg(_ msg: String) {
        searchString = msg
        loadComponent("ComponentShopsList", action: "Search")
        addNavigationMenuItem("search")
        updateBackButton()
    }
    
    internal func openSinglePage(_ shop : Shop) {
        self.shopData = shop
        loadComponent("SelectedShop", action: "")
        //        loadComponent("ComponentSingleShop", action: "")
        addNavigationMenuItem("search")
    }
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {
            
           loginUserId = Common.instance.getLoginUserId(dict: dict)
        }
    }
    
}
extension HomeContainerViewController: ItemsGridBasketCountUpdateDelegate {
    func updateBasketCount() {
        basketCountUpdate(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)
    }
    
    func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
        
    }
}

extension HomeContainerViewController : IndicatorInfoProvider
{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

//
//  SelectedCityViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 3/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import CarbonKit
import AlamofireMapper
import GoogleMaps
import MapKit

@objc protocol UpdateBasketCountsDelegate: class {
    func updateBasketCount(_ basketCount: Int)
}

@objc protocol SelectedShopBasketCountUpdateDelegate: class {
    func updateBasketCount()
}

class SelectedShopViewController: UIViewController, SearchDelegate, UITableViewDelegate, UITableViewDataSource {
    func closePopup() {}
    
    var currentShop: Shop? = nil
    var subCategoryArray = [SubCategories]()
    var allSubCategoriesFromAllMainCategories = [SubCategories]()
    var categoryWithAllSubCatsFromAllMainCategories : Categories? = nil
    var subCategoriesBasedOnOulet = [SubCategories]()
    var categoriesBasedOnOulet = [Categories]()
    var categories: [AnyObject] = []
    var selectedShopCoverImage: String!
    var selectedShopArrayIndex: Int!
    var subCategoriesSelected: [SubCategory] = []
    var featuredCats = [Categories]()
    var basketButton: MIBadgeButton!
    var loginUserId: Int = 0
    var defaultValue: CGPoint!
    var currentPage = 0
    var items = [ItemModel]()
    var seeAllArray = [Int]()
    var selectedCategoryIndex = 0
    var allItemsFrom30North = [ItemModel]()
    var subCategories = [SubCategories]()
    var itemCategories = [SubCategories]()
    var isFeatured = false
    var index = 0
    var sectionTitles = [String]()
    var selectedItemIndex = 0
    var refreshControl = UIRefreshControl()
    var allOutlets : [Outlet]? = []
    var nearestOulet : Outlet? = nil
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!{
        didSet {
            categoriesCollectionView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var imagesView: AutoImageScrollView!
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView! {
        didSet {
            subCategoryCollectionView.backgroundColor = UIColor.mainViewBackground
        }
    }
    private var featuredInitialArray : Array<Featured>?
    private var featuredCategoryArray : Array<FeaturedCategories>?
    let locationManager = CLLocationManager()
    var currentLocationCoordinate: CLLocationCoordinate2D? = nil
    var didFindMyLocation:Bool = false
    let buttonColor = UIColor(displayP3Red: 0.176, green: 0.192, blue: 0.235, alpha: 1)
    var selectedOutletCoordinates: CLLocationCoordinate2D? = nil
    var bounds = GMSCoordinateBounds()
    
    @IBOutlet weak var viewWithMapAndList: UIView! {
           didSet {
           }
       }
    //MARK:- Property
    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.backgroundColor = self.buttonColor
        }
    }
    
    
    
    @IBOutlet weak var subTitleLabel: UILabel! {
           didSet {
            subTitleLabel.font =  UIFont(name: AppFontName.bold, size: 14)
           }
       }
    
    @IBOutlet weak var listButton: UIButton! {
        didSet {
            listButton.layer.borderColor = UIColor.black.cgColor
            listButton.layer.borderWidth = 1.0
            listButton.layer.cornerRadius = 3.0
            listButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var mapButton: UIButton! {
        didSet {
            mapButton.layer.borderColor = UIColor.black.cgColor
            mapButton.layer.borderWidth = 1.0
            mapButton.layer.cornerRadius = 3.0
            mapButton.clipsToBounds = true
            
            
        }
    }
    
    @IBOutlet weak var outletsTableView: UITableView!{
        didSet {
            outletsTableView.backgroundColor = UIColor.clear
            outletsTableView.delegate = self
            outletsTableView.dataSource = self
            outletsTableView.register(UINib(nibName: "ShopByOutletCell", bundle: nil), forCellReuseIdentifier: "ShopByOutletCell")
        }
    }
    
    
    @IBOutlet weak var outletMapView: GMSMapView! {
        didSet {
            outletMapView.mapType = .normal
            outletMapView.delegate = self
        }
    }
    
    
    
    @IBAction func listButtonAction(_ sender: UIButton) {
        sender.backgroundColor = .black
        mapButton.backgroundColor = self.buttonColor
        
        sender.isEnabled = false
        outletsTableView.isHidden = false
        
        self.mapButton.isEnabled = true
        self.outletMapView.isHidden = true
    }
    
    @IBAction func mapButtonAction(_ sender: UIButton) {
        sender.backgroundColor = .black
        listButton.backgroundColor = self.buttonColor
        
        sender.isEnabled = false
        self.outletMapView.isHidden = false
        
        self.listButton.isEnabled = true
        outletsTableView.isHidden = true
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allOutlets!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 200.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopByOutletCell") as! ShopByOutletCell
        let outlet : Outlet = self.allOutlets![indexPath.row]
        
        
        if let _ = outlet.open_from, let _ = outlet.open_to {
            if(outlet.is_open == 0) {
                // Closed
                let str = outlet.name!
                let font = UIFont(name: AppFontName.bold, size: 18)
                let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : font!])
                cell.outletName.attributedText = attributedString
            } else {
                let dateFromat = DateFormatter()
                
//                dateFromat.dateStyle = .medium
//                dateFromat.timeStyle = .medium
                dateFromat.dateFormat = "HH:mm"
                
                dateFromat.locale = Locale.current
                dateFromat.timeZone = TimeZone.current
                let dateFrom : Date = dateFromat.date(from: (outlet.open_from)!)! // In your case its string1
                print(dateFrom)
                let dateTo : Date = dateFromat.date(from: (outlet.open_to)!)! // In your case its string1
                print(dateTo)
                let currentDateString : String = dateFromat.string(from: Date())
                print(currentDateString)
                let currentDate : Date = dateFromat.date(from: (currentDateString))!
                print(currentDate)
       
                print(dateFromat.string(from: currentDate))
                print(dateFromat.string(from: dateFrom))
                print(dateFromat.string(from: dateTo))
                
                print(currentDate.isBetweenn(date: dateFrom, andDate: dateTo))
                
                if (currentDate > dateFrom && currentDate < dateTo) == true {
//                if(currentDate.isBetween(dateFrom, and: dateTo) == true){
                    //openUntil.text = "Open until \(toTimeArray[1])"
                    let ab : TimeInterval = dateTo.timeIntervalSince(currentDate)
                    if(ab < 1800 && ab > 0){
                        let str = outlet.name! + " (Closing Soon)"
                        let font = UIFont(name: AppFontName.bold, size: 18)
                        let italicsFont = UIFont.italicSystemFont(ofSize: 18)
                        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : font!])
                        attributedString.addAttribute(NSAttributedString.Key.font, value: italicsFont, range: NSMakeRange(str.count-15, 15))
                        cell.outletName.attributedText = attributedString
                        
                    }else{
                        let str = outlet.name!
                        let font = UIFont(name: AppFontName.bold, size: 18)
                        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : font!])
                        cell.outletName.attributedText = attributedString
                    }
                }
                else{
                    let str = outlet.name!
                    let font = UIFont(name: AppFontName.bold, size: 18)
                    let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : font!])
                    cell.outletName.attributedText = attributedString
                }
            }
        }
 
        //cell.outletName.text = outlet.name
        //cell.outletImage.image = UIImage(named: optionImages[indexPath.row])
        cell.outletImage.kf.setImage(with: URL(string: configs.outletImageUrl + outlet.id! + ".png"), placeholder: UIImage(named: "itemImagePlaceholder"), options: .none, progressBlock: .none)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let outlet : Outlet = self.allOutlets![indexPath.row]
        print("Selected outlet id is \(outlet.id!)")
        //let itemsForOutlet = self.allItemsFrom30North!.filter({$0.shops.shopId == outlet.id })
        self.askPermissionToSaveOutletAndGoToItemsPage(outlet: outlet)
        
    }
    
    
    
    //MARK:- LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.mainViewBackground
        self.subCategoryCollectionView.backgroundColor = UIColor.mainViewBackground
        self.imagesView.backgroundColor = UIColor.mainViewBackground
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        subCategoryCollectionView.addSubview(refreshControl)
        
        if(Common.instance.isUserLogin()) {
            loadLoginUserId()
        }
        self.loginCheck()
        addMenuButton()
        
        /*
         //Calling to preload data.
         self.viewWithMapAndList.isHidden = true
        self.subCategoryCollectionView.isHidden = false
         selectedCategoryIndex = 0
         loadMenuController()
         self.subCategoryCollectionView.reloadData()
         */
        
        
        //Let's call Outlet api
        getCurrentLocation()
        self.viewWithMapAndList.isHidden = false
        self.subCategoryCollectionView.isHidden = true
        self.listButton.sendActions(for: .touchUpInside)
         
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Commenting this as per : https://trello.com/c/NUw71NkT/206-urgent-remove-order-tab-slider . Also setting height of ImageView in storyboard to be zero for now. So that can be used later.
        //self.imagesView.configure(selectedShopId: 1, parentView: self, isFromMain: false)
        
        
        self.subCategoryCollectionView.reloadData()
        selectedCategoryIndex = 0
        
        
        self.categoriesCollectionView.isHidden = true
        if let _ = settingsDetailModel{
        }else{
            appDelegate.doSettingsAPI()
            return
        }
        addNavigationMenuItem()
        loadMenuController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNavigationStuff()
        self.showCartButton()
        
        if(self.allOutlets!.count <= 0){
            // Call Get Outlets and Menu API only single time
            self.callGetOutletsAPI()
        }

    }
    
    func distanceBetweenTwoCoordinates(shop: Outlet) -> Double{
        guard let lat = shop.lat else{ return 0}
        guard let long = shop.lon else{ return 0}
        
        let shopLatitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(lat)!)!
        let shopLongitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(long)!)!
        
        let shopLocation = CLLocation(latitude: shopLatitude , longitude: shopLongitude)
        let currentLocation = CLLocation(latitude: currentLocationCoordinate?.latitude ?? 0.0, longitude: currentLocationCoordinate?.longitude ?? 0.0)
        
        let distance : Double = getDistance(location1: currentLocation, location2: shopLocation)
        return distance
    }
    
    func getDistance(location1 : CLLocation, location2 : CLLocation) -> Double {
        let distanceInMeters = location1.distance(from: location2)
        return distanceInMeters
    }
    
    //MARK: Ask Permission To Save outlet and then go to Items page
    func askPermissionToSaveOutletAndGoToItemsPage(outlet : Outlet){
        //Letl's check if user is going to an outlet for the first time
        if(appDelegate.selectedOutletByUser == nil){
            _ = SweetAlert().showAlert("", subTitle: String.init(format: "Choose %@?",outlet.name!), style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "CONFIRM", buttonColor: .clear, otherButtonTitle: "CANCEL") { (isOk) in
                if isOk {
                    appDelegate.selectedOutletByUser = outlet
                    self.goToOutletItemsPage(outlet: outlet)
                } else {
                    //Do Nothing
                    return
                }
            }
        }else{
            // if user is going to same out let do nothing otherwise we have to clear cart items if there are any
            if(appDelegate.selectedOutletByUser?.id == outlet.id){
                //Going again to same outlet do nothing and let him move
                self.goToOutletItemsPage(outlet: outlet)
            }else{
                //User is going to differnt outlet // let's check cart first
                let userID = self.isUserLoggedIn()
                if userID > 0 {
                    let allBasketSchemas = BasketTable.getByShopIdAndUserId(String(1), loginUserId: String(userID))
                    if allBasketSchemas.count > 0 {
                        _ = SweetAlert().showAlert("", subTitle: String.init(format: "Clear basket and change store to %@?",outlet.name!), style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "CONFIRM", buttonColor: .clear, otherButtonTitle: "CANCEL") { (isOk) in
                            if isOk {
                                //Let's remove item and then move on
                                if allBasketSchemas.count > 0 {
                                    for ab in allBasketSchemas{
                                        // BasketTable.deleteAll(ab)
                                        BasketTable.deleteByKeyIds("1", selectedId: Int64(ab.id!))
                                    }
                                }
                                appDelegate.selectedOutletByUser = outlet
                                self.goToOutletItemsPage(outlet: outlet)
                            } else {
                                //Do Nothing
                                return
                            }
                        }
                    }else{
                        //There are no items but store is being changed.
                        _ = SweetAlert().showAlert("", subTitle: String.init(format: "Change store to %@?",outlet.name!), style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "CONFIRM", buttonColor: .clear, otherButtonTitle: "CANCEL") { (isOk) in
                            if isOk {
                                appDelegate.selectedOutletByUser = outlet
                                self.goToOutletItemsPage(outlet: outlet)
                            } else {
                                //Do Nothing
                                return
                            }
                        }
                    }
                    
                }else{
                    //User is not logged in // let him go inside
                    _ = SweetAlert().showAlert("", subTitle: String.init(format: "Change store to %@?",outlet.name!), style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "CONFIRM", buttonColor: .clear, otherButtonTitle: "CANCEL") { (isOk) in
                        if isOk {
                            appDelegate.selectedOutletByUser = outlet
                            self.goToOutletItemsPage(outlet: outlet)
                        } else {
                            //Do Nothing
                            return
                        }
                    }
                }
            }
            
            
        }
    }
    
    //MARK: Go To Outlet Items page
    func goToOutletItemsPage(outlet : Outlet){
        
        /*
        let itemsForOutlet = self.allItemsFrom30North.filter({ (item) -> Bool in
            let AllShops = item.shops
            let isShopThere = AllShops.filter({$0.shopId == outlet.id})
            if(isShopThere.count > 0){
                return true
            }else{
                return false
            }
        })
        print("Total items for Outlet \(itemsForOutlet.count)")
        if(itemsForOutlet.count > 0){
                   let orderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTabViewController") as! OrderTabViewController
                   orderVC.selectedOutlet = outlet
                   orderVC.allItemsForSelectedOutlet = itemsForOutlet
                   orderVC.isShowingOutletMenuItems = true
                   self.navigationController?.pushViewController(orderVC, animated: true)
               }else{
                   _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noItemsForOutlet, style: AlertStyle.customImag(imageFile: "Logo"))
                   
        }*/
        
        //This logic here filter categories, subcategories and items in the outlet based on the availability at that oulet.
        self.categoriesBasedOnOulet.removeAll()
        self.subCategoriesBasedOnOulet.removeAll()
        var itemsArr = [ItemModel]()
        for cat in self.currentShop!.categories{
            self.subCategoriesBasedOnOulet.removeAll()
            for subCat in cat.subCategories{
                itemsArr.removeAll()
                for item in subCat.item {
                    let oneItem = ItemModel(item: item)
                    if(oneItem.is_selection == "1"){
                        print("Don't need to show this item in Order tab, this is intended for filters only\n")
                    }else{
                        let AllShops = oneItem.shops
                        let isShopThere = AllShops.filter({$0.shopId == outlet.id})
                        if(isShopThere.count > 0){
                            itemsArr.append(oneItem)
                        }else{
                            //This item is not available for selected outlet
                        }
                    }
                }
                //If this category has at least one item then only create its sub category for this outlet
                if(itemsArr.count > 0){
                    let tempSubCat = SubCategories(id: subCat.id!, catId: subCat.catId!, name: subCat.name!,description: (subCat.desc != nil ? subCat.desc! : ""), imageURL: subCat.coverImageFile!, items: itemsArr)
                    self.subCategoriesBasedOnOulet.append(tempSubCat)
                }
            }
            //Create main category only if there is any sub category in it.
            if(self.subCategoriesBasedOnOulet.count > 0){
                let tempCat = Categories(id: cat.id!, name: cat.name!, desc: cat.desc ?? "", imageURL: cat.coverImageFile!, subCategory: self.subCategoriesBasedOnOulet)
                self.categoriesBasedOnOulet.append(tempCat)
            }
          
        }
 
        if(self.categoriesBasedOnOulet.count > 0){
            let mainMenuCategoriesVC = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuCategoriesViewController") as! MainMenuCategoriesViewController
                mainMenuCategoriesVC.selectedOulet = outlet
                mainMenuCategoriesVC.allMainCategoriesForMenu = self.categoriesBasedOnOulet
                self.navigationController?.pushViewController(mainMenuCategoriesVC, animated: true)
                return
        }else{
            _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noItemsForOutlet, style: AlertStyle.customImag(imageFile: "Logo"))
                   
        }
        
        
        
        
       
    }
    
    
    //MARK: Go To Outlet items view
    @IBAction func goToShopByOutletsView(_ sender: UIButton) {
        
        //MARK:- GET OUTLET  API CALL
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        Alamofire.request(APIRouters.GetOutlets).responseCollection {
            (response: DataResponse<[Outlet]>) in
            DispatchQueue.main.async {
                _ = EZLoadingActivity.hide()
                if response.result.isSuccess {
                    if let outlets: [Outlet] = response.result.value {
                        self.allOutlets?.removeAll()
                        for outlet in outlets {
                            if(outlet.is_open == 1){
                                self.allOutlets?.append(outlet)
                            }
                        }
                        
                        if(self.allOutlets!.count > 0){
                            let shopByOutlet : ShopByOutlet = ShopByOutlet(nibName: "ShopByOutlet", bundle: nil)
                            shopByOutlet.allOutlets = self.allOutlets
                            shopByOutlet.allItemsFrom30North = self.allItemsFrom30North
                            self.navigationController?.pushViewController(shopByOutlet, animated: true)
                        }else{
                            _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noOutlets, style: AlertStyle.customImag(imageFile: "Logo"))
                        }
                        
                        
                    } else {
                        _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noShops, style: AlertStyle.customImag(imageFile: "Logo"))
                    }
                }
            }
        }
        
        
        
        
    }
    
    //MARK: Get Outlets API
    func callGetOutletsAPI(){
        //MARK:- GET OUTLET  API CALL
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        Alamofire.request(APIRouters.GetOutlets).responseCollection {
            (response: DataResponse<[Outlet]>) in
            print(response)
            DispatchQueue.main.async {
                
                _ = EZLoadingActivity.hide()

                //Let's call second API to get all items now
                self.loadShopData(showLoading: true)
                if response.result.isSuccess {
                    if let outlets: [Outlet] = response.result.value {
                        self.allOutlets?.removeAll()
                        for outlet in outlets {
                            //Commenting for testing
                            if(outlet.is_open == 1){
                                print(outlet)
                                self.allOutlets?.append(outlet)
                            }
                        }
                        
                        if(self.allOutlets!.count > 0){
                            
                            if(self.currentLocationCoordinate != nil){
                                //Let's find closest outlet
                                
                                var minDistance = 999999999.0
                                for ot in self.allOutlets!{
                                    let distance = self.distanceBetweenTwoCoordinates(shop: ot)
                                    if(distance < minDistance){
                                        minDistance = distance
                                        self.nearestOulet = ot
                                    }
                                }
                                
                                if(self.nearestOulet != nil){
                                    print("Closest outlet is \(String(describing: self.nearestOulet?.name)) and is \(minDistance) meters away")
                                }
                            }
                            
                            
                            self.outletsTableView.reloadData()
          
                            //Add pins to map
                            self.addAnnotations()
                       
                            //We are not going to next page yet
                            /*
                             let shopByOutlet : ShopByOutlet = ShopByOutlet(nibName: "ShopByOutlet", bundle: nil)
                             shopByOutlet.allOutlets = self.allOutlets
                             shopByOutlet.allItemsFrom30North = self.allItemsFrom30North
                             self.navigationController?.pushViewController(shopByOutlet, animated: true)
                             */
                        }else{
                            _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noOutlets, style: AlertStyle.customImag(imageFile: "Logo"))
                        }
                        
                        
                    } else {
                        _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noShops, style: AlertStyle.customImag(imageFile: "Logo"))
                    }
                }
            }
        }
        
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    //MARK:- USER DEFINED METHODS
    func loadMenuController() {
        if cats.count > 0 {
            self.fetchSubItems(0)
        }else {
            loadShopData(showLoading: false)
        }
    }
    
    /*
     func loadFeatureController() {
     self.getFeaturedViaService()
     updateSeeAllCount()
     }*/
    @objc func refresh(sender:AnyObject) {
        //print("pull to refressh yeah")
        levelIndex = 0
        if let _ = settingsDetailModel{
            
        }else{
            appDelegate.doSettingsAPI()
            return
        }
        loadShopData(showLoading: true)
    }
    
    func updateSeeAllCount(){
        var itemsCnt = 0
        for category in categoryArray {
            
            itemsCnt  = 0
            
            var subCats : [SubCategories]
            var subItems : [SubCategories]
            subCats = category.subCategory.filter({ (item) -> Bool in
                return item.name != category.name
            })
            
            subItems = category.subCategory.filter({ (item) -> Bool in
                return item.name == category.name
            })
            
            for subCat in subItems {
                itemsCnt += subCat.items.count
            }
            itemsCnt += subCats.count
            seeAllArray.append(itemsCnt)
        }
        
        //print("seeAllArray  ",seeAllArray)
        subCategoryCollectionView.reloadData()
    }
    
    func loadShopData(showLoading: Bool) {
        refreshControl.endRefreshing()
        if(showLoading == true){
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
        }
        _ = Alamofire.request(APIRouters.GetShopByID(1)).responseObject {
            (response: DataResponse<Shop>) in

            DispatchQueue.main.async {
                _ = EZLoadingActivity.hide()

                switch response.result {
                case .success:
                    
                    if let shop: Shop = response.result.value {
                        ////print(shop)
                        
                        //saving this to filter data later based on user selection of outlet
                        self.currentShop = shop

                        
                        categoryArray.removeAll()
                        cats.removeAll()
                        
                        shopModel = ShopModel(shop: shop)
                        
                        //print("Loop Started...")
                        //                            self.getCategory(i: 0, shop: shop)
                        
                        
                        self.allItemsFrom30North.removeAll()
                        var itemsArr = [ItemModel]()
                        self.allSubCategoriesFromAllMainCategories.removeAll()
                        for cat in shop.categories{
                            self.subCategoryArray.removeAll()
                            for subCat in cat.subCategories{
                                itemsArr.removeAll()
                                for item in subCat.item {
                                    let oneItem = ItemModel(item: item)
                                    if(oneItem.is_selection == "1"){
                                        print("Don't need to show this item in Order tab, this is intended for filters only\n")
                                    }else{
                                        itemsArr.append(oneItem)
                                        self.allItemsFrom30North.append(oneItem)
                                    }
                                }
                                
                                let tempSubCat = SubCategories(id: subCat.id!, catId: subCat.catId!, name: subCat.name!,description: (subCat.desc != nil ? subCat.desc! : ""), imageURL: subCat.coverImageFile!, items: itemsArr)
                                self.subCategoryArray.append(tempSubCat)
                                self.allSubCategoriesFromAllMainCategories.append(tempSubCat)
                            }
                            
                            let tempCat = Categories(id: cat.id!, name: cat.name!, desc: cat.desc ?? "", imageURL: cat.coverImageFile!, subCategory: self.subCategoryArray)
                            categoryArray.append(tempCat)
                        }
                        
                        
                        self.categoryWithAllSubCatsFromAllMainCategories = Categories(id: "", name: "Everything", desc: "Everything here", imageURL: "", subCategory: self.allSubCategoriesFromAllMainCategories)
                        
                        
                        cats = categoryArray
                        ////print("cats : ",cats)
                        self.categoriesCollectionView.reloadData()
                        self.fetchSubItems(0)
                        
                    }else{
                        _ = EZLoadingActivity.hide()
                    }
                case .failure(let _):
                    //print(error)
                    _ = EZLoadingActivity.hide()
                }
                
            }
        }
        
    }
    
    func addNavigationMenuItem() {
        
        let btnSearch = UIButton()
        btnSearch.setImage(UIImage(named: "Search-White"), for: UIControl.State())
        btnSearch.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnSearch.addTarget(self, action: #selector(ItemsGridViewController.loadSearchPopUpView(_:)), for: .touchUpInside)
        let itemSearch = UIBarButtonItem()
        itemSearch.customView = btnSearch
        
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
            self.navigationItem.rightBarButtonItems = [itemNaviBasket, itemSearch]
        }else {
            self.navigationItem.rightBarButtonItems = [itemSearch]
        }
    }
    
    @objc func loadBasketViewController(_ sender:UIButton) {
        
        if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {
            
            weak var BasketManagementViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Basket") as? BasketViewController
            BasketManagementViewController?.title = "Basket"
            //            BasketManagementViewController?.selectedItemCurrencySymbol = selectedItemCurrencySymbol
            //            BasketManagementViewController?.selectedShopArrayIndex = selectedShopArrayIndex
            //            BasketManagementViewController?.selectedItemCurrencyShortForm = selectedItemCurrencyShortform
            //            BasketManagementViewController?.selectedShopId = selectedShopId
            BasketManagementViewController?.loginUserId = Int(loginUserId)
            BasketManagementViewController?.selectedShopBasketCountUpdateDelegate = self
            BasketManagementViewController?.fromWhere = "selectedshop"
            
            self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
            updateBackButton()
            
        } else {
            _ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.customImag(imageFile: "Logo"))
        }
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc func loadNewsViewController(_ sender: UIBarButtonItem) {
        weak var feedViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedList") as? NewsFeedTableViewController
        updateBackButton()
        self.navigationController?.pushViewController(feedViewController!, animated: true)
        //        feedViewController?.selectedShopId = Int(shopModel!.id)!
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
                ////print("LoginUserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
            
        } else {
            ////print("LoginUserInfo.plist already exits at path.")
        }
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        
        if let dict = myDict {
            loginUserId           = Common.instance.getLoginUserId(dict: dict)
        } else {
            
            if let dict = myDict {
                loginUserId           = Common.instance.getLoginUserId(dict: dict)
            } else {
                loginUserId = 0
                //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
            }
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    
    func basketCountUpdate(_ itemCount: Int) {
        if let basketBtn = basketButton{
            basketBtn.badgeString = String(itemCount)
            basketBtn.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
        }
    }
    func addMenuButton(){
        //        if self.revealViewController() != nil {
        //            menuButton.target = self.revealViewController()
        //            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        //            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        //        }
    }
    /*** GetFeaturedService ****/
    private func getFeaturedViaService() {
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        Alamofire.request(APIRouters.GetFeatured).responseObject { (response: DataResponse<FeaturedDataResponse>) in
            
            guard response.result.isSuccess else {
                /*** Return Error ***/
                _ = EZLoadingActivity.hide()
                //print("Error while fetching Response :: \(response.result.error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            guard let responseObj = response.result.value else {
                _ = EZLoadingActivity.hide()
                return
            }
            
            guard let featuredArray = responseObj.featured else {
                _ = EZLoadingActivity.hide()
                return
            }
            
            DispatchQueue.main.async {
                self.featuredInitialArray = featuredArray
                self.featuredCategoryArray = Array<FeaturedCategories>()
                
                if let featuredInitialArray = self.featuredInitialArray, featuredInitialArray.count > 0 {
                    
                    for featured in featuredInitialArray {
                        
                        let categoriesId = featured.category_id
                        let categoriesNameArray = self.featuredCategoryArray?.filter({ (featureCategory) -> Bool in
                            return featureCategory.categoriesID == categoriesId
                        })
                        
                        if categoriesNameArray?.count == 0 {
                            
                            var featureCategories = FeaturedCategories()
                            featureCategories.categoriesName = featured.category_name
                            featureCategories.categoriesID = featured.category_id
                            
                            let subCategoriesArray = featuredInitialArray.filter({ (featureCategory) -> Bool in
                                return featureCategory.category_id == featureCategories.categoriesID
                            })
                            
                            featureCategories.subcategories = subCategoriesArray
                            
                            self.featuredCategoryArray?.append(featureCategories)
                        }
                    }
                    
                    if let featureCategoryArray = self.featuredCategoryArray {
                        self.sectionTitles = featureCategoryArray.map{$0.categoriesName ?? ""}
                    }
                }
                
                self.reloadDatas()
            }
        }
    }
    
    /*** Reload Datas ***/
    private func reloadDatas() {
        /*
         if let featureCategoryArray = self.featuredCategoryArray,  featureCategoryArray.count > 0 {
         self.featuredTable.isHidden = false
         self.featuredTable.isUserInteractionEnabled = true
         self.featuredTable.reloadData()
         }else {
         /*** To Display No Data ***/
         }
         
         _ = EZLoadingActivity.hide()
         */
    }
}

//MARK:- EXTENSION METHODS

extension SelectedShopViewController: UpdateBasketCountsDelegate {
    
    func updateBasketCount(_ basketCount: Int) {
        if let basketBtn = basketButton{
            basketBtn.badgeString = String(basketCount)
            basketBtn.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
        }
    }
}

extension SelectedShopViewController: SelectedShopBasketCountUpdateDelegate {
    func updateBasketCount() {
        basketCountUpdate(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)
    }
}

extension SelectedShopViewController  {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data =  sender as! (String , String)
        //print("data : ",Int(data.1)!)
        
        if segue.identifier == "segueItems" {
            weak var itemsGridPage = segue.destination as? ItemsGridViewController
            itemsGridPage!.loginUserId = Int(loginUserId)
            itemsGridPage!.selectedSubCategoryId = Int(data.1)!
            //            itemsGridPage!.selectedShopId = 1 //Int(shopModel!.id)!
            itemsGridPage!.navTitle = data.0
            itemsGridPage!.selectedShopLat = shopModel!.lat
            itemsGridPage!.selectedShopLng = shopModel!.lng
            itemsGridPage!.selectedShopName = shopModel!.name
            itemsGridPage!.selectedShopDesc = shopModel!.description
            itemsGridPage!.selectedShopPhone = shopModel!.phone
            itemsGridPage!.selectedShopEmail = shopModel!.email
            itemsGridPage!.selectedShopAddress = shopModel!.address
            itemsGridPage!.selectedShopCoverImage = selectedShopCoverImage
            itemsGridPage!.selectedShopStripePublishableKey = shopModel!.stripePublishableKey
            //print(items)
            itemsGridPage!.items = items
            //            itemsGridPage!.selectedShopArrayIndex = selectedShopArrayIndex
            itemsGridPage!.selectedItemCurrencySymbol = settingsDetailModel!.currency_symbol!
            itemsGridPage!.selectedItemCurrencyShortform = settingsDetailModel!.currency_short_form!
            itemsGridPage!.updateBasketCountsDelegate = self
            updateBackButton()
        } else {
            weak var itemDetailPage = segue.destination as? ItemDetailViewController
            itemDetailPage!.selectedItemId = Int(data.1)!
            itemDetailPage!.navTitle = data.0
            //            itemDetailPage!.selectedShopId = selectedShopId
            itemDetailPage!.selectedShopLat = shopModel!.lat
            itemDetailPage!.selectedShopLng = shopModel!.lng
            itemDetailPage!.selectedShopName = shopModel!.name
            itemDetailPage!.selectedShopDesc = shopModel!.description
            itemDetailPage!.selectedShopPhone = shopModel!.phone
            itemDetailPage!.selectedShopEmail = shopModel!.email
            itemDetailPage!.selectedShopAddress = shopModel!.address
            itemDetailPage!.selectedShopCoverImage = selectedShopCoverImage
            itemDetailPage!.selectedSubCategoryId = Int(data.1)!
            itemDetail = items[selectedItemIndex]
            //            itemDetailPage!.selectedShopArrayIndex = selectedShopArrayIndex
            //            itemDetailPage!.refreshLikeCountsDelegate = self
            //            itemDetailPage!.refreshReviewCountsDelegate = self
            itemDetailPage!.refreshBasketCountsDelegate = self
            itemDetailPage!.basketTotalAmountUpdateDelegate = self
            //
            //            selectedCell = itemCell
            updateBackButton()
        }
        
        
    }
    
}

extension SelectedShopViewController : RefreshBasketCountsDelegate, BasketTotalAmountUpdateDelegate {
    func updateTotalAmount(_ amount: Float, reloadAll: Bool) {
    }
    func updateBasketCounts(_ basketCount: Int) {
        if let basketBtn = basketButton{
            basketBtn.badgeString = String(basketCount)
            basketBtn.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
        }
    }
    func updatedFinalAmount(_ amount: Float) {
        UIView.animate(withDuration: 0.4) {
            //            self.totalAmountLabel.text = "Total Amount : \(amount)"
            //            if amount == 0.0 {
            //                self.tableviewBottomConstraint.constant = 64
            //            } else {
            //                self.tableviewBottomConstraint.constant = 114
            //            }
        }
    }
    @objc func seeAll(_ sender : UIButton) {
        index = 3
        
        //        self.carbonNavigation?.setCurrentTabIndex(0, withAnimation: true)
    }
    
    func fetchSubItems(_ index : Int) {
        //print("selectedCategoryIndex : ",selectedCategoryIndex)
        let cat = cats[selectedCategoryIndex]
        
        if cat.subCategory.count == 1{
            let subCat = cat.subCategory[0]
            let catName = cat.id
            let subCatName = subCat.catId
            //print("id check : ",catName, subCatName)
            //                if catName.contains(subCatName){
            if (subCatName == catName) {
                levelIndex = 2
                items = cat.subCategory[0].items
                subCategoryCollectionView.reloadData()
                return
            }else{
                levelIndex = 1
            }
        }
        
        subCategories = cat.subCategory
        //print("subCategories : ",subCategories)
        items = cat.subCategory[0].items
        //print("items : ",items)
        subCategoryCollectionView.reloadData()
        categoriesCollectionView.reloadData()
    }
    
}


//MARK: Current Location Delegates
extension SelectedShopViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.outletMapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocationCoordinate = manager.location!.coordinate
        
        //We are not showing current location
        //self.cameraMoveToLocation(toLocation: currentLocationCoordinate)
        //Finally stop updating location otherwise it will come again and again in this delegate
        
        if(self.currentLocationCoordinate != nil){
            self.locationManager.stopUpdatingLocation()
        }
        
    }
    
    //MARK: Add Annotations
    func addAnnotations(){
        guard let outlets = self.allOutlets else {
            return
        }
        
        bounds = GMSCoordinateBounds()
        
        for outlet in outlets {
            
            guard let lat = outlet.lat else{
                //print("Error lat")
                return
            }
            guard let long = outlet.lon else{
                //print("Error long")
                return
            }
            guard let name = outlet.name else {
                //print("Error name")
                return
            }
            
            let latitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(lat)!)!
            let longitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(long)!)!
            let locValue = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let marker = GMSMarker()
            marker.position = locValue
            marker.title = name
            marker.map = self.outletMapView
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25, execute: {
            let update = GMSCameraUpdate.fit(self.bounds, withPadding: 50)
            self.outletMapView.animate(with: update)
        })
        
        //Let's move to the nearest outlet if possible
        if(self.nearestOulet != nil){
            guard let lat = self.nearestOulet!.lat else{ return}
            guard let long = self.nearestOulet!.lon else{ return}
            let shopLatitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(lat)!)!
            let shopLongitude: CLLocationDegrees = CLLocationDegrees(exactly: Double(long)!)!
            let shopLocation = CLLocationCoordinate2DMake(shopLatitude, shopLongitude)
            self.cameraMoveToLocation(toLocation: shopLocation)
        }
        
        
    }
    
    func getCurrentLocation(){
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        if let coor = self.outletMapView.myLocation?.coordinate {
            self.cameraMoveToLocation(toLocation: coor)
        }
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            //self.outletMapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 4)
            self.outletMapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 10)
            
        }
    }
}

extension SelectedShopViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        guard let shopTitle = marker.title else {
            return
        }
        let selectedShopArray = allOutlets?.filter({ (shop) -> Bool in
            if shop.name == shopTitle{
                return true
            }
            return false
        })
        
        if(selectedShopArray?.count == 0){
            return
        }
        
        let outlet : Outlet = (selectedShopArray?.first)!
        print("Selected outlet id is \(outlet.id!)")
        
        self.askPermissionToSaveOutletAndGoToItemsPage(outlet: outlet)
        
        
        
    }
    
    
}

extension SelectedShopViewController {
    @IBAction func closeRegistration(_ sender: Any) {
        self.registrationView.alpha = 0
        self.registrationView.isHidden = true
        UserDefaults.standard.set(false, forKey:  "registrationAlert")
        UserDefaults.standard.synchronize()
    }
    @IBAction func gotoRegistraton(_ sender: Any) {
        self.registrationView.alpha = 0
        self.registrationView.isHidden = true
        weak var UserRegViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as? RegisterViewController
        UserRegViewController?.fromWhere = "review"
        self.navigationController?.pushViewController(UserRegViewController!, animated: true)
    }
    
    func loginCheck() {
        btnOk.layer.cornerRadius = 7
        btnOk.layer.borderWidth = 1
        btnOk.layer.borderColor = UIColor.white.cgColor
        if Common.instance.isUserLogin() {
            self.registrationView.alpha = 0
            self.registrationView.isHidden = true
        } else {
            if (UserDefaults.standard.value(forKey: "registrationAlert") as? Bool) ?? true == true {
                self.registrationView.alpha = 1
                self.registrationView.isHidden = false
            } else {
                self.registrationView.alpha = 0
                self.registrationView.isHidden = true
            }
        }
        
    }
    @objc func loadSearchPopUpView(_ sender: UIBarButtonItem) {
        //print("Opening search popup.")
        
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier:"SearchPopUpID") as! SearchPopUpViewController
        self.addChild(popOverVC)
        popOverVC.searchDelegate = self
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
}


//MARK: Collection View Delegates and Data source
extension SelectedShopViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isFeatured {
            let featureSubCategories = self.featuredCategoryArray?[collectionView.tag].subcategories
            return featureSubCategories?.count ?? 0
        }else if collectionView == categoriesCollectionView{
            //            if levelIndex == 0{
            return cats.count
            //            }else if levelIndex == 1{
            //                //print("sub cat : ",subCategories.count)
            //                return subCategories.count // self.itemCount
            //            }else{
            //                return items.count
            //            }
        }else {
            //print("SelectedShopViewController ",cats.count)
            if levelIndex == 0{
                return cats.count
            }else if levelIndex == 1{
                //print("sub cat : ",subCategories.count)
                return subCategories.count // self.itemCount
            }else{
                return items.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCell", for: indexPath) as? CategoryTabCell else {
                return UICollectionViewCell()
            }
            if indexPath.row == selectedCategoryIndex && levelIndex > 0{
                cell.isSelected = true
            }
            if indexPath.item < cats.count{
                let cat = cats[indexPath.item]
                cell.catName.text = cat.name
            }
            
            cell.backgroundColor = .clear
            return cell
        }else if collectionView == subCategoryCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryRow", for: indexPath) as? CategoryRow else {
                return UICollectionViewCell()}
            cell.tag = indexPath.row
            
            cell.categoryBottomConstraint.constant = 12
            if levelIndex == 0{
                let cat = cats[indexPath.row]
                //print("cell subcat", cat.name)
                cell.subitemName.text = cat.name
                //                cell.subitemDesc.text = cat.desc
                cell.isItem = false
                
                let backgroundName =  cat.imageURL as String
                let imageURL = configs.imageUrl + backgroundName
                //                //print("imageURL: ", imageURL)
                
                //                cell.subitemImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                //                    if(status == STATUS.success) {
                //                        //print(url + " is loaded successfully.")
                //
                //                    }else {
                //                        //print("Error in loading image" + msg)
                //                    }
                //                }
                cell.subitemImage.kf.setImage(with: URL(string: imageURL), placeholder: nil, options: .none, progressBlock: .none)
                /*
                 cell.subitemImage.kf.setImage(with: URL(string: imageURL),
                 options: [
                 .transition(.fade(0.3)),
                 .forceTransition,
                 .keepCurrentImageWhileLoading
                 ]
                 )
                 */
                
                
            }else if levelIndex == 1{
                //                //print("indx ; ",subCategories, indexPath.row)
                let subCat = subCategories[indexPath.row]
                cell.subitemName.text = subCat.name
                //                cell.subitemDesc.text = subCat.description
                cell.subCategoryId = subCat.id
                cell.subCategoryName = subCat.name
                
                cell.isItem = false
                //print("cell subcat", subCat.name)
                //print("description : ",subCat.description)
                let backgroundName =  subCat.imageURL as String
                let imageURL = configs.imageUrl + backgroundName
                //                //print("imageURL: ", imageURL)
                //                cell.subitemImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                //                    if(status == STATUS.success) {
                //                        //print(url + " is loaded successfully.")
                //
                //                    }else {
                //                        //print("Error in loading image" + msg)
                //                    }
                //                }
                cell.subitemImage.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"), options: .none, progressBlock: .none)
                
                //            if  (indexPath.row >= 0 && indexPath.row <= self.subCategories.count - 1) {
            } else {
                cell.isItem = true
                //                let row = indexPath.item - self.subCategories.count
                let itemCat = self.items[indexPath.row]
                //print(itemCat.itemName)
                cell.subitemName.text = itemCat.itemName
                //                cell.subitemDesc.text = itemCat.itemDesc
                cell.likeCount.text = "\(itemCat.itemLikeCount)"
                cell.messageCount.text = "\(itemCat.itemReviewCount)"
                
                let backgroundName =  itemCat.itemImage as String
                let imageURL = configs.imageUrl + backgroundName
                
                //                cell.subitemImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                //                    if(status == STATUS.success) {
                //                        //print(url + " is loaded successfully.")
                //
                //                    }else {
                //                        //print("Error in loading image" + msg)
                //                    }
                //                }
                cell.subitemImage.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"), options: .none, progressBlock: .none)
                
                cell.subitemPrice.text = itemCat.itemPrice + " " + settingsDetailModel!.currency_symbol!
                cell.subCategoryId = itemCat.itemId
                cell.subCategoryName = itemCat.itemName
                cell.categoryBottomConstraint.constant = 38
                
                if Double(itemCat.itemPrice)! < 1{
                    cell.subItemsStackView!.isHidden = true
                    cell.subitemPrice.isHidden = true
                    cell.basketButton.isHidden = true
                    cell.categoryBottomConstraint.constant = 10
                }
                
            }
            
            cell.backgroundColor = .clear
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionCell", for: indexPath) as! FeaturedCollectionCell
            
            let featuredModel = self.featuredCategoryArray?[collectionView.tag].subcategories?[indexPath.row]
            
            //            cell.itemImage.image = UIImage(named: "defaultImage")
            
            if let imageName = featuredModel?.path, imageName != "" {
                let imageURL = configs.imageUrl + imageName
                cell.itemImage.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"), options: .none, progressBlock: .none)
                
                //                cell.itemImage.imageWithURL(imageURL)
            }
            
            cell.itemName.text = featuredModel?.name
            cell.itemSub.text = featuredModel?.description
            
            cell.itemImage.layer.cornerRadius = 10
            
            cell.backgroundColor = .clear
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        self.openOrder()
        return
        
        if collectionView == subCategoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryRow
            
            if levelIndex == 0 {
                levelIndex = 1
                selectedCategoryIndex = indexPath.row
                //self.fetchSubItems(indexPath.row)
                //categoriesCollectionView.reloadData()
            }
            
            self.openOrder()
            
            
            /*else if levelIndex == 1{
             self.fetchSubItems(indexPath.row)
             self.performSegue(withIdentifier: "segueItems", sender: (cell.subCategoryName,cell.subCategoryId))
             } else {
             if cell.isItem {
             selectedItemIndex = indexPath.row
             self.fetchSubItems(indexPath.row)
             self.performSegue(withIdentifier: "segueItemDetail", sender: (cell.subCategoryName,cell.subCategoryId))
             } else {
             self.performSegue(withIdentifier: "segueItems", sender: (cell.subCategoryName,cell.subCategoryId))
             }
             }*/
        }else{
            if let _ = collectionView.cellForItem(at: indexPath) as? FeaturedCollectionCell {
                let featuredModel = self.featuredCategoryArray?[collectionView.tag].subcategories?[indexPath.row]
                self.performSegue(withIdentifier: "segueItemDetail", sender: (featuredModel?.subcategory_name,featuredModel?.subcategory_id?.description))
                return
            }
            
            if indexPath.row != 0 {
                if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CategoryTabCell {
                    if cell.isSelected {
                        cell.isSelected = false
                    }
                }
            }
            
            levelIndex = 1
            selectedCategoryIndex = indexPath.row
            self.fetchSubItems(indexPath.row)
            categoriesCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoriesCollectionView{
            let label = UILabel(frame: CGRect.zero)
            if indexPath.row < cats.count{
                label.text = cats[indexPath.row].name;
                label.font = UIFont(name: "NexaLight", size:18)
                label.sizeToFit()
            }
            return CGSize(width: label.frame.width + 16, height: collectionView.frame.height)
        }else if collectionView == subCategoryCollectionView{
            let width = ((self.view.frame.width - 30) / 2)
            //            //print("cell width : \(width)")
            return CGSize(width: width, height: width)
        }
        return CGSize(width: 121, height: 155)
    }
    
    func openOrder () {
    
        let cat = cats[selectedCategoryIndex]
        
        
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

extension Date {
   func isBetweenn(date date1: Date, andDate date2: Date) -> Bool {
       return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
   }
}

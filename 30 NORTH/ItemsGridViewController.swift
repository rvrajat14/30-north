//
//  CategoriesViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import AlamofireImage

@objc protocol RefreshLikeCountsDelegate: class {
    func updateLikeCounts(_ likeCount: Int)
}

@objc protocol RefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int)
}

@objc protocol RefreshBasketCountsDelegate: class {
    func updateBasketCounts(_ basketCount: Int)
}

@objc protocol SortDelegate: class {
    func sortMsg(_ msg:String)
    //func closePopup()
    @objc optional func returnCode(_ code:integer_t)
}

@objc protocol ItemsGridBasketCountUpdateDelegate: class {
    func updateBasketCount()
}

class ItemsGridViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SearchDelegate {
    
    var populationItems = false
    var selectedSubCategoryId:Int = 0
    
    var selectedShopId:Int = 1
    var selectedShopLat: String!
    var selectedShopLng: String!
    var selectedShopName: String!
    var selectedShopDesc: String!
    var selectedShopPhone: String!
    var selectedShopEmail: String!
    var selectedShopAddress: String!
    var selectedShopCoverImage: String!
    var selectedShopStripePublishableKey: String!
    var loginUserId: Int = 0
    var navTitle : String?
//    var selectedShopArrayIndex: Int!
    var items: [ItemModel]!
    var currentPage = 0
    var basketButton = MIBadgeButton()
    var selectedItemCurrencySymbol: String = ""
    var selectedItemCurrencyShortform: String = ""
    var selectedItemIndex = 0
    
    fileprivate weak var selectedCell : SubcategoryItemCell!
    weak var updateBasketCountsDelegate: UpdateBasketCountsDelegate!
    
    @IBOutlet weak var itemTableview: UITableView!
    @IBOutlet weak var cellBackgroundView: RoundedCornersView!
    
    var defaultValue: CGPoint!
    var sortField : String = "id"
    var sortType : String = "asc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        itemTableview.reloadData()
//        loadItemsBySubCategory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setupBasketButton()
        updateNavigationStuff()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 215
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! SubcategoryItemCell
                cell.selectionStyle = .none
                tableView.tableFooterView = UIView()
                let item = items[indexPath.row]
                cell.item = item //items![(indexPath as NSIndexPath).item]
                let imageURL = configs.imageUrl + item.itemImage
           //print("imageURL :: ",imageURL)
//                cell.subitemImage?.loadImage(urlString: imageURL) {  (status, url, image, msg) in
//                    if(status == STATUS.success) {
//                        //print(url + " is loaded successfully.")
//    //                    self.items![indexPath.item].itemImageBlob = image
//                    }else {
//                        //print("Error in loading image" + msg)
//                    }
//                }
        
        cell.subitemImage.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"), options: .none, progressBlock: .none)

                
//        Alamofire.request(imageURL).responseImage { response in
//            if case .success(let image) = response.result {
//                cell.subitemImage.image = image
//            }else{
//                cell.subitemImage.image = UIImage(named: "placeholder_image")
//            }
//        }

        
                cell.bodyView.isHidden = true
                cell.acidityView.isHidden = true
                cell.aromaView.isHidden = true
                cell.tasteView.isHidden = true
                cell.profileView.isHidden = true
                
                let body = item.body
                if body.count > 0{
                    cell.bodyView.isHidden = false
                    cell.bodyLabel.text = item.body
                }
                
                let acidity = item.acidity
                if acidity.count > 0{
                    cell.acidityView.isHidden = false
                    cell.acidityLabel.text = item.acidity
                }
                    
                let aroma = item.aroma
                if aroma.count > 0{
                    cell.aromaView.isHidden = false
                    cell.aromaLabel.text = item.aroma
                }
             
                let taste = item.taste
                if taste.count > 0{
                    cell.tasteView.isHidden = false
                    cell.tasteLabel.text = item.taste
                }
                        
                let profile = item.profile
                if profile.count > 0{
                    cell.profileView.isHidden = false
                    cell.profileLabel.text = item.profile
                }
                
                let priceNote = item.price_note
                let price = item.itemPrice
                if Double(price)! > 0{
                    cell.subitemPrice.isHidden = false
                    cell.subitemPrice.text = price + " \(self.selectedItemCurrencySymbol) \(priceNote)"
                }else{
                    cell.subitemPrice.isHidden = true
                    cell.subitemPrice.text = "0 \(self.selectedItemCurrencySymbol) \(priceNote)"
                }
                
                cell.subitemImage.alpha = 1.0
                cell.subitemName.alpha = 1.0
                return cell
            }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItemIndex = indexPath.row
//        itemDetail = items[selectedItemIndex]
//        let itemDetailVC = self.storyboard?.instantiateViewController(identifier: "ItemDetail") as! ItemDetailViewController
//        self.navigationController?.pushViewController(itemDetailVC, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "ItemDetail", sender: cell)
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    //        loadItemsBySubCategory()
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetail" {
            weak var itemCell = sender as? SubcategoryItemCell
            weak var itemDetailPage = segue.destination as? ItemDetailViewController
            itemDetailPage!.selectedItemId = Int((itemCell!.item?.itemId)!)!
            itemDetailPage!.navTitle = itemCell?.item?.itemName ?? language.itemDetailPageTitle
//            itemDetailPage!.selectedShopId = selectedShopId
            itemDetailPage!.selectedShopName = selectedShopName
            itemDetailPage!.selectedShopDesc = selectedShopDesc
            itemDetailPage!.selectedShopPhone = selectedShopPhone
            itemDetailPage!.selectedShopEmail = selectedShopEmail
            itemDetailPage!.selectedShopAddress = selectedShopAddress
            itemDetailPage!.selectedShopLat = selectedShopLat
            itemDetailPage!.selectedShopLng = selectedShopLng
            itemDetailPage!.selectedShopCoverImage = selectedShopCoverImage
            itemDetailPage!.selectedSubCategoryId = selectedSubCategoryId
//            itemDetailPage!.selectedShopArrayIndex = selectedShopArrayIndex
            itemDetailPage!.refreshLikeCountsDelegate = self
            itemDetailPage!.refreshReviewCountsDelegate = self
            itemDetailPage!.refreshBasketCountsDelegate = self
//            itemDetailPage!.items = items[selectedItemIndex]
             itemDetail = items[selectedItemIndex]
           //print("items :: ",items)
            itemDetail = items[selectedItemIndex]
            
            selectedCell = itemCell
            updateBackButton()
        }
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    
    
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = self.navTitle ?? language.itemsPageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]

        let btnBack = UIButton()
        btnBack.setTitle(" Back", for: .normal)
        btnBack.setImage(UIImage(named: "Back"), for: UIControl.State())
        btnBack.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btnBack.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnBack.addTarget(self, action: #selector(self.navigateToBack), for: .touchUpInside)
        let itemBack = UIBarButtonItem()
        itemBack.customView = btnBack
        self.navigationItem.leftBarButtonItem = itemBack
    }
    
    @objc func navigateToBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    func loadItemsBySubCategory() {
        
        if self.currentPage == 0 {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
        }
        Alamofire.request(APIRouters.AllItemsBySubCategory(1, selectedSubCategoryId)).responseCollection {
            (response: DataResponse<[Item]>) in
            
            if self.currentPage == 0 {
                _ = EZLoadingActivity.hide()
            }
            if response.result.isSuccess {
                if let items: [Item] = response.result.value {
                    if(items.count > 0) {
                        for item in items {
                            let oneItem = ItemModel(item: item)
                            self.items.append(oneItem)
                            self.currentPage+=1
                            
                        }
                    }
                }
                
                self.itemTableview!.reloadData()
                
            } else {
                
               //print(response)
            }
        }
        
    }*/
    
    func setupBasketButton() {
        let btnSearch = UIButton()
        btnSearch.setImage(UIImage(named: "Search-White"), for: UIControl.State())
        btnSearch.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnSearch.addTarget(self, action: #selector(ItemsGridViewController.loadSearchPopUpView(_:)), for: .touchUpInside)
        let itemSearch = UIBarButtonItem()
        itemSearch.customView = btnSearch
        
        if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {
            
            basketButton.badgeString = String(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)
            basketButton.badgeTextColor = UIColor.black
            basketButton.badgeBackgroundColor = UIColor.white
            basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 35, bottom: 0, right: 10)
            basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            basketButton.setImage(UIImage(named: "bag-1"), for: UIControl.State())
            
            
            basketButton.addTarget(self, action: #selector(ItemsGridViewController.loadBasketViewController(_:)), for: UIControl.Event.touchUpInside)
            
            let itemNaviBasket = UIBarButtonItem()
            itemNaviBasket.customView = basketButton
            self.navigationItem.rightBarButtonItems = [itemNaviBasket, itemSearch]
            
        }
        else {
            self.navigationItem.rightBarButtonItems = [itemSearch]
        }
    }
    
    @objc func loadSearchPopUpView(_ sender: UIBarButtonItem) {
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier:"SearchPopUpID") as! SearchPopUpViewController
        self.addChild(popOverVC)
        popOverVC.searchDelegate = self
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    internal func closePopup() {
    }
    @objc func loadBasketViewController(_ sender:UIButton) {
        
        if(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count > 0) {
            
            weak var BasketManagementViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Basket") as? BasketViewController
            BasketManagementViewController?.title = "Basket"
//            BasketManagementViewController?.selectedItemCurrencySymbol = selectedItemCurrencySymbol
//            BasketManagementViewController?.selectedShopArrayIndex = selectedShopArrayIndex
//            BasketManagementViewController?.selectedItemCurrencyShortForm = selectedItemCurrencyShortform
//            BasketManagementViewController?.selectedShopId = selectedShopId
            BasketManagementViewController?.loginUserId = loginUserId
            BasketManagementViewController?.itemsGridBasketCountUpdateDelegate = self
            BasketManagementViewController?.fromWhere = "grid"
            
            self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
            updateBackButton()
            
        } else {
            _ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.customImag(imageFile: "Logo"))
        }
        
    }
    
    func animateCollectionView() {
        
        moveOffScreen()
        
            self.itemTableview?.frame.origin = self.defaultValue
        
    }
    
    fileprivate func moveOffScreen() {
        itemTableview?.frame.origin = CGPoint(x: (itemTableview?.frame.origin.x)!,
                                              y: (itemTableview?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
    internal func sortMsg(_ msg: String) {
        if(msg == "Sort By Name Asc") {
            sortField = "name"
            sortType  = "asc"
        } else if (msg == "Sort By Name Desc") {
            sortField = "name"
            sortType  = "desc"
        } else if (msg == "Sort By Added Date Asc") {
            sortField = "added"
            sortType  = "asc"
        } else if (msg == "Sort By Added Date Desc") {
            sortField = "added"
            sortType  = "desc"
        } else if(msg == "Sort By Like Count Asc") {
            sortField = "like_count"
            sortType  = "asc"
        } else if(msg == "Sort By Like Count Desc") {
            sortField = "like_count"
            sortType  = "desc"
        }
        
//        self.currentPage = 0
//        self.items.removeAll()
//        self.itemTableview!.reloadData()
//        loadItemsBySubCategory()
//        self.itemTableview?.resetScrollPositionToTop()
    }
    
}

extension UIScrollView {
    /// Sets content offset to the top.
    func resetScrollPositionToTop() {
        self.contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
    }
}

extension ItemsGridViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        
        let item = items[(indexPath as NSIndexPath).item]
        
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        
        let size = CGSize(width: item.itemImageWidth, height: item.itemImageHeight)
        var rect : CGRect
        if item.itemImageBlob != nil {
            rect  = AVMakeRect(aspectRatio: item.itemImageBlob!.size, insideRect: boundingRect)
        }else{
            rect  = AVMakeRect(aspectRatio: size, insideRect: boundingRect)
            
        }
        
        return rect.size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        let height = annotationPadding + annotationHeaderHeight + annotationPadding + 30
        return height
    }
    
    func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
        
    }
    
    
}



extension ItemsGridViewController : RefreshLikeCountsDelegate, RefreshReviewCountsDelegate, RefreshBasketCountsDelegate {
    func updateLikeCounts(_ likeCount: Int) {
        if selectedCell != nil {
            selectedCell.likeCount.text = "\(likeCount)"
        }
    }
    
    func updateReviewCounts(_ reviewCount: Int) {
        if selectedCell != nil {
            selectedCell.reviewCount.text = "\(reviewCount)"
        }
    }
    
    func updateBasketCounts(_ basketCount: Int) {
        basketButton.badgeString = String(basketCount)
        basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
        
        self.updateBasketCountsDelegate?.updateBasketCount(basketCount)
    }
}

extension ItemsGridViewController: ItemsGridBasketCountUpdateDelegate {
    func updateBasketCount() {
        basketCountUpdate(BasketTable.getByShopIdAndUserId(String(selectedShopId), loginUserId: String(loginUserId)).count)
    }
}




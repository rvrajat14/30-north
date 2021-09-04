//
//  SearchResult.swift
//  Restaurateur
//
//  Created by Panacea-soft on 26/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

@objc protocol SearchRefreshLikeCountsDelegate: class {
    func updateLikeCounts(_ likeCount: Int)
}

@objc protocol SearchRefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int)
}

class SearchResultViewController : UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var itemTableview: UITableView!

    var populationItems = false
    var selectedSubCategoryId:Int = 0
    var selectedCityId:Int = 1
    var items = [ItemModel]()
    var currentPage = 0
    var searchKeyword: String!
    weak var selectedCellSearch : SubcategoryItemCell!
    var basketButton = MIBadgeButton()
    var loginUserId: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        searchItemsByKeyword()
        loadLoginUserId()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchItemsByKeyword()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupBasketButton()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        weak var itemCell = sender as? SubcategoryItemCell
        weak var itemDetailPage = segue.destination as? ItemDetailViewController
        itemDetailPage!.selectedItemId = Int((itemCell!.item?.itemId)!)!
//        itemDetailPage!.selectedShopId = Int((itemCell!.item?.itemShopId)!)!
        itemDetailPage!.searchRefreshLikeCountsDelegate = self
        itemDetailPage!.searchRefreshReviewCountsDelegate = self
        selectedCellSearch = itemCell
        updateBackButton()
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubcategoryItemCell
        cell.selectionStyle = .none
        cell.item = items[indexPath.row]
        let imageURL = configs.imageUrl + items[indexPath.row].itemImage
        cell.subitemPrice.text = items[indexPath.row].currency + items[indexPath.row].itemPrice
        cell.subitemImage?.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
                //print(url + " is loaded successfully.")
                self.items[indexPath.row].itemImageBlob = image
            }else {
                //print("Error in loading image" + msg)
            }
        }
            cell.subitemImage.alpha    = 1.0
            cell.subitemName.alpha = 1.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "segueItemDetail", sender: cell)
    }
    
    func searchItemsByKeyword() {
        
        let params: [String: AnyObject] = [
            "keyword"   : searchKeyword as AnyObject
        ]
        
        if self.currentPage == 0 {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
        }
        Alamofire.request(APIRouters.SearchByID(selectedCityId, params)).responseCollection {
            (response: DataResponse<[Item]>) in
            
            if self.currentPage == 0 {
                _ = EZLoadingActivity.hide()
            }
            if response.result.isSuccess {
                if let items: [Item] = response.result.value {
                    
                    if(items.count > 1) {
                        self.title = String(items.count) + " Results Found"
                    } else if (items.count == 1) {
                        self.title = String(items.count) + " Result Found"
                    }else {
                        self.title = "0 Result Found"
                    }
                    //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
                    
                    if(items.count > 0) {
                        self.items.removeAll()
                        for item in items {
                            let oneItem = ItemModel(item: item)
                            self.items.append(oneItem)
                            self.currentPage += 1
                            
                        }
                    }
                }else {
                    self.title = "0 Result Found"
                }
                
                self.itemTableview!.reloadData()
                
            } else {
                self.title = "0 Result Found"
               //print(response)
            }
        }
        
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
}


extension SearchResultViewController : PinterestLayoutDelegate {
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
}

extension SearchResultViewController : SearchRefreshLikeCountsDelegate, SearchRefreshReviewCountsDelegate {
    func updateLikeCounts(_ likeCount: Int) {
       //print("updateLikeCounts")
        if selectedCellSearch != nil {
           //print("update like count inside")
            selectedCellSearch.likeCount.text = "\(likeCount)"
        }
    }
    
    func updateReviewCounts(_ reviewCount: Int) {
        if selectedCellSearch != nil {
            selectedCellSearch.reviewCount.text = "\(reviewCount)"
        }
    }
    func setupBasketButton() {
        let btnSearch = UIButton()
        btnSearch.setImage(UIImage(named: "Search-White"), for: UIControl.State())
        btnSearch.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnSearch.addTarget(self, action: #selector(ItemsGridViewController.loadSearchPopUpView(_:)), for: .touchUpInside)
        let itemSearch = UIBarButtonItem()
        itemSearch.customView = btnSearch
        
        if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {
            basketButton = MIBadgeButton()
            basketButton.badgeString = String(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)
            basketButton.badgeTextColor = UIColor.black
            basketButton.badgeBackgroundColor = UIColor.white
            basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 35, bottom: 0, right: 10)
            basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            basketButton.setImage(UIImage(named: "bag-1"), for: UIControl.State())
            
            
            basketButton.addTarget(self, action: #selector(SearchResultViewController.loadBasketViewController(_:)), for: UIControl.Event.touchUpInside)
            
            let itemNaviBasket = UIBarButtonItem()
            itemNaviBasket.customView = basketButton
            self.navigationItem.rightBarButtonItems = [itemNaviBasket, itemSearch]
            
            
            
        }
        else {
            self.navigationItem.rightBarButtonItems = [itemSearch]
        }
    }
    @objc func loadBasketViewController(_ sender:UIButton) {
        
      if(BasketTable.getByShopIdAndUserId(String("1"), loginUserId: String(loginUserId)).count > 0) {
                
                weak var BasketManagementViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Basket") as? BasketViewController
                BasketManagementViewController?.title = "Basket"
//                BasketManagementViewController?.selectedShopArrayIndex = 0
//                BasketManagementViewController?.selectedShopId = 1
                BasketManagementViewController?.loginUserId = loginUserId
                BasketManagementViewController?.itemsGridBasketCountUpdateDelegate = self
                BasketManagementViewController?.fromWhere = "grid"
                self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
                //updateBackButton()
                
            } else {
                _ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.customImag(imageFile: "Logo"))
            }
        
    }
    
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {

            loginUserId = Common.instance.getLoginUserId(dict: dict)
            
        } else {
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
}
extension SearchResultViewController: ItemsGridBasketCountUpdateDelegate {
    func updateBasketCount() {
        basketCountUpdate(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)
    }
    
    func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
        
    }
}









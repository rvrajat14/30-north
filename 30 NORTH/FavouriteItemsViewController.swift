//
//  FavouriteItemsViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 24/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import XLPagerTabStrip

@objc protocol FavRefreshLikeCountsDelegate: class {
    func updateLikeCounts(_ likeCount: Int)
}

@objc protocol FavRefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int)
}

class FavouriteItemsViewController: UICollectionViewController {
    
    var itemInfo: IndicatorInfo = "FAVORITES"

    @IBOutlet var favouriteCollectionView: UICollectionView!
    var populationItems = false
    var selectedSubCategoryId:Int = 0
    var selectedCityId:Int = 1
    var selectedCityLat: String!
    var selectedCityLng: String!
    var items = [ItemModel]()
    var currentPage = 0
    var loginUserId:Int = 0
    weak var selectedCell : AnnotatedPhotoCell!
    var defaultValue: CGPoint!
    // var carbonNavigation : CarbonTabSwipeNavigation?

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
//        }
        
        favouriteCollectionView!.register(AnnotatedPhotoCell.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "AnnotatedPhotoCell")
        
//        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
//            layout.delegate = self
//        }
        loadLoginUserId()
        loadFavouriteItems()
        
//        defaultValue = collectionView?.frame.origin
//        animateCollectionView()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 120)
        favouriteCollectionView.collectionViewLayout = layout
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        loadFavouriteItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        weak var itemCell = sender as? AnnotatedPhotoCell
        weak var itemDetailPage = segue.destination as? ItemDetailViewController
        itemDetailPage!.selectedItemId = Int((itemCell!.item?.itemId)!)!
//        itemDetailPage!.selectedShopId = Int((itemCell!.item?.itemShopId)!)!
        itemDetailPage!.selectedSubCategoryId = selectedSubCategoryId
        itemDetailPage!.favRefreshLikeCountsDelegate = self
        itemDetailPage!.favRefreshReviewCountsDelegate = self
        selectedCell = itemCell
        updateBackButton()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : AnnotatedPhotoCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
        cell.item = items[(indexPath as NSIndexPath).item]
        
        let imageURL = configs.imageUrl + items[(indexPath as NSIndexPath).item].itemImage
        
        cell.imageView?.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
                self.items[indexPath.item].itemImageBlob = image
            }else {
               //print("Error in loading image" + msg)
            }
        }
        
        cell.imageView.layer.masksToBounds = true
        cell.imageView.layer.cornerRadius = 10
        
        cell.imageView.alpha = 0
        cell.captionLabel.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            cell.imageView.alpha = 1.0
            cell.captionLabel.alpha = 1.0
        }, completion: nil)
        
        return cell
    }
    
    internal static func instantiate(with  itemInfo: IndicatorInfo) -> CouponsViewController {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CouponsViewController") as! CouponsViewController
        vc.itemInfo = itemInfo
        return vc
    }
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.favouritePageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
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
    
    func loadFavouriteItems() {
        
        if self.currentPage == 0 {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
        }
        Alamofire.request(APIRouters.GetFavouriteItems( loginUserId, configs.pageSize, self.currentPage)).responseCollection {
            (response: DataResponse<[Item]>) in
            
            if self.currentPage == 0 {
                _ = EZLoadingActivity.hide()
            }
           //print(response.result)
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
                
               //print("items count: ",self.items.count)
                self.favouriteCollectionView.reloadData()
                
            } else {
               //print(response)
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

/*
extension FavouriteItemsViewController : PinterestLayoutDelegate {
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
*/

extension FavouriteItemsViewController : FavRefreshLikeCountsDelegate, FavRefreshReviewCountsDelegate {
    func updateLikeCounts(_ likeCount: Int) {
        if selectedCell != nil {
            selectedCell.lblLikeCount.text = "\(likeCount)"
        }
    }
    
    func updateReviewCounts(_ reviewCount: Int) {
        if selectedCell != nil {
            selectedCell.lblReviewCount.text = "\(reviewCount)"
        }
    }
}

extension FavouriteItemsViewController : IndicatorInfoProvider
{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

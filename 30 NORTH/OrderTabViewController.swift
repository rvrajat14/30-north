//
//  OrderTabViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 24/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import CenteredCollectionView
import Alamofire
import CarbonKit

class OrderTabViewController: UIViewController {

    
    @IBOutlet weak var dividerLineViewHeightConstraint: NSLayoutConstraint!
@IBOutlet weak var HeaderCollectionViewHeight: NSLayoutConstraint!
    
    weak var refreshBasketCountsDelegate: RefreshBasketCountsDelegate!
    weak var basketTotalAmountUpdateDelegate: BasketTotalAmountUpdateDelegate!

	let headerCellPercentWidth: CGFloat = 0.7

	var headerFlowLayout: CenteredCollectionViewFlowLayout!
	var shopModel : ShopModel? = nil
	var category:Categories!
    var basketButton = MIBadgeButton()
    var itemNavi = UIBarButtonItem()
	var subCategory:SubCategories?
    
    var isShowingOutletMenuItems : Bool = false
    var allItemsForSelectedOutlet : [ItemModel]?
    var selectedOutlet : Outlet?
    
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousIcon: UIImageView!
    @IBOutlet weak var nextIcon: UIImageView!

    @IBOutlet weak var catLabel: UILabel! {
        didSet {
            if(self.isShowingOutletMenuItems == false){
            catLabel.text = self.category.name
            }
            catLabel.numberOfLines = 0
            catLabel.textColor = UIColor.gold
            catLabel.backgroundColor = UIColor.clear
            catLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
    }
    
    
	@IBOutlet weak var popupMainView: UIView!{
		didSet {
			popupMainView.isHidden = true
			popupMainView.backgroundColor = UIColor.clear
			popupMainView.clipsToBounds = true
		}
	}

	@IBOutlet weak var popupView: UIView!{
		didSet {
			popupView.isHidden = false
			popupView.layer.cornerRadius = CGFloat(8)
			popupView.layer.borderWidth = 1
			popupView.layer.borderColor = UIColor.black.cgColor
			popupView.clipsToBounds = true
		}
	}
    
    @IBOutlet weak var outletNameLabel: UILabel!{
        didSet {
        }
    }
    
	@IBOutlet weak var titleLabel: UILabel!{
		didSet {
			titleLabel.text = "Choose"
			titleLabel.font = UIFont(name: AppFontName.bold, size: 17)!
			titleLabel.textAlignment = .center
		}
	}
	@IBOutlet weak var tableView: UITableView!{
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
			tableView.rowHeight = 50
		}
	}
	
	@IBOutlet weak var scrollView: UIScrollView! {
		didSet {
			scrollView.backgroundColor = UIColor.clear
		}
	}

	@IBOutlet weak var contentView: UIView!{
		didSet {
			contentView.backgroundColor = UIColor.clear
		}
	}

	@IBOutlet weak var collectionView: UICollectionView!{
		didSet {
			collectionView.delegate = self
			collectionView.dataSource = self
			collectionView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var itemTableView: UITableView!{
		didSet {
			itemTableView.delegate = self
			itemTableView.dataSource = self
			itemTableView.backgroundColor = .clear
			itemTableView.estimatedRowHeight = 90
		}
	}

	func updateBackButton() {
	   let backItem = UIBarButtonItem()
	   backItem.title = ""
	   navigationItem.backBarButtonItem = backItem
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        self.updateBackButton()
        // Do any additional setup after loading the view.
		configureView()
		//loadShopData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.isShowingOutletMenuItems == true){
                  self.showCartButton()
                  self.nextIcon.isHidden = true
                  self.nextButton.isHidden = true
                  self.previousBtn.isHidden = true
                  self.previousIcon.isHidden = true
                  self.catLabel.isHidden = true
                  self.outletNameLabel.isHidden = false
                  self.outletNameLabel.text = self.selectedOutlet?.name
                  self.outletNameLabel.adjustsFontSizeToFitWidth = true
                  catLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                  self.dividerLineViewHeightConstraint.constant = 0
                  self.HeaderCollectionViewHeight.constant = -(0.2 * UIScreen.main.bounds.size.height) + 60
              }else{
                  self.nextIcon.isHidden = false
                  self.nextButton.isHidden = false
                  self.previousBtn.isHidden = false
                  self.previousIcon.isHidden = false
                  self.outletNameLabel.isHidden = true
                  self.catLabel.isHidden = false
                  self.dividerLineViewHeightConstraint.constant = 15
              }
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        
        if(self.isShowingOutletMenuItems == false){
            let searchButton = UIBarButtonItem.menuButton(self, action: #selector(showPopupView), imageName: "filterFunnel")
            self.showCartButton(button: searchButton)
        }else{
            self.showCartButton()
        }
        
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
        if(self.isShowingOutletMenuItems == false){
            headerCollectionFlowLayout()
        }
	}
	func configureView() {
        if(self.isShowingOutletMenuItems == false){
		headerCollectionFlowLayout()
        }
	}

	func headerCollectionFlowLayout() {
		if let flowLayout = self.collectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout {
			self.headerFlowLayout = flowLayout
			headerFlowLayout.itemSize = CGSize(
				width: view.bounds.width * headerCellPercentWidth,
				height: collectionView.bounds.height
			)
			// Configure the optional inter item spacing (OPTIONAL STEP)
			headerFlowLayout.minimumLineSpacing = 55
			// Get rid of scrolling indicators
			collectionView.showsVerticalScrollIndicator = false
			collectionView.showsHorizontalScrollIndicator = false
			collectionView.decelerationRate = .fast
		}
	}

	@IBAction func nextItemAction(_ sender: UIButton) {
		guard let currentCenteredPage = headerFlowLayout.currentCenteredPage, currentCenteredPage < self.category.subCategory.count-1 else {
			return
		}
		headerFlowLayout.scrollToPage(index: currentCenteredPage + 1, animated: true)
	}

	@IBAction func previousItemAction(_ sender: UIButton) {
		guard let currentCenteredPage = headerFlowLayout.currentCenteredPage, currentCenteredPage > 0 else {
			return
		}
		headerFlowLayout.scrollToPage(index: currentCenteredPage - 1, animated: true)
	}

	func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
    }

	func loadSearchData() {

		let currentCenteredPage = headerFlowLayout.currentCenteredPage
		let subCat = self.category.subCategory[currentCenteredPage!]
		self.subCategory = subCat
	}

	@objc func showPopupView() {
		self.loadSearchData()
		guard let count = self.subCategory?.items.count else {
			return
		}
        popupMainView.isHidden = false
		self.view.bringSubviewToFront(popupMainView)
		let heightConstraint = self.popupView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "PopupViewHeightConstraint"
		}
        if count > 3 {
			heightConstraint?.constant = CGFloat(4 * 60) + 100
        }else{
			heightConstraint?.constant = CGFloat(count * 60) + 100
        }
		tableView.reloadData()

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

	func itemIndex() -> Int {
		let visibleCells = self.itemTableView.indexPathsForVisibleRows
		guard let itemIndex = visibleCells?.first else {
			return 0
		}
		return itemIndex.item
	}

	func showOtherDetails(cell:ItemCell, item:ItemModel) {
		//Show other details if availabel
		var index = 0
		if item.aroma.count > 0  {
			cell.leftIconView[index].image = UIImage(named: "aroma")
			cell.leftLabel[index].text = item.aroma
		}
		if item.acidity.count > 0  {
			cell.rightIconView[index].image = UIImage(named: "acidity")
			cell.rightLabel[index].text = item.acidity

			index += 1
		}
		if item.taste.count > 0  {
			cell.leftIconView[index].image = UIImage(named: "taste")
			cell.leftLabel[index].text = item.taste
		}
		if item.body.count > 0  {
			cell.rightIconView[index].image = UIImage(named: "body")
			cell.rightLabel[index].text = item.body

			index += 1
		}
		if item.profile.count > 0  {
			cell.leftIconView[index].image = UIImage(named: "profile")
			cell.leftLabel[index].text = item.profile
		}

		let rowHeight:CGFloat = 40
		if index == 0 {
			let leftViewHeightConstraint = cell.leftView.constraints.first(where: { (constraint) -> Bool in
				return constraint.identifier == "LeftViewHeightConstraint"
			})
			leftViewHeightConstraint?.constant = 0

			let rightViewHeightConstraint = cell.rightView.constraints.first(where: { (constraint) -> Bool in
				return constraint.identifier == "RightViewHeightConstraint"
			})
			rightViewHeightConstraint?.constant = 0
		} else {
			let leftViewHeightConstraint = cell.leftView.constraints.first(where: { (constraint) -> Bool in
				return constraint.identifier == "LeftViewHeightConstraint"
			})
			leftViewHeightConstraint?.constant = rowHeight * CGFloat(index)

			let rightViewHeightConstraint = cell.rightView.constraints.first(where: { (constraint) -> Bool in
				return constraint.identifier == "RightViewHeightConstraint"
			})
			rightViewHeightConstraint?.constant = rowHeight * CGFloat(index)
		}
	}
}

extension OrderTabViewController : UICollectionViewDelegate, UICollectionViewDataSource {

	func configureHeaderCell(collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderHeaderCell", for: indexPath) as? OrderHeaderCell

		let subcat = self.category.subCategory[indexPath.row]
        cell?.categoryLabel.text = self.category.name

		let imageName =  subcat.imageURL as String
		let imageURL = configs.imageUrl + imageName
		cell?.imageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"), options: .none, progressBlock: .none)

		cell?.backgroundColor = .clear
		return cell!
	}

	func configureItemCell(tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell
		
        
        let item : ItemModel?
        if(self.isShowingOutletMenuItems == true){
            item = self.allItemsForSelectedOutlet![indexPath.row]
        }else{
            guard let currentCenteredPage = headerFlowLayout.currentCenteredPage else {
                return cell!
                }
            let subcat = self.category.subCategory[currentCenteredPage]
            item = subcat.items[indexPath.row]
        }

        cell?.nameLabel.text = item?.itemName
        cell?.priceLabel.text = ""
        
        if let discountName : String = item?.discountName, discountName.count > 0 {
            cell?.discountNameLabel.text = discountName
        }else{
            cell?.discountNameLabel.text = ""
        }

        if let price = Int(item!.itemPrice), price > 0 {
            let attrString = NSMutableAttributedString(string: "\(self.shopModel?.currencyShortForm ?? "") \(item!.itemPrice)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.white]);
            attrString.append(NSMutableAttributedString(string: " \(item!.price_note)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.white]));
			cell?.priceLabel.attributedText = attrString
		} else {
			cell?.priceLabel.attributedText = NSAttributedString(string: "")
		}

		var description = ""
        if item!.itemDesc.count > 0 {
            description += "\(item!.itemDesc)"
		}
		cell?.descLabel.text = description
        self.showOtherDetails(cell:cell!, item: item!)

        let imageName =  item!.itemImage as String
		let imageURL = configs.imageUrl + imageName
		cell?.itemImageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"), options: .none, progressBlock: .none)
		let imageViewHeightConstraint = cell?.itemImageView.constraints.first(where: { (constraint) -> Bool in
			return constraint.identifier == "ImageViewHeightConstraint"
		})
		imageViewHeightConstraint?.constant = 200

		cell?.selectionStyle = .none
		cell?.backgroundColor = .clear
		return cell!
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(self.isShowingOutletMenuItems == true){
            return 0
        }
        
		return self.category.subCategory.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return self.configureHeaderCell(collectionView:collectionView, indexPath:indexPath)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let currentCenteredPage = headerFlowLayout.currentCenteredPage
		if currentCenteredPage != indexPath.row {
			headerFlowLayout.scrollToPage(index: indexPath.row, animated: true)
		}
		itemTableView.reloadData()
	}
	
}

extension OrderTabViewController {

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		self.popupMainView.isHidden = true
	}
}

extension OrderTabViewController {

	func openItemDetail(subcat:SubCategories , item:ItemModel) {
		let itemDetailPage = self.storyboard?.instantiateViewController(identifier: "ItemDetail") as? ItemDetailViewController

		itemDetailPage!.selectedItemId = Int(item.itemId)!
		itemDetailPage!.navTitle = item.itemName ?? language.itemDetailPageTitle
		itemDetailPage!.selectedShopName = item.itemName
		itemDetailPage!.selectedShopDesc = self.shopModel?.name
		itemDetailPage!.selectedShopPhone = self.shopModel?.phone
			itemDetailPage!.selectedShopEmail = self.shopModel?.email
		itemDetailPage!.selectedShopAddress = self.shopModel?.address
		itemDetailPage!.selectedShopLat = self.shopModel?.lat
		itemDetailPage!.selectedShopLng = self.shopModel?.lng
		itemDetailPage!.selectedShopCoverImage = self.shopModel?.backgroundImage
		itemDetailPage!.selectedSubCategoryId = Int(subcat.catId) ?? 0

		itemDetail = item

		self.navigationController?.pushViewController(itemDetailPage!, animated: true)
	}
    
    
    func openItemDetailForAnOutlet(item:ItemModel) {
        let itemDetailPage = self.storyboard?.instantiateViewController(identifier: "ItemDetail") as? ItemDetailViewController

        itemDetailPage!.selectedItemId = Int(item.itemId)!
        itemDetailPage!.navTitle = item.itemName ?? language.itemDetailPageTitle
        itemDetailPage!.selectedShopName = item.itemName
        //Shop model does not matter as we are not using it in next page.
        itemDetailPage!.selectedShopDesc = self.shopModel?.name
        itemDetailPage!.selectedShopPhone = self.shopModel?.phone
        itemDetailPage!.selectedShopEmail = self.shopModel?.email
        itemDetailPage!.selectedShopAddress = self.shopModel?.address
        itemDetailPage!.selectedShopLat = self.shopModel?.lat
        itemDetailPage!.selectedShopLng = self.shopModel?.lng
        itemDetailPage!.selectedShopCoverImage = self.shopModel?.backgroundImage
        //We are not using it so just pass 0
        itemDetailPage!.selectedSubCategoryId = 0
        itemDetail = item
        self.navigationController?.pushViewController(itemDetailPage!, animated: true)
    }

    func checkItemInBasket() -> (Int64,Int64) {
        let headerIndex = headerFlowLayout.currentCenteredPage
        let subcat = self.category.subCategory[headerIndex!]
		let item = subcat.items[self.itemIndex()]
        let id = BasketTable.getByIdsAndAttrs(String(item.itemId), paramAttrIds:"")
        print("Existting item id =  \(id)")
        return id
    }

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.isShowingOutletMenuItems == true){
            return
        }
		if scrollView == collectionView && self.itemTableView != nil {
			self.itemTableView.reloadData()
			//Enable disable next previous button/icon
			guard let currentPage = headerFlowLayout.currentCenteredPage else {
				return
			}
			if self.category.subCategory.count == 1 {
				self.nextIcon.alpha = 0
				self.previousIcon.alpha = 0
			} else if currentPage == 0 {
				self.previousIcon.alpha = 0.3
				self.nextIcon.alpha = 1
			} else if currentPage == self.category.subCategory.count - 1 {
				self.nextIcon.alpha = 0.3
				self.previousIcon.alpha = 1
			} else {
				self.nextIcon.alpha = 1
				self.previousIcon.alpha = 1
			}
		}
	}


	@objc func loadBasketViewController(_ sender:UIButton) {
		let userID = self.isUserLoggedIn()
		if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(userID)).count > 0) {

			weak var BasketManagementViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Basket") as? BasketViewController
			BasketManagementViewController?.title = "Basket"
			if let currencySymbol = self.shopModel?.currencySymbol {
				BasketManagementViewController?.selectedItemCurrencySymbol = currencySymbol
			}
			if let currencyShortForm = self.shopModel?.currencyShortForm {
				BasketManagementViewController?.selectedItemCurrencyShortForm = currencyShortForm
			}
			BasketManagementViewController?.selectedShopId = 1
			BasketManagementViewController?.loginUserId = userID
			BasketManagementViewController?.fromWhere = "OredrTab"
			self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
		} else {
			_ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.customImag(imageFile: "Logo"))
		}
    }
}

extension OrderTabViewController : UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: self.view.bounds.size.width*0.05, bottom: 0, right: self.view.bounds.size.width*0.05)
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 55
    }
}

extension OrderTabViewController : UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard tableView != itemTableView else {
            
            if(self.isShowingOutletMenuItems == true){
                return self.allItemsForSelectedOutlet!.count
            }
            else{
			if self.category.subCategory.count > 0, let currentCenteredPage = headerFlowLayout.currentCenteredPage {
				let subCat = self.category.subCategory[currentCenteredPage]
				return subCat.items.count
			}
            }
			return 0
		}

		guard let data = self.subCategory else {
			return 0
		}
		return data.items.count
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard tableView != itemTableView else {
			return self.configureItemCell(tableView: tableView, indexPath: indexPath)
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSearchCell") as! OrderSearchCell
		guard let items = self.subCategory?.items else {
			return cell
		}
		let item = items[indexPath.row]
		cell.titleLabel.text = item.itemName
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard tableView != itemTableView else {
//			guard let headerIndex = headerFlowLayout.currentCenteredPage else {
//				return
//			}
//			let subcat = self.category.subCategory[headerIndex]
//			let item = subcat.items[indexPath.row]
//
//			self.openItemDetail(subcat: subcat, item: item)
//			return
            let item : ItemModel?
            if(self.isShowingOutletMenuItems == true){
                item = self.allItemsForSelectedOutlet![indexPath.row]
                self.openItemDetailForAnOutlet(item: item!)
            }else{
                guard let currentCenteredPage = headerFlowLayout.currentCenteredPage else {
                    return
                    }
                let subcat = self.category.subCategory[currentCenteredPage]
                item = subcat.items[indexPath.row]
                self.openItemDetail(subcat: subcat, item: item!)
            }
            return
		}
		self.popupMainView.isHidden = true
		guard let items = self.subCategory?.items else {
			return
		}
		let item = items[indexPath.row]
		self.showItem(selectedItem: item)
	}

	func showItem(selectedItem:ItemModel) {
		var index:Int?
		var subCat:SubCategories?
		for aSubCat in self.category.subCategory {
			let selectedIndex = aSubCat.items.firstIndex(where: { (item) -> Bool in
				return item.itemId == selectedItem.itemId
			})
			if let aIndex = selectedIndex {
				index = aIndex
				subCat = aSubCat
				break
			}
		}
		if let theSubCat = subCat {
			let subCatIndex = self.category.subCategory.firstIndex { (object) -> Bool in
				return object.id == theSubCat.id && object.catId == theSubCat.catId
			}
			if let headerIndex = subCatIndex {
				headerFlowLayout.scrollToPage(index: headerIndex, animated: false)
			}
            self.itemTableView.reloadData()
            if let itemIndex = index {
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.88) {
                    self.itemTableView.scrollToRow(at: IndexPath(item: itemIndex, section: 0), at: .top, animated: true)
                }
            }
		}
	}
}

extension OrderTabViewController: UserLoginDelegate {
    func updateLoginUserId(_ UserId: Int) {
        print("Login Done: \(UserId)")
    }
}

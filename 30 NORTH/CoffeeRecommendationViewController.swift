//
//  CoffeeRecommendationViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 29/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import CenteredCollectionView
import Alamofire
import CarbonKit
import SwiftUI

class CoffeeRecommendationViewController: UIViewController {

    weak var refreshBasketCountsDelegate: RefreshBasketCountsDelegate!
    weak var basketTotalAmountUpdateDelegate: BasketTotalAmountUpdateDelegate!

	
	let headerCellPercentWidth: CGFloat = 0.9
	let itemCellPercentWidth: CGFloat = 0.9

	var headerFlowLayout: CenteredCollectionViewFlowLayout!
	var itemFlowLayout: CenteredCollectionViewFlowLayout!

	var shopModel : ShopModel? = nil
	var items:[ItemModel]? = nil
	var selectedItems:[[String:Any]]!
	var selectedCupping:Cupping?
	var subscriptionType:String?

    var basketButton = MIBadgeButton()
    var itemNavi = UIBarButtonItem()

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

	@IBOutlet weak var topCollectionView: UICollectionView!{
		didSet {
			topCollectionView.delegate = self
			topCollectionView.dataSource = self
			topCollectionView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var itemCollectionView: UICollectionView!{
		didSet {
			itemCollectionView.delegate = self
			itemCollectionView.dataSource = self
			itemCollectionView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var itemDetailView: UIView!{
		didSet {
			itemDetailView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var productDetailLabel: UILabel!{
		didSet {
			productDetailLabel.text = "PRODUCT DETAILS"
			productDetailLabel.font = UIFont(name: AppFontName.bold, size: 16)
            productDetailLabel.textColor = UIColor.gold
		}
	}

	@IBOutlet weak var itemDescLabel: UILabel! {
		didSet {
			itemDescLabel.text = ""
			itemDescLabel.font = UIFont(name: AppFontName.regular, size: 14)
			itemDescLabel.textColor = .white
		}
	}

	@IBOutlet weak var otherDetailsView: UIView! {
		didSet {
			otherDetailsView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var customizeButton: UIButton! {
		didSet {
			customizeButton.layer.cornerRadius = 3.0
            customizeButton.backgroundColor = UIColor.gold
			customizeButton.clipsToBounds = true
			customizeButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 15)
			customizeButton.setTitle("CUSTOMIZE", for: .normal)
			customizeButton.setTitleColor(UIColor.white, for: .normal)
		}
	}

	@IBOutlet weak var addBasketButton: UIButton! {
		didSet {
			addBasketButton.layer.cornerRadius = 3.0
            addBasketButton.backgroundColor = UIColor.gold
			addBasketButton.clipsToBounds = true
			addBasketButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 15)
			addBasketButton.setTitle("ADD TO BASKET", for: .normal)
			addBasketButton.setTitleColor(UIColor.white, for: .normal)
		}
	}

	@IBOutlet weak var subscribeButton: UIButton!{
		didSet {
			subscribeButton.layer.cornerRadius = 3.0
            subscribeButton.backgroundColor = UIColor.gold
			subscribeButton.clipsToBounds = true
            subscribeButton.titleLabel?.font = UIFont(name: AppFontName.regular, size: 15)
			subscribeButton.setTitle("SUBSCRIBE", for: .normal)
			subscribeButton.setTitleColor(UIColor.white, for: .normal)
		}
	}

	private func updateNavigationStuff() {
	   self.navigationController?.navigationBar.topItem?.title = language.coffeeGuide
	}

	func updateBackButton() {
	   let backItem = UIBarButtonItem()
	   backItem.title = ""
	   navigationItem.backBarButtonItem = backItem
	}
   
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        // Do any additional setup after loading the view.
		configureView()
		//loadShopData()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.showCartButton()

		updateBackButton()
        updateNavigationStuff()

		headerCollectionFlowLayout()
		itemCollectionFlowLayout()
	}

    //Added custom back handling so that back button remains default.
    override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		guard let navController = self.navigationController else {
			return
		}
		let recommendationVC = navController.viewControllers.first(where: { (viewController) -> Bool in
			return viewController is CoffeeRecommendationViewController
		})
		if recommendationVC == nil {
			self.backAction(navController: navController)
		}
    }

	func configureView() {
		if subscriptionType != nil {
			self.subscribeButton.isHidden = false
			self.addBasketButton.isHidden = true
			self.customizeButton.isHidden = true
		} else {
			self.subscribeButton.isHidden = true
			self.addBasketButton.isHidden = false
			self.customizeButton.isHidden = false
		}
		let widthConstraint = self.productDetailLabel.constraints.first { (con) -> Bool in
			return con.identifier == "BottomViewWidthRatio"
		}
		widthConstraint?.constant = self.view.frame.width * itemCellPercentWidth
		loadShopData()
	}

	@objc func backAction(navController:UINavigationController) {

		/*let wheelVC = navController.viewControllers.first(where: { (viewController) -> Bool in
			return viewController is UIHostingController<RootView>
		})
		if let viewController = wheelVC {
			navController.popToViewController(viewController, animated: false)
		} else {*/
			let snackVC = navController.viewControllers.first(where: { (viewController) -> Bool in
				return viewController is SnacksViewController
			})
			if let viewController = snackVC {
				navController.popToViewController(viewController, animated: false)
			} else {
				//navController.popViewController(animated: true)
			}
		//}
    }

    func setupBasketButton() {
		let userID = self.isUserLoggedIn()

        if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(userID)).count > 0) {
            basketButton = MIBadgeButton()
            basketButton.badgeString = String(BasketTable.getByShopIdAndUserId("1", loginUserId: String(userID)).count)
            basketButton.badgeTextColor = UIColor.black
            basketButton.badgeBackgroundColor = UIColor.white
            basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 35, bottom: 0, right: 10)
            basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            basketButton.setImage(UIImage(named: "bag-1"), for: UIControl.State())
            basketButton.addTarget(self, action: #selector(ItemDetailViewController.loadBasketViewController(_:)), for: UIControl.Event.touchUpInside)
            itemNavi.customView = basketButton
            self.navigationItem.rightBarButtonItems = [itemNavi]
        }
    }

	func headerCollectionFlowLayout() {
		if let flowLayout = self.topCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout {
			self.headerFlowLayout = flowLayout
			headerFlowLayout.itemSize = CGSize(
				width: view.bounds.width * headerCellPercentWidth,
				height: topCollectionView.bounds.height
			)
			// Configure the optional inter item spacing (OPTIONAL STEP)
			headerFlowLayout.minimumLineSpacing = 15
			// Get rid of scrolling indicators
			topCollectionView.showsVerticalScrollIndicator = false
			topCollectionView.showsHorizontalScrollIndicator = false
			topCollectionView.decelerationRate = .fast
		}
	}

	func itemCollectionFlowLayout() {
		if let flowLayout = self.itemCollectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout {
			self.itemFlowLayout = flowLayout
			itemFlowLayout.itemSize = CGSize(
				width: view.bounds.width * itemCellPercentWidth,
				height: itemCollectionView.bounds.height
			)
			// Configure the optional inter item spacing (OPTIONAL STEP)
			itemFlowLayout.minimumLineSpacing = 15
			// Get rid of scrolling indicators
			itemCollectionView.showsVerticalScrollIndicator = false
			itemCollectionView.showsHorizontalScrollIndicator = false
			itemCollectionView.decelerationRate = .fast
		}
	}

	func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)
    }

	func newLabel(frame:CGRect, tag:Int, text:String, view:UIView) -> UILabel {
		var label = view.viewWithTag(tag) as? UILabel
		if label == nil {
			label = UILabel(frame: .zero)
			label?.tag = tag
			label?.font = UIFont(name: AppFontName.regular, size: 16)
            label?.textColor = .white
			view.addSubview(label!)
		}
		label?.frame = frame
		label?.text = text
		label?.translatesAutoresizingMaskIntoConstraints = true
		return label!
	}

	func newImageView(frame:CGRect, tag:Int, image:String, view:UIView) -> UIImageView {
		var imageView = view.viewWithTag(tag) as? UIImageView
		if imageView == nil {
			imageView = UIImageView(frame: .zero)
			imageView?.tag = tag
			imageView?.contentMode = .scaleAspectFit
			view.addSubview(imageView!)
		}
		imageView?.frame = frame
		imageView?.image = UIImage(named: image)
		imageView?.translatesAutoresizingMaskIntoConstraints = true
		return imageView!
	}


	func setProductDetails() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.88) {
			//Get Item and load details
			guard let items = self.items, let itemIndex = self.itemFlowLayout.currentCenteredPage else {
				return
			}
			let item = items[itemIndex]

			var description = item.itemName
			if item.itemDesc.count > 0 {
				description += "\n\(item.itemDesc)"
			}
			self.itemDescLabel.text = description
			self.showOtherDetails(item: item)
		}
	}

	func showOtherDetails(item:ItemModel) {
		let heightConstraint = self.otherDetailsView.constraints.first { (con) -> Bool in
			return con.identifier == "OtherDetailsHeightConstraint"
		}

		var rect = CGRect.zero
		var imageRect = CGRect.zero
		var tag:Double = 1
		var imagetag = 1001
		let offSet:CGFloat = 8

		//Show other details if availabel
		if item.aroma.count > 0  {
			imageRect = otherDetailsView.bounds.insetBy(dx: offSet, dy: offSet)
			imageRect.size.width = 20
			imageRect.size.height = 20

			rect = CGRect(x: imageRect.maxX + offSet, y: imageRect.minY, width: (otherDetailsView.frame.width-(40 + offSet*2))/2, height: imageRect.height)

			_ = self.newImageView(frame: imageRect, tag: imagetag, image: "aroma", view: otherDetailsView)
			_ = self.newLabel(frame: rect, tag: Int(tag), text: item.aroma, view: otherDetailsView)

			tag += 1
			imagetag += 1
		}

		if item.acidity.count > 0  {

			if rect == .zero {
				imageRect = otherDetailsView.bounds.insetBy(dx: offSet, dy: offSet)
				imageRect.size.width = 20
				imageRect.size.height = 20

				rect = CGRect(x: imageRect.maxX + offSet, y: imageRect.minY, width: (otherDetailsView.frame.width-40)/2, height: imageRect.height)
			} else {
				imageRect.origin.x = rect.maxX
				rect.origin.x = imageRect.maxX + offSet
			}
			_ = self.newImageView(frame: imageRect, tag: imagetag, image: "acidity", view: otherDetailsView)
			_ = self.newLabel(frame: rect, tag: Int(tag), text: item.acidity, view: otherDetailsView)

			tag += 1
			imagetag += 1
		}

		if item.taste.count > 0  {
			if rect == .zero {
				imageRect = otherDetailsView.bounds.insetBy(dx: offSet, dy: offSet)
				imageRect.size.width = 20
				imageRect.size.height = 20

				rect = CGRect(x: imageRect.maxX, y: imageRect.minY, width: (otherDetailsView.frame.width-40)/2, height: imageRect.height)
			} else {
				imageRect.origin.x = offSet
				imageRect.origin.y = rect.maxY + offSet

				rect.origin.x = imageRect.maxX + offSet
				rect.origin.y = imageRect.minY

			}
			_ = self.newImageView(frame: imageRect, tag: imagetag, image: "taste", view: otherDetailsView)
			_ = self.newLabel(frame: rect, tag: Int(tag), text: item.taste, view: otherDetailsView)

			tag += 1
			imagetag += 1
		}

		if item.body.count > 0  {
			if rect == .zero {
				imageRect = otherDetailsView.bounds.insetBy(dx: offSet, dy: offSet)
				imageRect.size.width = 20
				imageRect.size.height = 20

				rect = CGRect(x: imageRect.maxX, y: imageRect.minY, width: (otherDetailsView.frame.width-40)/2, height: imageRect.height)
			} else {
				imageRect.origin.x = rect.maxX
				rect.origin.x = imageRect.maxX + offSet
			}
			_ = self.newImageView(frame: imageRect, tag: imagetag, image: "body", view: otherDetailsView)
			_ = self.newLabel(frame: rect, tag: Int(tag), text: item.body, view: otherDetailsView)

			tag += 1
			imagetag += 1
		}

		if item.profile.count > 0  {
			if rect == .zero {
				imageRect = otherDetailsView.bounds.insetBy(dx: offSet, dy: offSet)
				imageRect.size.width = 20
				imageRect.size.height = 20

				rect = CGRect(x: imageRect.maxX, y: imageRect.minY, width: (otherDetailsView.frame.width-40)/2, height: imageRect.height)
			} else {
				imageRect.origin.x = offSet
				imageRect.origin.y = rect.maxY + offSet

				rect.origin.x = imageRect.maxX + offSet
				rect.origin.y = imageRect.minY
			}

			_ = self.newImageView(frame: imageRect, tag: imagetag, image: "profile", view: otherDetailsView)
			_ = self.newLabel(frame: rect, tag: Int(tag), text: item.profile, view: otherDetailsView)

			tag += 1
			imagetag += 1
		}
		//Update view height accordingly
		if rect == .zero {
			for view in otherDetailsView.subviews {
				view.removeFromSuperview()
			}
			heightConstraint?.constant = 0
		} else {
			let rows = CGFloat(ceil(tag / 2.0))
			let margin = (rows-1) * offSet
			heightConstraint?.constant = CGFloat(rows * 20 + margin)
		}
	}

	@IBAction func customizeAction(_ sender: UIButton) {
		openItemDetail()
	}

	@IBAction func subscribeAction(_ sender: UIButton) {
		guard let items = self.items, let itemIndex = itemFlowLayout.currentCenteredPage else {
			return
		}
		let item = items[itemIndex]

        let subscriptionOptionsViewController = self.storyboard?.instantiateViewController(identifier: "SubscriptionOptionsViewController") as! SubscriptionOptionsViewController
		subscriptionOptionsViewController.item = item
		subscriptionOptionsViewController.subscriptionType = self.subscriptionType
		self.navigationController?.pushViewController(subscriptionOptionsViewController, animated: true)
	}

	@IBAction func addToBasketAction(_ sender: UIButton) {
		guard let items = self.items, let itemIndex = itemFlowLayout.currentCenteredPage else {
			return
		}
		let item = items[itemIndex]
		guard item.attributes.count > 0 else {
			self.addToBasket()
			return
		}
		let attributeIndex = item.attributes.firstIndex { (attribute) -> Bool in
			return attribute.isRequired == "1"
		}

		if attributeIndex != nil {
			openItemDetail()
		} else {
			addToBasket()
		}
	}
}

extension CoffeeRecommendationViewController {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView == topCollectionView {
			self.itemCollectionView.reloadData()
		}
		self.setProductDetails()
	}
}

extension CoffeeRecommendationViewController : UICollectionViewDelegate, UICollectionViewDataSource {

	func configureHeaderCell(collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoffeeRecommendationHeaderCell", for: indexPath) as? CoffeeRecommendationHeaderCell

		cell?.titleLabel.text = "COFFEE GUIDE"
		if let cupping = self.selectedCupping {
//			cell?.descriptionLabel.text = ""
//			cell?.nameLabel.text = ""
//
//			if let bannerImage = cupping.banner_path {
//				let imageURL = configs.imageUrl + bannerImage
//				cell?.imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
//				   if(status == STATUS.success) {
//						print("Loaded flag image successfully: \(msg)")
//				   } else {
//					  print("Error in loading image: \(msg)")
//				   }
//				}
//			}
            
            cell?.imageView.image = nil
            cell?.descriptionLabel.text = "We recommend the following coffee based on your selection."
            if let name = cupping.title {
                cell?.nameLabel.text = name
                if name.count >= 50 {
                    cell?.nameLabel.font = UIFont(name: AppFontName.bold, size: 18)
                } else {
                    cell?.nameLabel.font = UIFont(name: AppFontName.bold, size: 20)
                }
            }
            
		} else {
			cell?.imageView.image = nil
			if let items = self.items, items.count > 1 {
				cell?.descriptionLabel.text = "We recommend the following coffees based on your selection. Swipe left and right to see more"
			} else {
				cell?.descriptionLabel.text = "We recommend the following coffee based on your selection."
			}
			if let selectedItem = self.selectedItems.first, let name = selectedItem["level1"] as? String {
				cell?.nameLabel.text = name
				if name.count >= 50 {
					cell?.nameLabel.font = UIFont(name: AppFontName.bold, size: 18)
				} else {
					cell?.nameLabel.font = UIFont(name: AppFontName.bold, size: 20)
				}
			}
		}
		cell?.backgroundColor = .clear
		return cell!
	}

	func configureItemCell(collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderItemCell", for: indexPath) as? OrderItemCell

		guard let items = self.items else {
			return cell!
		}
		let item = items[indexPath.row]

		cell?.nameLabel.text = item.itemName
        cell?.priceLabel.text = ""

		if let price = Int(item.itemPrice), price > 0 {
			let attrString = NSMutableAttributedString(string: "\(self.shopModel?.currencyShortForm ?? "") \(item.itemPrice)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .semibold), NSAttributedString.Key.foregroundColor: UIColor.white]);
			attrString.append(NSMutableAttributedString(string: " \(item.price_note)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),  NSAttributedString.Key.foregroundColor: UIColor.white]));
			cell?.priceLabel.attributedText = attrString
		} else {
			cell?.priceLabel.attributedText = NSAttributedString(string: "")
		}

		let imageName =  item.itemImage as String
		let imageURL = configs.imageUrl + imageName
		cell?.imageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"), options: .none, progressBlock: .none)

		cell?.backgroundColor = .clear
		return cell!
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard collectionView == itemCollectionView else {
			return 1
		}
		guard let items = self.items else {
			return 0
		}
		return items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		guard collectionView == itemCollectionView else {

			return self.configureHeaderCell(collectionView:collectionView, indexPath:indexPath)
		}
		return self.configureItemCell(collectionView:collectionView, indexPath:indexPath)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		guard collectionView == itemCollectionView else {
			let currentCenteredPage = headerFlowLayout.currentCenteredPage
			if currentCenteredPage != indexPath.row {
				// trigger a scrollToPage(index: animated:)
				headerFlowLayout.scrollToPage(index: indexPath.row, animated: true)
			}
			itemCollectionView.reloadData()
			return
		}
		setProductDetails()
	}

}

extension CoffeeRecommendationViewController {

	//MARK: API Call
    func loadShopData() {
		_ = EZLoadingActivity.show("Loading...", disableUI: true)
		_ = Alamofire.request(APIRouters.GetShopByID(1)).responseObject { (response: DataResponse<Shop>) in
			DispatchQueue.main.async {
			switch response.result {
			case .success:
				_ = EZLoadingActivity.hide()
				if let shop: Shop = response.result.value {
					self.shopModel = ShopModel(shop: shop)
						var itemsArr = [ItemModel]()

						for cat in shop.categories {
							for subCat in cat.subCategories{
								for item in subCat.item {
									let oneItem = ItemModel(item: item)
									itemsArr.append(oneItem)
								}
							}
						}
						self.filterItems(items: itemsArr)
					}
				case .failure(let error):
					_ = EZLoadingActivity.hide()
					print("Error: \(error.localizedDescription)")
				}
			}
		}
	}

	func filterItems(items: [ItemModel]) {
        var itemsArr = [ItemModel]()

		if let cupping = self.selectedCupping {
			for item in items {
				let itemId = cupping.coffee_id
				if item.itemId == itemId {
					itemsArr.append(item)
				}
			}
		} else {
			for selectedItem in self.selectedItems {
				for item in items {
					if let itemId = selectedItem["item_id"] as? Int, Int(item.itemId) == itemId{
						itemsArr.append(item)
					}
				}
			}
		}
		self.items = itemsArr

		self.topCollectionView.reloadData()
		self.itemCollectionView.reloadData()
		self.setProductDetails()
    }
}

extension CoffeeRecommendationViewController {

	func openItemDetail() {
		guard let items = self.items, let itemIndex = itemFlowLayout.currentCenteredPage else {
			return
		}
		let item = items[itemIndex]
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

		itemDetail = item

		self.navigationController?.pushViewController(itemDetailPage!, animated: true)
	}

	func addToBasket() {
		let userID = self.isUserLoggedIn()
		if userID != 0 {
			guard let items = self.items, let itemIndex = itemFlowLayout.currentCenteredPage else {
				return
			}
			let item = items[itemIndex]
            
            
            //Before adding an item lets check if uesr is adding item from same outlet or not. Meaning if item is available in his selected outlet.
            if(appDelegate.selectedOutletByUser != nil){
                //Chcecking if item exists at user selected store
            let itemsForOutlet = item.shops.filter({$0.shopId == appDelegate.selectedOutletByUser?.id })
            if(itemsForOutlet.count <= 0){
                //We have to stop user here.item is not at his store
                //If cart has more than zero items ask user to get rid of them first.
                let allBasketSchemas = BasketTable.getByShopIdAndUserId(String(1), loginUserId: String(userID))
                if allBasketSchemas.count > 0 {
                 _ = SweetAlert().showAlert("", subTitle: String.init(format: "You are ordering an item which is not available at your store %@. Do you want to remove existing items from cart and add this new item?",appDelegate.selectedOutletByUser!.name!), style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "CONFIRM", buttonColor: .clear, otherButtonTitle: "CANCEL") { (isOk) in
                        if isOk {
                            //Let's remove item and then move on
                            if allBasketSchemas.count > 0 {
                                for ab in allBasketSchemas{
                                    // BasketTable.deleteAll(ab)
                                    BasketTable.deleteByKeyIds("1", selectedId: Int64(ab.id!))
                                }
                            }
                            //User pressed confirm so lets add item now
                            self.addToBasket()
                        } else {
                            //User tapped cancel
                            return
                        }
                    }
                    return
                    //Let's return until user does any action
                }
            }
            }
            
            
            
            
            
            
            
            
            
            
            
            
			BasketTable.createTable()
			let basketSchema = BasketSchema()

			let alert = UIAlertController(title: "", message: "Great job! You’ve added \(item.itemName) to your cart", preferredStyle: UIAlertController.Style.alert)

			self.present(alert, animated: true, completion: nil)
			DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
				self.dismiss(animated: true, completion: nil)
			}

			basketSchema.itemId = String(item.itemId)
			basketSchema.shopId = "1"
			basketSchema.userId = String(userID)
			basketSchema.name   = item.itemName
			basketSchema.desc              = item.itemDesc
			basketSchema.unitPrice         = item.itemPrice
			if item.discountPercent != "" {
				basketSchema.discountPercent   = item.discountPercent
			} else {
				basketSchema.discountPercent   = "0.0"
			}
			basketSchema.qty               = 1
			basketSchema.imagePath         = item.itemImage
			basketSchema.currencySymbol    = self.shopModel?.currencySymbol
			basketSchema.currencyShortForm = self.shopModel?.currencyShortForm
			basketSchema.selectedAttribute = ""
			basketSchema.selectedAttributeIds = ""

			basketSchema.id = BasketTable.insert(basketSchema)

			//Show Basket Button
			setupBasketButton()

		self.refreshBasketCountsDelegate?.updateBasketCounts(BasketTable.getByShopIdAndUserId("1", loginUserId: String(userID)).count)
		self.basketTotalAmountUpdateDelegate?.updateTotalAmount(Float(BasketTable.getByShopIdAndUserId("1", loginUserId: String(userID)).count), reloadAll: true)
			var totalAmount : Float = 0.0
			for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(userID)) {
				totalAmount += Float(basket.unitPrice!)! * Float(basket.qty!)
			}
			self.basketTotalAmountUpdateDelegate?.updatedFinalAmount(totalAmount)
		} else {
			_ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.customImag(imageFile: "Logo"))
			weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
			UserLoginViewController?.title = "Login"
			UserLoginViewController?.delegate = self
			self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
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
			BasketManagementViewController?.basketUpdateDelegate = self
			self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
		} else {
			_ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.customImag(imageFile: "Logo"))
		}

    }
}

extension CoffeeRecommendationViewController : BasketUpdateDelegate {
	func set0ForEmtpyString(amount: String?) -> Float{
        let amt = amount ?? "0"
        return Float(amt == "" ? "0" : amt)!
    }

	func updateBasketCount() {
		let userID = self.isUserLoggedIn()
		if userID != 0 {
			basketCountUpdate(BasketTable.getByShopIdAndUserId("1", loginUserId: String(userID)).count)
			var totalAmount : Float = 0.0
			for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(userID)) {
				totalAmount += set0ForEmtpyString(amount: basket.unitPrice) * Float(basket.qty!)
			}
			self.basketTotalAmountUpdateDelegate?.updatedFinalAmount(totalAmount)
		}
	}
}

extension CoffeeRecommendationViewController: UserLoginDelegate {
    func updateLoginUserId(_ UserId: Int) {
        print("Login Done: \(UserId)")
    }
}

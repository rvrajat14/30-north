//
//  BasketViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 3/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import SQLite
import Alamofire
import UIKit


@objc protocol BasketTotalAmountUpdateDelegate: class {
    func updateTotalAmount(_ amount: Float, reloadAll: Bool)
    func updatedFinalAmount(_ amount : Float)
}

@objc protocol BasketUpdateDelegate: class {
    func updateBasketCount()
}

class BasketViewController: UITableViewController, ChoiceViewControllerDelegate {
    
    var allOutlets : [Outlet]?

	@IBOutlet var basketTableView: UITableView! {
		didSet {
			basketTableView.estimatedRowHeight = 90
			basketTableView.delegate = self
			basketTableView.dataSource = self
		}
	}

	var shop:Shop? = nil
    var basketItems = [BasketSchema]()
    var calculatedTotalPrice: Float = 0.0
    var calculatedPrice:Float = 0.0
    var selectedItemCurrencySymbol: String = ""
    var selectedItemCurrencyShortForm: String = ""
    var selectedShopArrayIndex: Int!
    var selectedShopId: Int!
    var loginUserId:Int = 0
    var amountLabel = UILabel()
    var giftLabel = UILabel()
    var paymentButton = UIButton()
    var giftButton = UIButton()

    var defaultValue: CGPoint!
    var fromWhere: String = ""
    
    weak var itemDetailBasketCountUpdateDelegate: ItemDetailBasketCountUpdateDelegate!
	weak var basketUpdateDelegate: BasketUpdateDelegate?
    weak var itemsGridBasketCountUpdateDelegate: ItemsGridBasketCountUpdateDelegate!
    weak var selectedShopBasketCountUpdateDelegate: SelectedShopBasketCountUpdateDelegate!
    weak var homeShopBasketCountUpdateDelegate: HomeShopBasketCountUpdateDelegate!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

		if let settingsDetailMod = settingsDetailModel{
			selectedItemCurrencySymbol = settingsDetailMod.currency_symbol!
			selectedItemCurrencyShortForm = settingsDetailMod.currency_short_form!
		}else{
			appDelegate.doSettingsAPI()
			return
		}

		loadBasket()
		//        setupPaymentOptionButton()
		setupCustomBackButton()

		if basketItems.count > 0 {
		//            self.selectedItemCurrencySymbol = self.basketItems[0].currencySymbol ?? ""
		//            self.selectedItemCurrencyShortForm = self.basketItems[0].currencyShortForm ?? ""
			selectedItemCurrencySymbol = settingsDetailModel!.currency_symbol!
			selectedItemCurrencyShortForm = settingsDetailModel!.currency_short_form!
		}
		defaultValue = tableView?.frame.origin
		animateTableView()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell") as! BasketCell
        let bskItem = basketItems[(indexPath as NSIndexPath).row]
        
        cell.configure(bskItem.id!,shopId: bskItem.shopId!,itemId: bskItem.itemId!,itemTitle:bskItem.name!,itemPrice: bskItem.unitPrice!, itemQty: bskItem.qty!, itemCurrencySymbol : bskItem.currencySymbol!, itemDiscountPerdent : bskItem.discountPercent!,  itemCoverImage: bskItem.imagePath!, userId: loginUserId, selectedAttribute : bskItem.selectedAttribute!, selectedAttributeIds : bskItem.selectedAttributeIds!)
        
        cell.basketTotalAmountUpdateDelegate = self
        cell.removeButton.tag = indexPath.row
        if cell.removeButton.tag == indexPath.row {
            cell.removeButton.addTarget(self, action: #selector(self.removeItem(_:)), for: UIControl.Event.touchUpInside)
        }
        let imageURL = configs.imageUrl + bskItem.imagePath!
        
        cell.coverImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
                
            }else {
               //print("Error in loading image" + msg)
            }
        }
        cell.coverImage.layer.masksToBounds = true
        cell.coverImage.layer.cornerRadius = 10
        
        cell.coverImage.alpha = 0
        cell.title.alpha = 0
        cell.price.alpha = 0
        cell.qty.alpha = 0
        cell.subTotalAmount.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            cell.coverImage.alpha = 1.0
            cell.title.alpha = 1.0
            cell.price.alpha = 1.0
            cell.qty.alpha = 1.0
            cell.subTotalAmount.alpha = 1.0
        }, completion: nil)
        
        return cell
    }
    
    @objc func removeItem(_ sender : UIButton) {
        _ = SweetAlert().showAlert("", subTitle: "Remove \(basketItems[sender.tag].name ?? "") from basket?", style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Cancel", buttonColor: UIColor.colorFromRGB(0xAEDEF4), otherButtonTitle: "Ok", action: { (isOk) in
            if !isOk {
                let bskItem = self.basketItems[sender.tag]
               //print("basket Id : ", bskItem.id!)
                BasketTable.deleteByKeyIds("1", selectedId: Int64(bskItem.id!))
                self.basketItems.removeAll()
                self.calculatedPrice = 0.0
                self.loadBasket()
                self.basketTableView.reloadData()
                self.amountLabel.text = language.total + String(self.calculatedPrice) + self.selectedItemCurrencySymbol
                if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(self.loginUserId)).count <= 0) {
                    self.navigationController?.popViewController(animated: true)
					NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KRefreshHome"), object: nil, userInfo: nil)
                }
            }
        })
    }
    
    @objc func isGiftingAction(_ sender: UIButton) {
        
        if(sender.backgroundColor == UIColor.gold){
            sender.backgroundColor = .clear

        }else{
            sender.backgroundColor = .gold
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var itemCell = tableView.cellForRow(at: indexPath) as? BasketCell
        weak var itemDetailPage = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetailViewController
        self.navigationController?.pushViewController(itemDetailPage!, animated: true)

        itemDetailPage!.selectedItemId = Int((itemCell!.selectedItemId))!
        itemDetailPage!.selectedShopId = 1
        itemDetailPage!.selectedAttributeStr = itemCell!.selectedAttribute
        itemDetailPage!.selectedAttributeIdsStr = itemCell!.selectedAttributeIds
        itemDetailPage!.selectedShopArrayIndex = selectedShopArrayIndex
        itemDetailPage!.refreshLikeCountsDelegate = nil
        itemDetailPage!.refreshReviewCountsDelegate = nil
        itemDetailPage!.basketTotalAmountUpdateDelegate = self
        itemDetailPage!.isEditMode = true
        
        updateBackButton()
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 75))
        //footerView.backgroundColor = UIColor.blackColor()
        footerView.backgroundColor = UIColor.clear
        
       
        
        
        self.giftButton = UIButton (frame: CGRect(x: 15, y: 10, width: 30, height: 30))
        self.giftButton.layer.cornerRadius = 15
        self.giftButton.layer.borderColor = UIColor.gold.cgColor
        self.giftButton.layer.borderWidth = 1.0
        self.giftButton.clipsToBounds = true
        self.giftButton.setTitle("", for: .normal)
        self.giftButton.addTarget(self, action: #selector(BasketViewController.isGiftingAction(_:)), for: .touchUpInside)
        footerView.addSubview(self.giftButton)
        
        self.giftLabel = UILabel(frame: CGRect(x: 55, y: 10, width: tableView.frame.size.width-55, height: 30))
        self.giftLabel.textAlignment = NSTextAlignment.left
        self.giftLabel.textColor = .white
        self.giftLabel.font = UIFont(name: AppFontName.bold, size: 16)
        self.giftLabel.text = "This order is a gift"
        self.giftLabel.backgroundColor =  .clear
        footerView.addSubview(giftLabel)


        
        
        //label.center = CGPointMake(160, 284)
               amountLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 150, height: 35))
               amountLabel.textAlignment = NSTextAlignment.center
               amountLabel.textColor = .white
               amountLabel.font = UIFont(name: AppFontName.bold, size: 16)
               amountLabel.text = language.total + String(calculatedPrice) + selectedItemCurrencySymbol
               amountLabel.backgroundColor =  .clear
        
        
        self.paymentButton = UIButton (frame: CGRect(x: tableView.frame.width - 136, y: 50, width: 120, height: 35))
        paymentButton.layer.cornerRadius = 5
        paymentButton.setTitle("Checkout", for: .normal)
        paymentButton.addTarget(self, action: #selector(BasketViewController.loadPaymentOptionsViewController(_:)), for: .touchUpInside)
        paymentButton.backgroundColor = UIColor(red: 183.0/255.0, green: 138.0/255.0, blue: 43.0/255.0, alpha: 1.0)
        paymentButton.setTitleColor(.white, for: .normal)
        paymentButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 17)
        if self.basketItems.count > 0 {
        footerView.addSubview(amountLabel)
        footerView.addSubview(paymentButton)
        }
        
        return footerView
    }

    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 140.0
    }
    
    
    
    func loadBasket() {
        
        for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)) {
            calculatedPrice += Float(basket.unitPrice!)! * Float(basket.qty!)
            basketItems.append(basket)
        }
    }
    
    func setupPaymentOptionButton() {
        let btnPaymentOption = UIButton()
        btnPaymentOption.setImage(UIImage(named: "Selection-Lite"), for: UIControl.State())
        btnPaymentOption.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        //        btnPaymentOption.addTarget(self, action: #selector(BasketViewController.loadPaymentOptionsViewController(_:)), for: .touchUpInside)
        let itemNavi = UIBarButtonItem()
        itemNavi.customView = btnPaymentOption
        self.navigationItem.rightBarButtonItems = [itemNavi]
    }
    
    func setupCustomBackButton() {
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named: "Back"), for: UIControl.State())
        btnBack.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        btnBack.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -20, bottom: 0, right: 0)
        
        btnBack.addTarget(self, action: #selector(BasketViewController.back(sender:)), for: .touchUpInside)
        let itemNavi = UIBarButtonItem()
        itemNavi.customView = btnBack
        self.navigationItem.leftBarButtonItems = [itemNavi]
        
    }
    
    @objc func back(sender: UIBarButtonItem) {
        
        if(basketItems.count == 0) {

			NotificationCenter.default.post(name: NSNotification.Name(rawValue:"BasketCountChanged"), object: nil)

            if(fromWhere == "detail") {
                self.itemDetailBasketCountUpdateDelegate.updateBasketCount()
            }
            _ = self.navigationController?.popToRootViewController(animated: true)
        } else {
            _ = navigationController?.popViewController(animated: true)
            if(fromWhere == "detail") {
                self.itemDetailBasketCountUpdateDelegate.updateBasketCount()
            } else if(fromWhere == "grid") {
                self.itemsGridBasketCountUpdateDelegate.updateBasketCount()
            } else if(fromWhere == "selectedshop") {
                self.selectedShopBasketCountUpdateDelegate.updateBasketCount()
            }else if(fromWhere == "home") {
                self.homeShopBasketCountUpdateDelegate.updateBasketCount()
			} else {
				self.basketUpdateDelegate?.updateBasketCount()
			}
        }
    }
    
    func passChoiceValue(_ isSelect: Bool, shopId: Int, index: Int){
        if isSelect{
            
//            skipDiscountScreen(paymentOption: "poc")
//            selectedIndex = index
//            sShopId = shopId
            
            weak var CouponViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CouponDiscount") as? CouponDiscountViewController
            CouponViewController?.title = language.couponDiscountTitle
            CouponViewController?.selectedShopId = 1
            CouponViewController?.totalAmount = calculatedPrice
            CouponViewController?.selectedPaymentOption = "poc"
            CouponViewController?.selectedShopArrayIndex = index
            CouponViewController?.checkoutCurrencySymbol = settingsDetailModel!.currency_symbol!
            CouponViewController?.checkoutCurrencyShortForm = settingsDetailModel!.currency_short_form!
            self.navigationController?.pushViewController(CouponViewController!, animated: true)
            updateBackButton()
            
        }else{
            
        }
    }

        func skipDiscountScreen(paymentOption: String){
            weak var ConfirmViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CheckoutConfirm") as? CheckoutConfirmViewController
            ConfirmViewController?.subTotalAmount = calculatedPrice
            ConfirmViewController?.selectedPaymentOption = paymentOption
    //        ConfirmViewController?.selectedShopArrayIndex = self.selectedShopArrayIndex
            //        ConfirmViewController?.checkoutCurrencySymbol = self.checkoutCurrencySymbol
            //        ConfirmViewController?.checkoutCurrencyShortForm = self.checkoutCurrencyShortForm
            ConfirmViewController?.checkoutCurrencySymbol = settingsDetailModel!.currency_symbol!
            ConfirmViewController?.checkoutCurrencyShortForm = settingsDetailModel!.currency_short_form!
            
            ConfirmViewController?.selectedShopId = 1
            ConfirmViewController?.couponName = ""
            ConfirmViewController?.couponAmount = ""
            //        ConfirmViewController?.settingsDetailModel = settingsDetailModel
            self.navigationController?.pushViewController(ConfirmViewController!, animated: true)
            
            updateBackButton()
        }
    @objc func loadPaymentOptionsViewController(_ sender : UIButton) {
//        if(ShopsListModel.sharedManager.shops[selectedShopArrayIndex].bankTransferEnabled == "0" && (ShopsListModel.sharedManager.shops[selectedShopArrayIndex].codEnabled == "0") && (ShopsListModel.sharedManager.shops[selectedShopArrayIndex].cashPickupEnabled != "0") && (ShopsListModel.sharedManager.shops[selectedShopArrayIndex].stripeEnabled == "0")) {
        if(settingsDetailModel!.banktransfer_enabled! == "0" && (settingsDetailModel!.cod_enabled! == "0") && (settingsDetailModel!.cash_pickup_enabled! != "0") && (settingsDetailModel!.stripe_enabled! == "0")) {
                
            let choiceViewController = storyboard!.instantiateViewController(withIdentifier: "ChoiceViewController") as! ChoiceViewController
            choiceViewController.delegate = self
            addChild(choiceViewController)
            view.addSubview(choiceViewController.view)
            choiceViewController.didMove(toParent: self)

            return
        }

        calculatedPrice = 0.0
        for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)) {
            calculatedPrice += Float(basket.unitPrice!)! * Float(basket.qty!)
        }
		//Show payment popup, when uutlets are loaded from api
		self.getOutletsData()

        /* Comment to add new payment popup options
		weak var PaymentSelectionViewController =  self.storyboard?.instantiateViewController(withIdentifier: "PaymentOption") as? PaymentOptionsViewController
        PaymentSelectionViewController?.title = language.paymentOptionsTitle
//        PaymentSelectionViewController?.selectedShopArrayIndex = selectedShopArrayIndex
        PaymentSelectionViewController?.totalAmount = calculatedPrice
//        PaymentSelectionViewController?.currencySymbol = selectedItemCurrencySymbol
//        PaymentSelectionViewController?.currencyShortForm = selectedItemCurrencyShortForm
//        PaymentSelectionViewController?.selectedShopId = selectedShopId
        self.navigationController?.pushViewController(PaymentSelectionViewController!, animated: true)*/
        updateBackButton()
    }

	func openCheckOutVC() {
		calculatedPrice = 0.0
        for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)) {
            calculatedPrice += Float(basket.unitPrice!)! * Float(basket.qty!)
        }

		let checkoutVC = self.storyboard?.instantiateViewController(identifier: "CheckoutViewController") as? CheckoutViewController
		//checkoutVC?.shop = self.shop
        checkoutVC?.allOutlets = self.allOutlets
		checkoutVC?.totalAmount = calculatedPrice
        if(self.giftButton.backgroundColor == UIColor.gold){
                   checkoutVC?.isGiftingToSomeone = true
               }else{
                   checkoutVC?.isGiftingToSomeone = false
               }
		self.navigationController?.pushViewController(checkoutVC!, animated: true)
	}

	func loadCouponDiscount(_ paymentOption: String, outlet:Outlet?) {

		calculatedPrice = 0.0
        for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)) {
            calculatedPrice += Float(basket.unitPrice!)! * Float(basket.qty!)
        }

		weak var CouponViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CouponDiscount") as? CouponDiscountViewController
		CouponViewController?.title = language.couponDiscountTitle
		CouponViewController?.totalAmount = calculatedPrice
		CouponViewController?.selectedPaymentOption = paymentOption
		CouponViewController?.outlet = outlet
		self.navigationController?.pushViewController(CouponViewController!, animated: true)
		updateBackButton()
	}

	func openOutlets(data:NSDictionary) {
		let outletPopupVC =  self.storyboard?.instantiateViewController(withIdentifier: "OutletPopupViewController") as? OutletPopupViewController

		//Pass data to Outlet Popup
		outletPopupVC?.option = data
		outletPopupVC?.shop = self.shop

		self.showPopup(vc: outletPopupVC!, width: 0.7, height: 0.3, popupAttributes: nil)
		//Completion handler
		outletPopupVC?.didSelectOutlet = { [unowned self] (outlet:Outlet) in
			self.hideCustomPopUp()
			if let paymentType = data["id"] as? String {
				self.loadCouponDiscount(paymentType, outlet: outlet)
			} else {
				print("Payment Error")
			}
		}
	}

	func openPaymentPopup() {
		let paymentVC =  self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
		paymentVC?.title = language.paymentOptionsTitle

		var height:CGFloat = 110.0

		if let settingsDetail = settingsDetailModel{
			var optionsAvailable:CGFloat = 0
			if let isEnabled = settingsDetail.paypal_enabled, isEnabled != "0" {
				optionsAvailable += 1
			}
			if let isEnabled = settingsDetail.stripe_enabled, isEnabled != "0" {
				optionsAvailable += 1
			}
			if let isEnabled = settingsDetail.cash_pickup_enabled, isEnabled != "0" {
				optionsAvailable += 1
			}
			if let isEnabled = settingsDetail.cod_enabled, isEnabled != "0" {
				optionsAvailable += 1
			}
			if let isEnabled = settingsDetail.banktransfer_enabled, isEnabled != "0" {
				optionsAvailable += 1
			}
			height = height + CGFloat(optionsAvailable * 44.0)
		} else {
			height += 90
		}
		let ratioY = height/UIScreen.main.bounds.height
		self.showPopup(vc: paymentVC!, width: 0.7, height: ratioY, popupAttributes: nil)

		//Payment Option Popup
		paymentVC?.didSelectPaymentOption = { [unowned self] (option:NSDictionary)in
			//Show Outlets when payment method is selected
			guard let paymentType = option.value(forKey: "id") as? String else {
				print("Payment Error")
				return
			}
			//Show outlets if payment type if POC
			if paymentType.lowercased() == "poc" {
				self.openOutlets(data: option)
			} else {
				self.hideCustomPopUp()
				self.loadCouponDiscount(paymentType, outlet: nil)
			}
        }
	}

    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func animateTableView() {
        moveOffScreen()
            self.tableView?.frame.origin = self.defaultValue
    }
    
    fileprivate func moveOffScreen() {
        tableView?.frame.origin = CGPoint(x: (tableView?.frame.origin.x)!,
                                          y: (tableView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
}

extension BasketViewController : BasketTotalAmountUpdateDelegate {
    func updatedFinalAmount(_ amount: Float) {
       //print("Total Amount \(amount)")
    }
    
    func updateTotalAmount(_ amount: Float, reloadAll: Bool) {
        amountLabel.text = language.total +  String(amount) + selectedItemCurrencySymbol
        
        if(reloadAll) {
            basketItems.removeAll()
            loadBasket()
            
            tableView.reloadData()
        }
    }
}

extension BasketViewController {
	//MARK:- GET OUTLET  API CALL
    /*
	func getOutletsData()  {
		_ = EZLoadingActivity.show("Loading...", disableUI: true)

		Alamofire.request(APIRouters.GetShopByID(1)).responseCollection {
			(response: DataResponse<[Shop]>) in

			DispatchQueue.main.async {
				_ = EZLoadingActivity.hide()
				if response.result.isSuccess, let shops: [Shop] = response.result.value {
					self.shop = shops.first
					self.openCheckOutVC()

					//Show Payment popup
					//self.openPaymentPopup()
				} else {
					_ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noShops, style: AlertStyle.customImag(imageFile: "Logo"))
				}
			}
		}
	}
 */
    
    
    //MARK:- GET OUTLET  API CALL
      func getOutletsData()  {
          _ = EZLoadingActivity.show("Loading...", disableUI: true)
          
          Alamofire.request(APIRouters.GetOutlets).responseCollection {
              (response: DataResponse<[Outlet]>) in
              DispatchQueue.main.async {
                  _ = EZLoadingActivity.hide()
              if response.result.isSuccess {
                  if let outlets: [Outlet] = response.result.value {
                      self.allOutlets = outlets
                      self.openCheckOutVC()
                      } else {
                          _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noShops, style: AlertStyle.customImag(imageFile: "Logo"))
                      }
                  }
              }
          }
      }
    
    
    
    
}

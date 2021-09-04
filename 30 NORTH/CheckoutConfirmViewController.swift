//
//  CheckoutConfirmViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 5/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Alamofire
import AcceptSDK

class CheckoutConfirmViewController : UIViewController, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, AcceptSDKDelegate {
   //class CheckoutConfirmViewController : UIViewController, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {

	var selectedIndex:Int = -1
	var selectedDistrict:NSDictionary? = nil

    @IBOutlet weak var pickUpDayButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var pickUpTimeButton: UIButton!
    @IBOutlet weak var pickUpPickerView: UIDatePicker!
    @IBOutlet weak var pickerMainView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var deliveryAddress: UITextView!
    @IBOutlet weak var billingAddress: UITextView!
    var isGiftingToSomeone: Bool = false
    var giftRecipientName: String?
    var giftRecipientAddress: String?
    var giftRecipientMobile: String?

	//Popup for Districts
	@IBOutlet weak var popupView: UIView! {
		didSet {
			popupView.isHidden = true
			popupView.layer.cornerRadius = CGFloat(8)
			popupView.layer.borderWidth = 1
			popupView.layer.borderColor = UIColor.black.cgColor
			popupView.clipsToBounds = true
		}
	}
	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.text = "Choose District"
			titleLabel.font = UIFont(name: AppFontName.bold, size: 17)!
			titleLabel.textAlignment = .center
		}
	}
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
		}
	}
	@IBOutlet weak var selectButton: UIButton!
	@IBOutlet weak var closeButton: UIButton!


    @IBOutlet weak var pickupView: UIView!
    @IBOutlet weak var btnCheckout: UIButton!{
		didSet {
			btnCheckout.titleLabel?.font = UIFont(name: AppFontName.bold, size: 16)
			btnCheckout.layer.cornerRadius = 8.0
			btnCheckout.clipsToBounds = true
			btnCheckout.setTitle("Confirm Order", for: .normal)
			btnCheckout.setTitleColor(.black, for: .normal)
			btnCheckout.backgroundColor = .white
		}
	}
	@IBOutlet weak var shoppingButton: UIButton! {
		didSet {
			shoppingButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 16)
			shoppingButton.layer.cornerRadius = 8.0
			shoppingButton.clipsToBounds = true
			shoppingButton.setTitle("Continue Shopping", for: .normal)
			shoppingButton.setTitleColor(.black, for: .normal)
			shoppingButton.backgroundColor = .white
		}
	}


    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    //    @IBOutlet weak var checkoutTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seletedPayment: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var couponDiscountAmount: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var shippingCost: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton! {
        didSet {
            locationButton.isHidden = true
        }
    }
    var defaultValue: CGPoint!
    var outlet:Outlet? = nil
    var totalCheckoutAmount: Float = 0.0
    var subTotalAmount: Float = 0.0
	var tipAmount: Float = 0.0
    var shippingRate: Float = 0.0
    var shippingRateString: String = ""
    var selectedShopArrayIndex: Int!
    var selectedPaymentOption: String = ""
	var deliveryMethod:String = ""
    var loginUserId:Int = 0
    var loginUserName: String = ""
    var loginUserEmail: String = ""
    var loginUserPhone: String = ""
	var loginUserLastName: String = ""
	var loginUserBirthDate: String = ""
	var isPhoneVerified: Bool = false
    var loginUserDeliveryAddress: String = ""
	var districtID: String = ""
    var giftOrderDistrictID: String = ""
    //var loginUserBillingAddress: String = ""
    var selectedShopId = 1
    var checkoutCurrencySymbol: String = ""
    var checkoutCurrencyShortForm: String = ""
    var basketItems = [BasketSchema]()
    var placeholderDeliveryLabel : UILabel!
    var placeholderBillingLabel : UILabel!
//    var selectedShopOrder: Shop? = nil
    var openingDate: Date? = nil
    var closingDate: Date? = nil
    var couponName: String = ""
    var couponAmount: String = ""
    var transArray = [[String:AnyObject]]()
    var VAT_AMOUNT = Float(0.0)
    var AcceptOrderId : String = ""
    var orderID: String = ""
	var subscription:[String:String]?
	var subscriptionItem: ItemModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.mainViewBackground
        
        //We have to send epayment in api
        if(selectedPaymentOption == "online"){
            selectedPaymentOption = "epayment"
        }

        //self.hideKeyboardWhenTappedAround()
       if let _ = settingsDetailModel{
            checkoutCurrencySymbol = settingsDetailModel!.currency_symbol!
            checkoutCurrencyShortForm = settingsDetailModel!.currency_short_form!
        }else{
            appDelegate.doSettingsAPI()
            return
        }
        
        contentScrollView.delegate = self
        bindData()
        
        print("Price before rounding off values \(self.VAT_AMOUNT + self.totalCheckoutAmount)\n")
        print("Price after rounding off values \((self.VAT_AMOUNT + self.totalCheckoutAmount).rounded(.up))\n")

        placeholderDeliveryLabel = UILabel()
        placeholderBillingLabel = UILabel()
        
        addPlaceHolder(deliveryAddress, placeHolderText: "Delivery Address", placeholderLabel: placeholderDeliveryLabel)
        //addPlaceHolder(billingAddress, placeHolderText: "Billing Address", placeholderLabel: placeholderBillingLabel)
        
        
        name.delegate = self
        email.delegate = self
        phone.delegate = self
        
        deliveryAddress.delegate = self
        //billingAddress.delegate = self
        notesTextView.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CheckoutConfirmViewController.dismissKeyboard1)) )
        
        contentScrollView.alpha = 0
        defaultValue = contentScrollView?.frame.origin
        if self.selectedPaymentOption == "poc" {
            addressViewHeightConstraint.constant = 0
            //checkoutTopConstraint.constant = -150
            addressView.alpha = 0
            pickupView.isHidden = false
        } else {
            addressViewHeightConstraint.constant = 261
//            checkoutTopConstraint.constant = 21
            addressView.alpha = 1
            pickupView.isHidden = true
        }
        
        // hiding address view for all payment option.
        addressViewHeightConstraint.constant = 0
        addressView.alpha = 0

        animateContentScrollView()
		//=========================== validation updated ===================
		//self.dateAndTimeCalculation()
		self.checkPickUpTime()
		//=========================== validation updated ===================
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.bindUserInfo()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}

    @objc func dismissKeyboard1(){
        name.resignFirstResponder()
        email.resignFirstResponder()
        phone.resignFirstResponder()
        
        deliveryAddress.resignFirstResponder()
        //billingAddress.resignFirstResponder()
    }

    func textFieldShouldReturn(_ UITextField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        // Try to find next responder
        let nextTag = UITextField.tag + 1
        if let nextField = UITextField.superview?.viewWithTag(nextTag) as? UITextField {
            nextField.becomeFirstResponder()
        } else if let nextField2 = UITextField.superview?.viewWithTag(nextTag) as? UITextView {
            nextField2.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            //UITextField.resignFirstResponder()
            self.view.endEditing(true)
        }
        // Do not add a line break
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       //print(text)
        if(text == "\n") {
            let nextTag = textView.tag + 1
            if let nextField = textView.superview?.viewWithTag(nextTag) as? UITextView {
                nextField.becomeFirstResponder()
            } else {
                // Not found, so remove keyboard.
                //textView.resignFirstResponder()
                self.view.endEditing(true)
            }
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.frame.origin.y -= 165
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		self.view.frame.origin.y += 165
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.frame.origin.y -= 215
    }

    func textViewDidEndEditing(_ textView: UITextView)  {
        self.view.frame.origin.y += 215
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        let screenSize: CGRect = UIScreen.main.bounds
        scrollView.contentSize = CGSize(width: screenSize.width, height: screenSize.height + 300)
    }

    @IBAction func shoppingAction(_ sender: UIButton) {

		if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.getTabbarController() {
			self.navigationController?.popToRootViewController(animated: true)
			tabBarController.selectedViewController?.navigationController?.popToRootViewController(animated: true)
			tabBarController.selectedIndex = 1
		}
	}

    @IBAction func gotoPayment(_ sender: AnyObject) {
		self.gotoPayment()
    }

	func gotoPayment() {
		self.view.endEditing(true)

		guard isPhoneVerified else {
			_ = SweetAlert().showAlert(language.checkoutConfirmationTitle, subTitle:language.phoneNotVerified, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
				self.openEditProfile()
			})
			return
		}
                

		if self.deliveryMethod == "delivery" {
            
            //Gift Option case: We need to show district option even if uesr have district id. Gift purchase will have different district id basedon recipient address so we have to make user to choose this. User's distrcit id is not important in this case.

            if(self.isGiftingToSomeone == true && self.giftOrderDistrictID == ""){
                _ = SweetAlert().showAlert(language.checkoutConfirmationTitle,subTitle:language.noDistrict ,style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                              self.showPopupView()
                          })
                          return
            }else{
                guard districtID.trim().count > 0 else {
                    _ = SweetAlert().showAlert(language.checkoutConfirmationTitle,subTitle:language.noDistrict ,style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                        self.showPopupView()
                    })
                    return
                }
                guard loginUserDeliveryAddress.trim().count > 0 else {
                    _ = SweetAlert().showAlert(language.checkoutConfirmationTitle,subTitle:language.deliveryAddressNotVerified ,style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                        self.openEditProfile()
                    })
                    return
                }
            }
			
		}
        if(Reachability.isConnectedToNetwork()) {
                switch selectedPaymentOption {
                case "bank":
                    checkoutWithBankTransfer()
                    break
                case "cod":
                    orderSubmitToServer(isOnlinePayment: false)
                    //self.getAuthenticationTokenForPayment()
                    break
                case "poc":
                    checkoutWithPOC()
                    break
                case "epayment":
                    orderSubmitToServer(isOnlinePayment: true)
                default:
                    break
                }
        } else {
            _ = SweetAlert().showAlert(language.offlineTitle, subTitle: language.offlineMessage, style: AlertStyle.customImag(imageFile: "Logo"))
        }
	}
	func openEditProfile() {
		let shopProfileViewController = self.storyboard?.instantiateViewController(identifier: "ComponentUserProfileEdit") as! UserProfileEditViewController
		self.navigationController?.pushViewController(shopProfileViewController, animated: true)
	}

    @IBAction func onTimePickerClick(_ sender: UIButton) {
        pickerMainView.isHidden = false
        self.view.bringSubviewToFront(pickerMainView)
    }
    
    //MARK: Not using now
    func checkoutWithCOD() {
        orderSubmitToServer(isOnlinePayment: false)
    }
    
    func checkoutWithPOC() {
        orderSubmitToServerPOC()
    }

    @IBAction func locationAction(_ sender: UIButton) {
        if let outletID = self.outlet?.id {
            print("Outlet ID: \(outletID)")
            self.showOrderLocationPopup(imageName: outletID + ".png" )
        }
    }
    
    @IBAction func onDismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onDatePick(_ sender: Any) {

        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let firstAction: UIAlertAction = UIAlertAction(title: "Today", style: .default) { action -> Void in
            self.pickUpDayButton.setTitle("Today", for: .normal)
           //print("Today Action pressed")
			//=========================== validation updated ===================
            //self.dateAndTimeCalculation()
			self.checkPickUpTime()
			//=========================== validation updated ===================
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Tomorrow", style: .default) { action -> Void in
            self.pickUpDayButton.setTitle("Tomorrow", for: .normal)
           //print("Tommorrow Action pressed")
            self.pickUpPickerView.minimumDate = self.openingDate!
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
       //print(Date(), closingDate)
        let currentMilli = Date().millisecondsSince1970
        let closingMilli = closingDate!.millisecondsSince1970

        if currentMilli < closingMilli{
            actionSheetController.addAction(firstAction)
        }
       //print("closingMilli : ",currentMilli, closingMilli)

        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.popoverPresentationController?.sourceView = self.view
                
        present(actionSheetController, animated: true) {
           //print("option menu presented")
        }

    }
    
    @IBAction func onTimePickerDone(_ sender: Any) {
        pickerMainView.isHidden = true
    }
    
    func checkoutWithBankTransfer() {
        orderSubmitToServerPOC()
    }
    @IBAction func onPickerEndEditing(_ sender: Any) {
        pickerMainView.isHidden = true
    }
    
    @IBAction func onPickerChanged(_ sender: UIDatePicker) {
        
        let pickupTime = getDateInTimeFormat(date: sender.date )
       //print("picker : ", pickupTime)
        pickUpTimeButton.setTitle(pickupTime, for: .normal)
    }
    
    func getDateInTimeFormat(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH : mm"
        let dateString = formatter.string(from: date)
        return dateString
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func orderSubmitToServerPOC() {
        loadBasketPOC()
        
        let orders: Array<[String:AnyObject]> = transArray
        do {
            let data = try JSONSerialization.data(withJSONObject: orders, options:[])
            let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
            
            
            let params: [String: AnyObject] = [
                "orders": dataString,
            ]
            
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            _ = Alamofire.request(APIRouters.SubmitTransaction(params)).responseObject{
                
                (response: DataResponse<StdResponse>) in
                
                _ = EZLoadingActivity.hide()
                
                if response.result.isSuccess {
                    if let resp = response.result.value {
                        if(resp.status == "success") {
							if self.subscriptionItem != nil, self.subscription != nil {
								self.updateSubscriptionsCountLocally()
							} else {
								self.updateOrderCountLocally()
							}

                            _ = SweetAlert().showAlert(language.orderSuccessTitle, subTitle: language.orderSuccessMessage, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: " OK ") {
                                (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    
                                    //Clean Basket
//                                    BasketTable.deleteByShopId(String(ShopsListModel.sharedManager.shops[self.selectedShopArrayIndex].id))
                                    BasketTable.deleteByShopId("1")

                                    //Clean Attribute Table
                                    //AttributeTable.deleteByShopId(String(ShopsListModel.sharedManager.shops[self.selectedShopArrayIndex].id))
                                    
                                    //Load Home Page
                                    
                                    _ = self.navigationController?.popToRootViewController(animated: true)
                                    
                                }
                            }
                            
                        } else {
                            _ = SweetAlert().showAlert(language.orderFailTitle, subTitle: language.orderFailMessage, style: AlertStyle.customImag(imageFile: "Logo"))
                        }
                    }
                } else {
                   print(response)
                }
            }
            
        } catch {
           //print("JSON serialization failed:  \(error)")
        }
        transArray.removeAll()
    }
    


    func orderSubmitToServer(isOnlinePayment: Bool) {
        
        if(isOnlinePayment == true) {
            //Let's check if we have all 4 information for bDATA for Accept sdk then proceed further only
            if(isNecessaryInfoAvailableToProcessOnlineOrder() == false){
                return
            }
        }

		var isSubscription = false
		if self.subscriptionItem != nil, self.subscription != nil {
			isSubscription = true
			loadSubscriptionData()
		} else {
            if(self.isGiftingToSomeone == true){
                loadGiftOrderData()
            }else{
                loadBasket()
            }
		}

        let orders: Array<[String:AnyObject]> = transArray
        do {
            let data = try JSONSerialization.data(withJSONObject: orders, options:[])
            let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
            let params: [String: AnyObject] = [
                "orders": dataString,
            ]
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            _ = Alamofire.request(APIRouters.SubmitTransaction(params)).responseJSON { response in
                print(response)
                _ = EZLoadingActivity.hide()

                switch response.result {
                 case .success(let data):
                     // First make sure you got back a dictionary if that's what you expect
                     guard let json = data as? [String : AnyObject] else {
                        print("Failed to get expected response from webserver.")
                        return
                     }

                     //Let's handle duplicate case first. This happens when we try to get order id again for same merchant order id
                     if json["status"] as? String == "success", let orderID = json["order_id"] as? NSNumber {
                        self.orderID = orderID.stringValue

						if isSubscription == true {
							self.updateSubscriptionsCountLocally()
						} else {
							self.updateOrderCountLocally()
						}

                        if(isOnlinePayment == true) {
							BasketTable.deleteByShopId("1")
							self.getAuthenticationTokenForPayment()
                            //Online Payment
                            /*_ = SweetAlert().showAlert(language.orderSuccessTitle, subTitle: language.orderSuccessMessageForOnlinePayment, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: " OK ") {
                                (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    //Clean Basket
                                    BasketTable.deleteByShopId("1")
                                    self.getAuthenticationTokenForPayment()
                                }
                            }*/
                        } else {
                            //COD Case
                            //If Order submitted successfully we are showing success alert here. Show this alert in case of COD, for Online payment separate msg.
                            _ = SweetAlert().showAlert(language.orderSuccessTitle, subTitle: language.orderSuccessMessage, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: " OK ") {
                                (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    //Clean Basket
                                    BasketTable.deleteByShopId("1")
                                    //Load Home Page
                                    _ = self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }
                    }
                case .failure(_): break
                }
            }
        } catch {
            _ = EZLoadingActivity.hide()
           print("JSON serialization failed:  \(error)")
        }
        transArray.removeAll()
    }

	func updateOrderCountLocally() {
		let userDefaults = UserDefaults.standard
		//Subscriptions count
		userDefaults.setValue("1", forKey: "Orders")
	}

	func updateSubscriptionsCountLocally() {
		let userDefaults = UserDefaults.standard
		//Subscriptions count
		userDefaults.setValue("1", forKey: "Subscriptions")
	}

    func addMinutesToCurrentTime(date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .minute, value: 30, to: date)!
    }

    func bindData() {
        shippingRateString = settingsDetailModel!.flat_rate_shipping!
        if selectedPaymentOption == "cod" {
            shippingRate = Float(shippingRateString)!
            shippingCost.isHidden = false
        }else if let options = self.subscription, let quantity = options["quantity"], quantity == "1" {
            shippingRate = Float(shippingRateString)!
			shippingCost.isHidden = false
		} else {
            shippingRate = Float(0.0)
            shippingCost.isHidden = true
        }
		if tipAmount > 0 {
			tipAmountLabel.text = "Tip Amount : + \(tipAmount) \(checkoutCurrencySymbol)"
		} else {
			tipAmountLabel.text = ""
		}
        if(couponAmount != "") {
			let discount = couponAmount.floatValue
			let actualDiscount = subTotalAmount * discount/100
            totalCheckoutAmount = ((subTotalAmount - actualDiscount) + shippingRate + tipAmount)

            couponDiscountAmount.text = language.couponDiscountLabel + " - \(actualDiscount) " + checkoutCurrencySymbol
        } else {
            //couponDiscountAmount.text = language.couponDiscountLabel + "N.A"
            couponDiscountAmount.text = ""
            totalCheckoutAmount = (subTotalAmount + shippingRate + tipAmount)
            couponAmount = "0.0"
        }

        subTotal.text = language.subTotalLabel + String(subTotalAmount) + " " + checkoutCurrencySymbol
        
//        if(ShopsListModel.sharedManager.shops[self.selectedShopArrayIndex].flatRateShipping != "0") {
        if(settingsDetailModel!.flat_rate_shipping! != "0") {
            shippingCost.text = language.shippingCostLabel + " + " + settingsDetailModel!.flat_rate_shipping! + " " + checkoutCurrencySymbol
        } else {
            shippingCost.text = language.shippingCostLabel + "N.A"
        }
//        VAT_AMOUNT = (14.0 * (totalCheckoutAmount - shippingRate)) / 100.0
//        self.vatLabel.text = "VAT : \(VAT_AMOUNT)" + " " + checkoutCurrencySymbol + "(" + checkoutCurrencyShortForm + ")"
//        total.text! = language.orderTotalLabel + String(totalCheckoutAmount + Float(settingsDetailModel.vat!)!) + " " + checkoutCurrencySymbol + "(" + checkoutCurrencyShortForm + ")"

       //print(settingsDetailModel!.vat!)
       //print(totalCheckoutAmount)

        VAT_AMOUNT = Float(settingsDetailModel!.vat!)! * subTotalAmount
       //print(VAT_AMOUNT)
        self.vatLabel.text = "VAT : \(VAT_AMOUNT)" + " " + checkoutCurrencySymbol
        total.text! = language.orderTotalLabel + String(VAT_AMOUNT + totalCheckoutAmount) + " " + checkoutCurrencySymbol
        
        
        switch selectedPaymentOption {
        case "stripe":
            seletedPayment.text = "Stripe"
            break
         
        case "bank":
            seletedPayment.text = "Bank Transfer"
            break
            
        case "cod":
            seletedPayment.text = "Cash On Delivery"
            break
            
        case "poc":
            self.locationButton.isHidden = false
            seletedPayment.text = "Pay Cash at Pickup"

            if let outlet = self.outlet, let name = outlet.name {
                seletedPayment.text = "Pay Cash at Pickup: \(name)"
            }
            break
        case "epayment":
            self.locationButton.isHidden = false
            seletedPayment.text = "Online"
            if let outlet = self.outlet, let name = outlet.name {
                seletedPayment.text = "Online Pickup: \(name)"
            } else {
                seletedPayment.text = "Online"
            }
            break
        default: break
        }
        
        bindUserInfo()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch (textView) {
        case deliveryAddress:
            placeholderDeliveryLabel.isHidden = !deliveryAddress.text.isEmpty
            break
        
        /*case billingAddress:
            placeholderBillingLabel.isHidden = !billingAddress.text.isEmpty
            break
          */
        default: break
        }
    }
    
    func addPlaceHolder(_ textView: UITextView, placeHolderText: String, placeholderLabel: UILabel) {
        textView.delegate = self
        placeholderLabel.text = placeHolderText
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: textView.font!.pointSize)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        
        placeholderLabel.frame.origin = CGPoint(x: 5, y: textView.font!.pointSize / 3)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        textView.layer.cornerRadius = 5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
    }
    
    func bindUserInfo() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: plistPath)) {
            if let bundlePath = Bundle.main.path(forResource: "LoginUserInfo", ofType: "plist") {

                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: plistPath)
                } catch {
                }
            } else {
                //print("LoginUserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            //print("LoginUserInfo.plist already exits at path.")
        }
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {
            loginUserId           = Common.instance.getLoginUserId(dict: dict)
            loginUserName         = dict.object(forKey: "_login_user_username") as! String
            loginUserEmail        = dict.object(forKey: "_login_user_email") as! String
            loginUserPhone        = dict.object(forKey: "_login_user_phone") as! String
			loginUserLastName     = dict.object(forKey: "_login_user_lastname") as? String ?? ""
            loginUserBirthDate	  = dict.object(forKey: "_login_user_birth_date") as? String ?? ""

            loginUserDeliveryAddress = dict.object(forKey: "_login_user_delivery_address") as! String
            //loginUserBillingAddress  = dict.object(forKey: "_login_user_billing_address") as! String
            districtID = dict.object(forKey: "_login_user_district_id") as? String ?? ""

            if let phoneVerified = dict.object(forKey: "_is_phone_verified") as? String, phoneVerified == "1" {
                self.isPhoneVerified = true
            } else {
                self.isPhoneVerified = false
            }
            name.text = loginUserName
            email.text = loginUserEmail
            phone.text = loginUserPhone
            deliveryAddress.text = loginUserDeliveryAddress
            //billingAddress.text = loginUserBillingAddress

            
        } else {
           //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    //MARK: Load basket for Gift Purchase

    func loadGiftOrderData() {
        
            for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)) {

                basketItems.append(basket)
                let data : Dictionary<String, AnyObject> = [
                    "item_id" : basket.itemId! as AnyObject,
                    "shop_id" : basket.shopId! as AnyObject,
                    "unit_price" : basket.unitPrice! as AnyObject,
                    "discount_percent" : basket.discountPercent! as AnyObject,
                    "name" : basket.name! as AnyObject,
                    "qty" : String(basket.qty!) as AnyObject,
                    "user_id" : basket.userId! as AnyObject,
                    "payment_trans_id" : "" as AnyObject,
                    "delivery_address" : deliveryAddress.text! as AnyObject,
                    //"billing_address" : billingAddress.text! as AnyObject,
                    "basket_item_attribute" : basket.selectedAttribute! as AnyObject,
                    "basket_item_attribute_id" : basket.selectedAttribute! as AnyObject,
                    "payment_method" : selectedPaymentOption as AnyObject,
                    "email" : email.text! as AnyObject,
                    "phone" : phone.text! as AnyObject,
                    "coupon_discount_amount" : couponAmount as AnyObject,
                    "flat_rate_shipping" : shippingRate as AnyObject,
                    "platform" : "IOS" as AnyObject,
                    "pickup_time" : pickUpTimeButton.titleLabel?.text as AnyObject,
                    "notes" : notesTextView!.text.trim() as AnyObject,
                    "pickup_date" : "Today" as AnyObject,
                    "vat_amount" : VAT_AMOUNT as AnyObject,
                    "net_amount" : totalCheckoutAmount as AnyObject,
                    "total_amount" : (totalCheckoutAmount + VAT_AMOUNT) as AnyObject,
                    "delivery_method": deliveryMethod as AnyObject,
                    "tip_amount" : "\(tipAmount)" as AnyObject,
                    "is_subscription": "0" as AnyObject,
                    "district": districtID as AnyObject,
                    "order_district": self.giftOrderDistrictID as AnyObject,
                    "recipient_address" : self.giftRecipientAddress as AnyObject,   //sending address of recipient of gift.
                    "recipient_name" : self.giftRecipientName as AnyObject,   //sending address of recipient of gift.
                    "recipient_mobile" : self.giftRecipientMobile as AnyObject,   //sending mobile number of recipient of gift.
                    "is_gift": "1" as AnyObject,
                ]
                transArray.append(data)
            }
        }
        
      
    //MARK: Load basket for Subscription Purchase
	func loadSubscriptionData() {
		let userID = self.isUserLoggedIn()
		guard let subscriptionItem = self.subscriptionItem, let options = self.subscription else {
			return
		}

		let data : Dictionary<String, AnyObject> = [
			"item_id" : subscriptionItem.itemId as AnyObject,
			"shop_id" : "1" as AnyObject,
			"unit_price" : subscriptionItem.itemPrice as AnyObject,
			"discount_percent" : subscriptionItem.discountPercent as AnyObject,
            "name" : "" as AnyObject,
			"user_id" : "\(userID)" as AnyObject,
			"payment_trans_id" : "" as AnyObject,
			"delivery_address" : deliveryAddress.text! as AnyObject,
			//"billing_address" : billingAddress.text! as AnyObject,
			"payment_method" : selectedPaymentOption as AnyObject,
			"email" : email.text! as AnyObject,
			"phone" : phone.text! as AnyObject,
			"coupon_discount_amount" : couponAmount as AnyObject,
			"flat_rate_shipping" : shippingRate as AnyObject,
			"platform" : "IOS" as AnyObject,
			"pickup_time" : pickUpTimeButton.titleLabel?.text as AnyObject,
			"notes" : notesTextView!.text.trim() as AnyObject,
			"pickup_date" : "Today" as AnyObject,
			"vat_amount" : VAT_AMOUNT as AnyObject,
			"net_amount" : totalCheckoutAmount as AnyObject,
			"total_amount" : (totalCheckoutAmount + VAT_AMOUNT) as AnyObject,
			//"delivery_method": deliveryMethod as AnyObject,
            "delivery_method": "subscription" as AnyObject,
            "tip_amount": "0" as AnyObject,
			"basket_item_attribute" : "" as AnyObject,
			"basket_item_attribute_id" : "" as AnyObject,
			"qty": "1" as AnyObject,
			"subscription_quantity" :  options["quantity"] as AnyObject,
			"subscription_frequency" : options["duration"]  as AnyObject,
			"subscription_grind_type" : options["grindType"] as AnyObject,
			"subscription_type": options["type"] as AnyObject,
			"is_subscription": "1" as AnyObject,
			"district": districtID as AnyObject,
            "pickup_location": "0" as AnyObject,
		]
		print("Data: \(data)")
		transArray.append(data)
	}

    //MARK: Load basket for Normal Purchase
    func loadBasket() {
        
        var pickupLocation = ""
        if let outlet = appDelegate.selectedOutletByUser, let ouletID = outlet.id {
                   pickupLocation = ouletID
            }
        
        
        for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)) {

            basketItems.append(basket)
            let data : Dictionary<String, AnyObject> = [
                "item_id" : basket.itemId! as AnyObject,
                "shop_id" : basket.shopId! as AnyObject,
                "unit_price" : basket.unitPrice! as AnyObject,
                "discount_percent" : basket.discountPercent! as AnyObject,
                "name" : basket.name! as AnyObject,
                "qty" : String(basket.qty!) as AnyObject,
                "user_id" : basket.userId! as AnyObject,
                "payment_trans_id" : "" as AnyObject,
                "delivery_address" : deliveryAddress.text! as AnyObject,
                //"billing_address" : billingAddress.text! as AnyObject,
                "basket_item_attribute" : basket.selectedAttribute! as AnyObject,
                "basket_item_attribute_id" : basket.selectedAttribute! as AnyObject,
                "payment_method" : selectedPaymentOption as AnyObject,
                "email" : email.text! as AnyObject,
                "phone" : phone.text! as AnyObject,
                "coupon_discount_amount" : couponAmount as AnyObject,
                "flat_rate_shipping" : shippingRate as AnyObject,
                "platform" : "IOS" as AnyObject,
                "pickup_time" : pickUpTimeButton.titleLabel?.text as AnyObject,
                "notes" : notesTextView!.text.trim() as AnyObject,
                "pickup_date" : "Today" as AnyObject,
                "vat_amount" : VAT_AMOUNT as AnyObject,
                "net_amount" : totalCheckoutAmount as AnyObject,
                "total_amount" : (totalCheckoutAmount + VAT_AMOUNT) as AnyObject,
				"delivery_method": deliveryMethod as AnyObject,
				"tip_amount" : "\(tipAmount)" as AnyObject,
				"is_subscription": "0" as AnyObject,
				"district": districtID as AnyObject,
				"order_district": districtID as AnyObject,
                "pickup_location" : pickupLocation as AnyObject, // Added as per request on 6th August

            ]
            transArray.append(data)
        }
    }
    
    func loadBasketPOC() {
        var pickupLocation = ""
        if let outlet = self.outlet, let ouletID = outlet.id {
            pickupLocation = ouletID
        }
        
        for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)) {

            basketItems.append(basket)
            let data : Dictionary<String, AnyObject> = [
                "item_id" : basket.itemId! as AnyObject,
                "shop_id" : basket.shopId! as AnyObject,
                "unit_price" : basket.unitPrice! as AnyObject,
                "discount_percent" : basket.discountPercent! as AnyObject,
                "name" : basket.name! as AnyObject,
                "qty" : String(basket.qty!) as AnyObject,
                "user_id" : basket.userId! as AnyObject,
                "payment_trans_id" : "" as AnyObject,
                "basket_item_attribute" : basket.selectedAttribute! as AnyObject,
                "basket_item_attribute_id" : basket.selectedAttribute! as AnyObject,
                "payment_method" : selectedPaymentOption as AnyObject,
                "email" : email.text! as AnyObject,
                "phone" : phone.text! as AnyObject,
                "coupon_discount_amount" : couponAmount as AnyObject,
                "flat_rate_shipping" : shippingRate as AnyObject,
                "platform" : "IOS" as AnyObject,
                "pickup_time" :  pickUpTimeButton.titleLabel?.text as AnyObject,
                "pickup_location" : pickupLocation as AnyObject,
                "notes" : notesTextView!.text.trim() as AnyObject,
                "pickup_date" : "Today" as AnyObject,
                "vat_amount" : VAT_AMOUNT as AnyObject,
                "net_amount" : totalCheckoutAmount as AnyObject,
                "total_amount" : (totalCheckoutAmount + VAT_AMOUNT) as AnyObject,
                "delivery_method": deliveryMethod as AnyObject,
                "tip_amount" : "\(tipAmount)" as AnyObject,
                "is_subscription": "0" as AnyObject,
                "district": districtID as AnyObject
                //"order_district": districtID as AnyObject
            ]
            transArray.append(data)
        }
    }
    
    //MARK: Payment API Calls
    func getAuthenticationTokenForPayment() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        let urlString = APIRouters.basePaymentURLString + APIRouters.getAuthenticationToken
        let params : Parameters = ["api_key": APIRouters.PaymentAPIKey]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .failure:
                    // Do whatever here
                    _ = EZLoadingActivity.hide()
                    return

                case .success(let data):
                    // First make sure you got back a dictionary if that's what you expect
                    guard let json = data as? [String : AnyObject] else {
                        print("Failed to get expected response from webserver.")
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    // Then make sure you get the actual key/value types you expect
                    guard let token = json["token"] as? String else {
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    print("This is Token =  \(token)")
                    //Step 2: Get Order Id.
                    //Multiplied by 100 to get Cents.
                    let paramsStep2 : Parameters = ["auth_token": token,"delivery_needed":"false","merchant_id":APIRouters.MerchantID,"amount_cents":String(((self.VAT_AMOUNT + self.totalCheckoutAmount).rounded(.up))*100),"currency":"EGP","merchant_order_id":self.orderID]
                    self.getOrderIDForPayment(params: paramsStep2)
                }
        }
    }
    
    func getOrderIDForPayment(params:Parameters){
        let urlString = APIRouters.basePaymentURLString + APIRouters.getOrderId
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .failure:
                    // Do whatever here
                    _ = EZLoadingActivity.hide()
                    return

                case .success(let data):

                    // First make sure you got back a dictionary if that's what you expect
                    guard let json = data as? [String : AnyObject] else {
                        print("Failed to get expected response from webserver.")
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    //Let's handle duplicate case first. This happens when we try to get order id again for same merchant order id
                    if let message = json["message"] as? String, message == "duplicate" {
                        print("Duplicate Case")
                        //Get Order now by calling orders api list.
                        let paramsStep5 : Parameters = ["auth_token": params["auth_token"] as Any,"merchant_id":APIRouters.MerchantID]
                        self.getOrderIdFromAcceptForDuplicateCase(params: paramsStep5)
                        return
                    }

                    // Then make sure you get the actual key/value types you expect
                    guard let OrderId = json["id"] else {
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    print("This is OrderId =  \(OrderId)")
                    //Step 3:
					let paramsStep3 : Parameters = ["auth_token": params["auth_token"] as Any,"order_id":String((OrderId as! Int)),"expiration":"3600","amount_cents":String(((self.VAT_AMOUNT +
                        self.totalCheckoutAmount).rounded(.up))*100),"currency":"EGP","integration_id":APIRouters.PaymentIntegrationId]
                    print(paramsStep3)
                    self.getPaymentKeyPerPayment(params: paramsStep3)
                }
        }
    }
    
    
    func getPaymentKeyPerPayment(params:Parameters){
        
        let urlString = APIRouters.basePaymentURLString + APIRouters.getPaymentKeyPerOrder
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .failure:
                    // Do whatever here
                    _ = EZLoadingActivity.hide()
                    return

                case .success(let data):
                    // First make sure you got back a dictionary if that's what you expect
                    guard let json = data as? [String : AnyObject] else {
                       print("Failed to get expected response from webserver.")
                        _ = EZLoadingActivity.hide()
                        return
                    }

                    // Then make sure you get the actual key/value types you expect
                    guard let KeyForPayment = json["token"] as? String else {
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    _ = EZLoadingActivity.hide()
					self.saveAcceptPaymentKey(paymentKey: KeyForPayment, params:params)
				print("This is KeyForPayment =  \(KeyForPayment)")
                //Step 4:
                //Launch Card Sdk From here
                self.LaunchCardSDKWithPaymentKey(pKey: KeyForPayment)
            }
        }
    }
    
    func getOrderIdFromAcceptForDuplicateCase(params:Parameters){

        /* Was trying this. This also does not work
        let url = APIRouters.basePaymentURLString + APIRouters.getOrderIDFromOrderList
        let param = ["auth_token":params["auth_token"] as! String,
                     "merchant_id":APIRouters.MerchantID]
        if let jsonData = try? JSONEncoder().encode(param) {

            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            Alamofire.request(request).responseJSON {
                (response) in
                debugPrint(response)
            }
        }
        return
       */

        
        
        
        let urlString = APIRouters.basePaymentURLString + APIRouters.getOrderIDFromOrderList
        Alamofire.request(urlString, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .failure:
                    // Do whatever here
                    _ = EZLoadingActivity.hide()
                return

                case .success(let data):
                    // First make sure you got back a dictionary if that's what you expect
                    guard let json = data as? [String : AnyObject] else {
                      print("Failed to get expected response from webserver.")
                       _ = EZLoadingActivity.hide()
                       return
                    }

                    self.AcceptOrderId = ""

                    if let ordersArray = json["results"] as? [[String : Any]] {
                       for order in ordersArray {
                            if(order["merchant_order_id"] as! String == "213"){
                                print(order["id"] as! String)
                                self.AcceptOrderId = order["id"] as! String
                            }
                        }
                    }
                    if(self.AcceptOrderId == "") {
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    print("Foung Accept order id = \(self.AcceptOrderId)")
                    let paramsStep3 : Parameters = ["auth_token": params["auth_token"] as Any,"order_id":self.AcceptOrderId,"expiration":"3600","amount_cents":String(((self.VAT_AMOUNT +
                        self.totalCheckoutAmount).rounded(.up))*100),"currency":"EGP","integration_id":APIRouters.PaymentIntegrationId]
                    
                    print(paramsStep3)
                    self.getPaymentKeyPerPayment(params: paramsStep3)
                }
            }
       }
    
    // Place your billing data here
    // billing data can not be empty
    // if empty, type in NA instead
    
    
    func isNecessaryInfoAvailableToProcessOnlineOrder() -> Bool{
        guard loginUserName != "" else {
                  _ = SweetAlert().showAlert(language.checkoutConfirmationTitle, subTitle:language.userInfoRequiredFirstName, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                      self.openEditProfile()
                  })
                  return false
              }
              guard loginUserLastName != "" else {
                  _ = SweetAlert().showAlert(language.checkoutConfirmationTitle, subTitle:language.userInfoRequiredLastName, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                      self.openEditProfile()
                  })
                  return false
              }
              guard loginUserEmail != "" else {
                  _ = SweetAlert().showAlert(language.checkoutConfirmationTitle, subTitle:language.userInfoRequiredEmail, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                      self.openEditProfile()
                  })
                  return false
              }
              guard loginUserPhone != "" else {
                  _ = SweetAlert().showAlert(language.checkoutConfirmationTitle, subTitle:language.userInfoRequiredPhoneNumber, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                      self.openEditProfile()
                  })
                  return false
              }
        
        return true
    }
    

    //MARK: Launches Accept Card payment SDK
	func LaunchCardSDKWithPaymentKey(pKey: String){
		let bData = ["apartment": "NA",
					 "email": loginUserEmail,
					 "floor": "NA",
					 "first_name": loginUserName,
					 "street": "NA",
					 "building": "NA",
					 "phone_number": loginUserPhone,
					 "shipping_method": "NA",
					 "postal_code": "NA",
					 "city": "NA",
					 "country": "NA",
					 "last_name": loginUserLastName,
					 "state": "NA"
		]

        do {
            let accept = AcceptSDK()
            accept.delegate = self
                  try accept.presentPayVC(vC: self, billingData: bData, paymentKey: pKey, saveCardDefault:
                  true, showSaveCard: true, showAlerts: false)
              } catch AcceptSDKError.MissingArgumentError(let errorMessage) {
                  print(errorMessage)
              }  catch let error {
                  print(error.localizedDescription)
              }
    }
    
	func showPaymentFailedMsg(message:String){
        self.updateTransactionStatus(transactionStatus: "5")
      _ = SweetAlert().showAlert(language.orderFailTitle, subTitle: message, style: AlertStyle.customImag(imageFile: "Logo"))
    }
    
    //MARK: ACCEPT PAYMENT SDK Delegates
    func userDidCancel() {
        print("User cancelled")
		self.showPaymentFailedMsg(message: language.paymentCancelledByUser)
    }
    
    func paymentAttemptFailed(_ error: AcceptSDKError, detailedDescription: String) {
        print("Payment attempt Failed \(detailedDescription)")
        self.showPaymentFailedMsg(message: language.orderFailedOnline)
    }
    
    func transactionRejected(_ payData: PayResponse) {
        print("Transaction Rejected \(payData)")
        self.showPaymentFailedMsg(message: language.orderFailedOnline)
    }
    
    func transactionAccepted(_ payData: PayResponse) {
        print("Transaction Accepted \(payData)")
        self.updateTransactionStatus(transactionStatus: "4")
    }
    
    func transactionAccepted(_ payData: PayResponse, savedCardData: SaveCardResponse) {
        print("Transaction Accepted with saved data \(payData) And card data \(savedCardData)")
        self.updateTransactionStatus(transactionStatus: "4")
    }
    
    func userDidCancel3dSecurePayment(_ pendingPayData: PayResponse) {
        print("Cancelled 3d secure payment \(pendingPayData)")
        self.showPaymentFailedMsg(message: language.paymentCancelledByUser)
    }

	//MARK: Update Transaction Status
    func updateTransactionStatus(transactionStatus : String) {
        _ = EZLoadingActivity.show("Updating transaction...", disableUI: true)
        let params : Parameters = ["id": self.orderID, "transaction_status":transactionStatus]
        do {
            let urlString = APIRouters.baseURLString + APIRouters.updateTransactionStatus
            try  Alamofire.request(urlString.asURL(), method: .post, parameters: params, encoding: JSONEncoding.default)
				.responseJSON { response in
				  print("Response for update transaction \(response)")
				_ = EZLoadingActivity.hide()

				switch response.result {
				case .failure:
					return

				case .success(let data):
					// First make sure you got back a dictionary if that's what you expect
					guard let json = data as? [String : AnyObject] else {
					   print("Failed to get expected response from webserver.")
						return
					}
					if json["status"] as? String == "success", transactionStatus == "4" {
						//_ = self.navigationController?.popToRootViewController(animated: true)
						_ = SweetAlert().showAlert(language.orderSuccessTitle, subTitle: language.orderSuccessOnlinePayment, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: " OK ") {
							(isOtherButton) -> Void in
							if isOtherButton == true {
								//Go back to root
								_ = self.navigationController?.popToRootViewController(animated: true)
							}
						}
					}
				}
            }
        } catch {
            print("")
        }
     }


	func saveAcceptPaymentKey(paymentKey:String, params:Parameters) {
		guard let acceptOrderId = params["order_id"] as? String else {
			return
		}
		let params = ["order_id": self.orderID as AnyObject, "accept_payment_key": "\(acceptOrderId):\(paymentKey)" as AnyObject]
		_ = EZLoadingActivity.show("Updating transaction...", disableUI: true)
		_ = Alamofire.request(APIRouters.SaveAccept(params)).responseObject {
			(response: DataResponse<StdResponse>) in
			_ = EZLoadingActivity.hide()
			print("Saved Accept Order Status: \(response.result.value!)")
		}
	}

    
    
    func animateContentScrollView() {
		moveOffScreen()
		self.contentScrollView?.frame.origin = self.defaultValue
		self.contentScrollView.alpha = 1.0
    }
    
    fileprivate func moveOffScreen() {
        contentScrollView?.frame.origin = CGPoint(x: (contentScrollView?.frame.origin.x)!, y: UIScreen.main.bounds.size.height)
//       //print((contentScrollView?.frame.origin.y)!)
//       //print(UIScreen.main.bounds.size.height)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

    
    
    func convert12To24HoursTime(timeString: String) -> String {
        var finalTime = ""
        let stime = timeString.components(separatedBy: " ")
        if stime[1] == "PM" {
            let time = stime[0].components(separatedBy: ":")
            let t = Int(time[0])
            let add12 = t! + 12
            finalTime = "\(add12):\(time[1])"
        } else {
            let time = stime[0].components(separatedBy: ":")
            let timeIn = Int(time[0])
            let t = String(format: "%02d", timeIn!)
            finalTime = "\(t):\(time[1])"
        }
        return finalTime
    }
    
    func dateAndTimeCalculation(){
        let workingHours = settingsDetailModel!.working_hours!
        let hoursArray = workingHours.components(separatedBy: ",")
        let currentDay = Date().dayOfWeek()!
        let currentHourArray = hoursArray.filter({ (day) -> Bool in
            if day.contains(currentDay){
                return true
            }
            return false
        })

		if currentHourArray.count > 0 {
            let currentDayTime = currentHourArray[0]
            let toTimeArray = currentDayTime.components(separatedBy: " - ")
            let removeDay = toTimeArray[0].components(separatedBy: ": ")
            if toTimeArray.count > 1{
                let todayString = getTodayDateAsString()
                let sTime = convert12To24HoursTime(timeString: removeDay[1])
                let eTime = convert12To24HoursTime(timeString: toTimeArray[1])
                let startDateTime = "\(todayString) \(sTime)"
                let endDateTime = "\(todayString) \(eTime)"

                openingDate = convertStringToDateFormat(dateString: startDateTime)
                closingDate = convertStringToDateFormat(dateString: endDateTime)

                let currentMilli = Date().millisecondsSince1970
                let closingMilli = closingDate!.millisecondsSince1970
                
                if currentMilli > closingMilli{
                    pickUpDayButton.setTitle("Tomorrow", for: .normal)
                }
                pickUpPickerView.maximumDate = closingDate

				let tdyWith30MinDate = addMinutesToCurrentTime(date: Date())
				let time = getDateInTimeFormat(date: tdyWith30MinDate)
				pickUpPickerView.minimumDate = tdyWith30MinDate

                pickUpTimeButton.setTitle(time, for: .normal)
            }
        }
    }

    func convertStringToDateFormat(dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let date = dateFormatter.date(from: dateString) else {
            fatalError()
        }
        return date
    }
    /*
    func convertTimeToDate(day: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        dateFormatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        let date = dateFormatter.date(from: day)
       //print("Start: \(date)") // Start: Optional(2000-01-01 19:00:00 +0000)

    }
    
    func convertUTCToLocalTime(date: Date) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        let stringFromDate = dateFormatter.string(from: date)
        let dateFromString = dateFormatter.date(from: stringFromDate)
        return dateFromString!
    }
    */
    func getTodayDateAsString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd"
        let myStringafd = formatter.string(from: yourDate!)
       //print(myStringafd)
        return myStringafd
    }
    /*
    func removeAMPM(timeString: String) -> String{
        let removeAM  = timeString.replacingOccurrences(of: " AM", with: "")
        let removePM  = removeAM.replacingOccurrences(of: " PM", with: "")
        return removePM
    }
    func seperateString(dateString: String) -> (Int, Int){
        let openTimeArray = dateString.components(separatedBy: ":")
        if openTimeArray.count > 1{
            return (Int(openTimeArray[0])!, Int(openTimeArray[1])!)
        }
        return (0,0)
    }
 */
}

extension UIScrollView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
//       //print("touchesBegan")
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
//       //print("touchesMoved")
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
//       //print("touchesEnded")
    }
    
}


extension CheckoutConfirmViewController {

	func isValidPickupDateTime() -> Bool {
		guard let time = self.pickUpTimeButton.title(for: .normal), let date = self.pickUpDayButton.title(for: .normal), let outlet = self.outlet, let openDays = outlet.open_days, let open_from = outlet.open_from, let open_to = outlet.open_to else {
			return false
		}
		var pickupDay = ""
		let tomorrowDate = self.getFutureDay(addDays: 1)
		let todayDate = self.getFutureDay(addDays: 0)
		if date == "Today" {
			pickupDay = todayDate.dayOfWeek() ?? ""
		} else {
			pickupDay = tomorrowDate.dayOfWeek() ?? ""
		}

		//Compare Time
		let selected = time.replacingOccurrences(of: " ", with: "")
		let f = DateFormatter()
		f.dateFormat = "HH:mm"

		let dateTime = f.date(from: selected)

		let openFrom = f.date(from: open_from)
		let openTo = f.date(from: open_to)

		let selectedTime = 60*Calendar.current.component(.hour, from: dateTime!) + Calendar.current.component(.minute, from: dateTime!)
		let openFromTime =  60*Calendar.current.component(.hour, from: openFrom!) + Calendar.current.component(.minute, from: openFrom!)
		let openToTime =  60*Calendar.current.component(.hour, from: openTo!) + Calendar.current.component(.minute, from: openTo!)

		return selectedTime >= openFromTime && selectedTime <= openToTime && openDays.contains(pickupDay)
	}

	//Gets future date by adding days to current date
	 func getFutureDay(addDays:Int) -> Date {
			var dayComponent    = DateComponents()
			dayComponent.day    = addDays // For removing one day (yesterday): -1
			let theCalendar     = Calendar.current
		 return theCalendar.date(byAdding: dayComponent, to: Date())!
	 }


	func checkPickUpTime() {
		guard let outlet = self.outlet, let openDays = outlet.open_days, let open_from = outlet.open_from, let open_to = outlet.open_to else {
			return
		}

		let todayString = getTodayDateAsString()
		let startDateTime = "\(todayString) \(open_from)"
		let endDateTime = "\(todayString) \(open_to)"

		openingDate = convertStringToDateFormat(dateString: startDateTime)
		closingDate = convertStringToDateFormat(dateString: endDateTime)

		let currentMilli = Date().millisecondsSince1970
		let closingMilli = closingDate!.millisecondsSince1970

		if currentMilli > closingMilli{
			pickUpDayButton.setTitle("Tomorrow", for: .normal)
		}
		pickUpPickerView.maximumDate = closingDate

		let tdyWith30MinDate = addMinutesToCurrentTime(date: Date())
		let time = getDateInTimeFormat(date: tdyWith30MinDate)
		pickUpPickerView.minimumDate = tdyWith30MinDate

		pickUpTimeButton.setTitle(time, for: .normal)
	}
}

extension CheckoutConfirmViewController: UITableViewDelegate, UITableViewDataSource {

	func showPopupView() {
		let count = self.getDistricts().count
		if count == 0 {
			return
		}
        popupView.isHidden = false
		self.view.bringSubviewToFront(popupView)
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

	func getDistricts() -> [NSDictionary] {
		let districtsData = UserDefaults.standard.object(forKey: "Districts") as? NSData
		if let districtsData = districtsData, let districts = NSKeyedUnarchiver.unarchiveObject(with: districtsData as Data) as? [NSDictionary] {
			return districts
		}
		return []
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return self.getDistricts().count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GrindTypeCell") as! GrindTypeCell

		let districts = self.getDistricts()
		let district = districts[indexPath.row]

		if let name = district.value(forKey: "name") as? String {
			cell.titleLabel.text = name
		}
		if selectedIndex == indexPath.row {
			cell.plusImage.image = UIImage(named: "ic_radio_check")
		} else {
			cell.plusImage.image = UIImage(named: "ic_radio_uncheck")
		}

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectRow(_:)))
		cell.addGestureRecognizer(tapGesture)

		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}

	@objc func didSelectRow(_ gesture:UITapGestureRecognizer) {
		guard let cell = gesture.view as? GrindTypeCell, let indexPath = self.tableView.indexPath(for: cell) else {
			return
		}
		self.selectedIndex = indexPath.row
		tableView.reloadData()
	}

    //MARK: Called when a district is chosen
	@IBAction func selectAction(_ sender: UIButton) {
		if selectedIndex == -1 {
			_ = SweetAlert().showAlert("30 North", subTitle: "Please choose a district.", style: AlertStyle.customImag(imageFile: "Logo"))
		 return
		}
		let districts = self.getDistricts()
		let item = districts[selectedIndex]
		self.selectedDistrict = item
		self.closeButton.sendActions(for: .touchUpInside)

		if let name = item.value(forKey:"name") as? String, let id = item.value(forKey:"id") as? String  {
			//self.areaButton.setTitle(name, for: .normal)

            if(self.isGiftingToSomeone == true){
                self.giftOrderDistrictID = id
                self.gotoPayment()

            }else{
                self.districtID = id

                //We will ask user this question only in case of non gifting. Otherwise directly go to payment option
			_ = SweetAlert().showAlert(language.saveDistrictToProfileTitle, subTitle: language.saveDistrictToProfile, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "YES", buttonColor: .clear, otherButtonTitle: "NO") { (isOk) in
				if isOk {
					self.updateUserInfo()
				} else {
					self.gotoPayment()
				}
			}
            }
            
            
		}
	}

	@IBAction func closeAction(_ sender: UIButton) {
		self.popupView.isHidden = true
	}

	func updateUserInfo() {

	   var params: [String: AnyObject] = [
		   "email"   : loginUserEmail as AnyObject,
		   "username": loginUserName as AnyObject,
		   "last_name": loginUserLastName as AnyObject,
		   "phone"   : loginUserPhone as AnyObject,
		   "birth_date"   : loginUserBirthDate as AnyObject,
		   "delivery_address" : loginUserDeliveryAddress as AnyObject,
		   "platformName": "ios" as AnyObject,
		   "is_phone_verified": isPhoneVerified as AnyObject
	   ]
	   if(self.selectedDistrict != nil){
		   params["district"] = self.selectedDistrict!.value(forKey: "id") as AnyObject
	   }else{
		   params["district"] = "" as AnyObject
	   }

	   _ = EZLoadingActivity.show("Loading...", disableUI: true)
	   _ = Alamofire.request(APIRouters.UpdateAppUser( loginUserId , params)).responseObject {
		   (response: DataResponse<StdResponse>) in

		   _ = EZLoadingActivity.hide()

		   if response.result.isSuccess {
			_ = SweetAlert().showAlert(language.profileUpdate, subTitle:language.profileDistrictUpdate ,style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
					self.gotoPayment()
					self.updateLocalProfile()
				})
		   } else {
			   if let res = response.result.value {
				   //EZLoadingActivity.hide()
				   _ = SweetAlert().showAlert(language.profileUpdate,subTitle:res.data ,style:AlertStyle.customImag(imageFile: "Logo"))
			   }
		   }
	   }
	}

	func updateLocalProfile() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        var myDict = NSDictionary(contentsOfFile: plistPath)
		myDict?.setValue(self.districtID, forKey: "_login_user_district_id")
		myDict!.write(toFile: plistPath, atomically: false)
    }
}

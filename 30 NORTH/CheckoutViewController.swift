//
//  CheckoutViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 08/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class CheckoutViewController: UIViewController {
    var allOutlets : [Outlet]?
	var shop:Shop?
    var totalAmount: Float = 0.0
	var outlet:Outlet? = nil
	var collectionCellHeight:CGFloat = 0.0
    
    var recipientViewHeight:CGFloat = 0.0


	let titleLabelFont = UIFont(name: AppFontName.bold, size: 18)
    let addressFont = UIFont(name: AppFontName.regular, size: 16)

	let titleLabelColor = UIColor.white

	let optionLabelFont = UIFont(name: AppFontName.regular, size: 18)
	let optionLabelColor = UIColor.white
    var placeholderAddressGift : String?
    var placeholderRecipientName : String?
    var placeholderRecipientMobile : String?
    var isGiftingToSomeone: Bool = false
    
    @IBOutlet weak var addressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var giftingCheckboxLableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var addressFieldGoldLineHeight: NSLayoutConstraint!




    
    @IBOutlet weak var recipientNameTextField: UITextField! {
        didSet {
            recipientNameTextField.backgroundColor = UIColor.clear
            recipientNameTextField.borderStyle = .none
            recipientNameTextField.font = self.addressFont
            recipientNameTextField.textColor = self.titleLabelColor
            recipientNameTextField.text = "RECIPIENT NAME"
        }
    }
    
    @IBOutlet weak var recipientAddressTextView: UITextView! {
           didSet {
               recipientAddressTextView.backgroundColor = UIColor.clear
               recipientAddressTextView.font = self.addressFont
               recipientAddressTextView.textColor = self.titleLabelColor
               recipientAddressTextView.text = "DELIVERY ADDRESS"
           }
       }
    
    @IBOutlet weak var recipientMobileNumber: UITextField! {
              didSet {
                      recipientMobileNumber.backgroundColor = UIColor.clear
                      recipientMobileNumber.borderStyle = .none
                      recipientMobileNumber.font = self.addressFont
                      recipientMobileNumber.textColor = self.titleLabelColor
                      recipientMobileNumber.keyboardType = .phonePad
                      recipientMobileNumber.text = "MOBILE NUMBER"
                  }
              }

	//Payment type options view
	@IBOutlet weak var paymentView: UIView!{
		didSet {
			paymentView.backgroundColor = UIColor.clear
		}
	}
    
    @IBOutlet weak var addressView: UIView!{
        didSet {
            addressView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var giftingRadioButtonView: UIView!{
           didSet {
               giftingRadioButtonView.backgroundColor = UIColor.clear
           }
       }
	@IBOutlet weak var paymentLabel: UILabel! {
		didSet {
			paymentLabel.text = "How would you like to pay?"
			self.configureTitleLabel(sender: paymentLabel)
		}
	}

	@IBOutlet var paymentButton: [UIButton]! {
		didSet {
			paymentButton.forEach { (button) in
				self.configureCheckbox(sender: button, action: #selector(paymentTypeAction(_:)))
			}
		}
	}
    
    @IBOutlet var isGiftingButton: [UIButton]! {
        didSet {
            isGiftingButton.forEach { (button) in
                self.configureCheckbox(sender: button, action: #selector(isGiftingAction(_:)))
            }
        }
    }
	@IBOutlet var paymentTypeLabel: [UILabel]!{
		didSet {
			paymentTypeLabel.forEach { (label) in
				self.configureOptionLabel(sender: label)
			}
		}
	}

	//Delivery options view
	@IBOutlet weak var deliveryView: UIView!{
		didSet {
			deliveryView.backgroundColor = UIColor.black
		}
	}
	@IBOutlet weak var deliveryLabel: UILabel!{
		didSet {
			deliveryLabel.text = "Should we deliver this order?"
			self.configureTitleLabel(sender: deliveryLabel)
		}
	}

	@IBOutlet var deliveryButton: [UIButton]!{
		didSet{
			deliveryButton.forEach { (button) in
				self.configureCheckbox(sender: button, action: #selector(deliveryTypeAction(_:)))
			}
		}
	}
	@IBOutlet var deliveryTypeLabel: [UILabel]! {
		didSet {
			deliveryTypeLabel.forEach { (label) in
				self.configureOptionLabel(sender: label)
			}
		}
	}

	//Pickup place options view
	@IBOutlet weak var pickupView: UIView!{
		didSet {
			pickupView.backgroundColor = UIColor.clear
		}
	}
	@IBOutlet weak var pickupOrderLabel: UILabel!{
		didSet {
			pickupOrderLabel.text = "Where do you want to pickup your order?"
			self.configureTitleLabel(sender: pickupOrderLabel)
		}
	}
	@IBOutlet weak var collectionView: UICollectionView!{
		didSet {
			collectionView.backgroundColor = .clear
			collectionView.dataSource = self
			collectionView.delegate = self

			collectionView.allowsSelection = true
			collectionView.allowsMultipleSelection = false

			collectionView.showsVerticalScrollIndicator = false
			collectionView.showsHorizontalScrollIndicator = false

			let flowLayout = UICollectionViewFlowLayout()
			flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
			collectionView.setCollectionViewLayout(flowLayout, animated: true)
		}
	}

	//Discount View
	@IBOutlet weak var discountView: UIView!{
		didSet {
			discountView.backgroundColor = UIColor.black
		}
	}

	@IBOutlet weak var discountLabel: UILabel! {
		didSet {
			discountLabel.text = "Got a discount code?"
			self.configureTitleLabel(sender: discountLabel)
		}
	}

	@IBOutlet weak var discountField: UITextField! {
		didSet {
			discountField.backgroundColor = UIColor.clear
			discountField.borderStyle = .none
			discountField.font = self.titleLabelFont
			discountField.textColor = self.titleLabelColor
		}
	}
	@IBOutlet weak var lineView: UIView! {
		didSet {
			lineView.backgroundColor = UIColor.gold
			lineView.clipsToBounds = true
		}
	}

	@IBOutlet weak var tipView: UIView!{
		didSet {
			tipView.backgroundColor = UIColor.clear
		}
	}
	@IBOutlet weak var tipLabel: UILabel!{
		didSet {
			tipLabel.text = "Tip your barista"
            tipLabel.font = self.addressFont
			self.configureTitleLabel(sender: tipLabel)
		}
	}
    
    @IBOutlet weak var giftingLabel: UILabel!{
        didSet {
            self.configureTitleLabel(sender: giftingLabel)
        }
    }
	@IBOutlet weak var tipField: UITextField!{
		didSet {
			tipField.borderStyle = .roundedRect
			tipField.font = self.titleLabelFont
			tipField.textColor = UIColor.black
			tipField.delegate = self
			tipField.keyboardType = .decimalPad
		}
	}

	//Proceed to next step button
	@IBOutlet weak var proceedButton: UIButton!{
		didSet {
			proceedButton.layer.cornerRadius = 3.0
            proceedButton.backgroundColor = UIColor.gold
			proceedButton.clipsToBounds = true
			proceedButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 15)
			proceedButton.setTitle("PROCEED", for: .normal)
			proceedButton.setTitleColor(UIColor.white, for: .normal)
		}
	}

	//View Life Cycle
	override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        //By default keep it hidden
        if(self.isGiftingToSomeone == false){
        addressViewHeight.constant = 0
        giftingCheckboxLableViewHeight.constant = 0
        addressView.isHidden = true
        giftingRadioButtonView.isHidden = true
        self.isGiftingButton[0].backgroundColor = .clear
        }else{
            addressViewHeight.constant = 137
            giftingCheckboxLableViewHeight.constant = 40
            addressView.isHidden = false
            giftingRadioButtonView.isHidden = false
            self.isGiftingButton[0].backgroundColor = .gold
        }
        // Do any additional setup after loading the view.
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		IQKeyboardManager.shared.enable = true
	}
    
    
    @objc func showNoCashMethodAvailable(_ sender : UIButton) {
        if(self.isGiftingToSomeone == true){
            _ = SweetAlert().showAlert("Sorry", subTitle: "Cash payment is not available in case of gift purchase." ,style:AlertStyle.customImag(imageFile: "Logo"))

        }else{
            _ = SweetAlert().showAlert("Sorry", subTitle: "Cash payment is not available at the moment. Please choose Online payment" ,style:AlertStyle.customImag(imageFile: "Logo"))
        }
    }
    
    @objc func showNoOnlinehMethodAvailable(_ sender : UIButton) {
        _ = SweetAlert().showAlert("Sorry", subTitle: "Online payment is not available at the moment. Please choose Cash payment" ,style:AlertStyle.customImag(imageFile: "Logo"))
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
		changePickupViewHeight()
		if let settingsDetail = settingsDetailModel{
			self.showHideTipView(hide: settingsDetail.is_tipping_enabled != "1")

			for (index, label) in self.paymentTypeLabel.enumerated() {
				let button = self.paymentButton[index]

				if label.text?.lowercased() == "cash" {
					button.isEnabled = settingsDetail.cash_pickup_enabled != "0"
                    
                    //Forcefully disable this if Gifting to someone. Since gifts can be given by online payments only
                    if(self.isGiftingToSomeone == true){
                        button.isEnabled = false
                    }
                    
                    //This will give user and information that this payment method is not available.
                    if(button.isEnabled == false){
                        button.removeTarget(self, action: #selector(self.paymentTypeAction(_:)), for: UIControl.Event.touchUpInside)
                        button.addTarget(self, action: #selector(self.showNoCashMethodAvailable(_:)), for: UIControl.Event.touchUpInside)
                        button.isEnabled = true
                    }
				} else if label.text?.lowercased() == "online" {
					button.isEnabled = settingsDetail.online_payment_enabled != "0"

                    //This will give user and information that this payment method is not available.
                    if(button.isEnabled == false){
                        button.removeTarget(self, action: #selector(self.paymentTypeAction(_:)), for: UIControl.Event.touchUpInside)
                        button.addTarget(self, action: #selector(self.showNoOnlinehMethodAvailable(_:)), for: UIControl.Event.touchUpInside)
                        button.isEnabled = true
                        button.backgroundColor = .clear
                    }
                    
				}
			}
			for (index, label) in self.deliveryTypeLabel.enumerated() {
				let button = self.deliveryButton[index]
				if label.text?.lowercased() == "delivery" {
					button.isEnabled = settingsDetail.delivery_enabled != "0"
				}
				if label.text?.lowercased() == "pickup" {
					button.isEnabled = settingsDetail.pickup_enabled != "0"
				}
			}
		} else {
			self.showHideTipView(hide: true)
		}
        
        //Forcefully Choosing online payment  if Gifting to someone. Since gifts can be given by online payments only
        if(self.isGiftingToSomeone == true){
            self.paymentButton[0].backgroundColor = .clear
            self.paymentButton[1].backgroundColor = .gold
        }
        
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		IQKeyboardManager.shared.enable = false
	}

	private func configureCheckbox(sender:UIButton, action:Selector) {
		sender.layer.cornerRadius = sender.frame.width/2
		sender.layer.borderColor = UIColor.gold.cgColor
		sender.layer.borderWidth = 1.0
		sender.clipsToBounds = true

		sender.setTitle("", for: .normal)
		sender.addTarget(self, action: action, for: .touchUpInside)
	}

	private func configureOptionLabel(sender:UILabel) {
		sender.font = self.optionLabelFont
		sender.textColor = self.optionLabelColor
	}

	private func configureTitleLabel(sender:UILabel) {
		sender.font = self.titleLabelFont
		sender.textColor = self.titleLabelColor
	}
	
	func showHideTipView(hide:Bool) {

		let tipViewHeightConstraint = self.tipView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "TipViewHeightConstraint"
		}
		tipViewHeightConstraint?.constant = hide ? 0 : 55
		self.tipView.isHidden = hide
	}

	func changePickupViewHeight() {
		//CollectionViewHeightConstraint
		let heightConstraint = self.pickupView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "PickupViewHeightConstraint"
		}
        
//        if(appDelegate.selectedOutletByUser != nil){
//            self.hidePickupView()
//            return
//        }
        
		if let deliveryType = selectedDeliveryType(), deliveryType == "pickup"  {
			let screenRect = UIScreen.main.bounds
			let outlets = self.outlets()
			var height = (CGFloat(ceil(Double(outlets.count) / 2.0)) * self.collectionCellHeight) + 50
			var space = ((screenRect.height - self.deliveryView.frame.maxY) - (self.discountView.frame.height + 30.0))
			if space < 10 {
				space = ((screenRect.height - self.discountView.frame.maxY) - 30.0)
			}
			if height > space {
				height = space
			}
            
            if(height == 70){
                height = height + 20 // This is for single line height issue
            }
			heightConstraint?.constant = height - 20
			self.discountView.backgroundColor = .black
            self.collectionView.reloadData()

		} else {
			self.hidePickupView()
		}
	}
	func hidePickupView() {
		let heightConstraint = self.pickupView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "PickupViewHeightConstraint"
		}
		heightConstraint?.constant = 0
		self.discountView.backgroundColor = .clear
		self.outlet = nil
		self.collectionView.reloadData()
	}

	//Outlet Action Methods
	@IBAction func proceedAction(_ sender: UIButton) {
        
        if(self.isGiftingToSomeone == true){
            if(self.recipientNameTextField.text == "" || self.recipientNameTextField.text == "RECIPIENT NAME"){
                _ = SweetAlert().showAlert("", subTitle: "Tell us the name of the person that's getting this gift", style: AlertStyle.customImag(imageFile: "Logo"))
                    return
            } else if(self.recipientAddressTextView.text == "" || self.recipientAddressTextView.text == "DELIVERY ADDRESS"){
                if let delivery = selectedDeliveryType() {
                    if delivery == "pickup", self.outlet == nil {
                        if(appDelegate.selectedOutletByUser == nil){
                                           _ = SweetAlert().showAlert("Pickup", subTitle: "Where do you want to pickup your order?", style: AlertStyle.customImag(imageFile: "Logo"))
                                           return
                                       }else{
                                           //Let's make self.outlet == user chosen outlet
                                           self.outlet = appDelegate.selectedOutletByUser
                                       }
                    } else if delivery == "delivery" {
                        _ = SweetAlert().showAlert("", subTitle: "Tell us where this should be delivered", style: AlertStyle.customImag(imageFile: "Logo"))
                        return
                    }
                }
            }
            if(self.recipientMobileNumber.text == "" || self.recipientMobileNumber.text == "MOBILE NUMBER"){
                _ = SweetAlert().showAlert("", subTitle: "Tell us the mobile number of the person that's getting this gift so we can let them know", style: AlertStyle.customImag(imageFile: "Logo"))
                    return
            }
        }
        
        
		guard let outlet = self.outlet, let notes = outlet.notes, notes != "" else {
			self.proceedNow()
			return
		}

		_ = SweetAlert().showAlert("", subTitle: notes, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: language.btnOK) { [unowned self] (isOk) in
			if isOk {
				print("Ok pressed")
				self.proceedNow()
			}
		}
	}

	func proceedNow() {
		guard let payment = selectedPaymentType() else {
			_ = SweetAlert().showAlert("Payment Method", subTitle: "How would you like to pay?", style: AlertStyle.customImag(imageFile: "Logo"))
			return
		}
		if let delivery = selectedDeliveryType() {
			if delivery == "pickup", self.outlet == nil {
                
                if(appDelegate.selectedOutletByUser == nil){
                    _ = SweetAlert().showAlert("Pickup", subTitle: "Where do you want to pickup your order?", style: AlertStyle.customImag(imageFile: "Logo"))
                    return
                }else{
                    //Let's make self.outlet == user chosen outlet
                    self.outlet = appDelegate.selectedOutletByUser
                }
                
				
			} else if delivery == "delivery" {
				self.outlet = nil
			}
		} else {
			_ = SweetAlert().showAlert("Delivery", subTitle: "Should we deliver this order?", style: AlertStyle.customImag(imageFile: "Logo"))
			return
		}

		//Payment Method
		var paymentMethod = ""
		if payment == "cash", selectedDeliveryType() == "delivery" {
			paymentMethod = "cod"
		} else if payment == "cash", selectedDeliveryType() == "pickup" {
			paymentMethod = "poc"
		} else {
			paymentMethod = payment
		}

		if let text = self.discountField.text?.trim(), text.count > 0 {
			self.applyCoupon(couponCode: text, payment: paymentMethod, outlet: self.outlet)
		} else {
			self.proceedWithoutDiscount(payment: paymentMethod, outlet: self.outlet)
		}
	}

	@objc func paymentTypeAction(_ sender: UIButton) {
		self.paymentButton.forEach { (button) in
			button.backgroundColor = .clear
		}
		sender.backgroundColor = UIColor.gold
	}
    
    @objc func isGiftingAction(_ sender: UIButton) {
        //Not doing anything here for now. Previous page decides what is show here and radio button is not tappable.
        return
        
        if(sender.backgroundColor == UIColor.gold){
            sender.backgroundColor = .clear
            addressViewHeight.constant = 0
            giftingCheckboxLableViewHeight.constant = 0
            addressView.isHidden = true
            self.isGiftingToSomeone = false
            giftingRadioButtonView.isHidden = false


        }else{
            addressView.isHidden = false
            addressViewHeight.constant = 137
            giftingCheckboxLableViewHeight.constant = 40
            sender.backgroundColor = .gold
            self.isGiftingToSomeone = true
            giftingRadioButtonView.isHidden = true


        }
        
    }

    //MARK: Delivery Type Radio Buttons Action
	@objc func deliveryTypeAction(_ sender: UIButton) {
		self.deliveryButton.forEach { (button) in
			button.backgroundColor = .clear
		}
		sender.backgroundColor = UIColor.gold

		if let deliveryType = selectedDeliveryType(), deliveryType == "pickup"  {
			self.collectionView.reloadData()
            self.changePickupViewHeight()
            //if gifting to someone and also order is of type pickup. lets hide address for the recipient
            if(self.isGiftingToSomeone == true){
                self.addressFieldHeight.constant = 0
                self.addressFieldGoldLineHeight.constant = 0
                self.addressViewHeight.constant = 137 - 55 //55 is height of address field
            }
            
		} else {
			self.hidePickupView()
            if(self.isGiftingToSomeone == true){
                self.addressFieldHeight.constant = 55
                self.addressFieldGoldLineHeight.constant = 0.5
            self.addressViewHeight.constant = 137
            }
		}
	}

	func proceedWithoutDiscount(payment:String, outlet:Outlet?) {

		weak var ConfirmViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CheckoutConfirm") as? CheckoutConfirmViewController
		ConfirmViewController?.subTotalAmount = self.totalAmount
		if let tip = self.tipField.text {
			ConfirmViewController?.tipAmount = tip.floatValue
		} else {
			ConfirmViewController?.tipAmount = 0
		}
		ConfirmViewController?.outlet = outlet
		ConfirmViewController?.selectedPaymentOption = payment
		ConfirmViewController?.deliveryMethod = selectedDeliveryType() ?? ""
		ConfirmViewController?.checkoutCurrencySymbol = settingsDetailModel!.currency_symbol!
		ConfirmViewController?.checkoutCurrencyShortForm = settingsDetailModel!.currency_short_form!

		ConfirmViewController?.selectedShopId = 1
		ConfirmViewController?.couponName = ""
		ConfirmViewController?.couponAmount = ""
        ConfirmViewController?.isGiftingToSomeone = self.isGiftingToSomeone
        ConfirmViewController?.giftRecipientName = self.recipientNameTextField.text
        ConfirmViewController?.giftRecipientAddress = self.recipientAddressTextView.text
        ConfirmViewController?.giftRecipientMobile = self.recipientMobileNumber.text
		self.navigationController?.pushViewController(ConfirmViewController!, animated: true)
	}

	func applyCoupon(couponCode:String, payment:String, outlet:Outlet?) {
		let params: [String : AnyObject] = [
			"shop_id" : 1 as AnyObject,
			"coupon_code" : couponCode as AnyObject
		]
		_ = EZLoadingActivity.show("Loading...", disableUI: true)
		_ = Alamofire.request(APIRouters.CouponSearch(1, params)).responseObject { (response: DataResponse<Coupon>) in

			_ = EZLoadingActivity.hide()

			if response.result.isSuccess, let coupon = response.result.value, coupon.couponName != "" {
				weak var ConfirmViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CheckoutConfirm") as? CheckoutConfirmViewController
				ConfirmViewController?.subTotalAmount = self.totalAmount
				if let tip = self.tipField.text as NSString? {
					ConfirmViewController?.tipAmount = tip.floatValue
				} else {
					ConfirmViewController?.tipAmount = 0
				}
				ConfirmViewController?.selectedPaymentOption = payment
				ConfirmViewController?.deliveryMethod = self.selectedDeliveryType() ?? ""
				ConfirmViewController?.outlet = outlet
				ConfirmViewController?.checkoutCurrencySymbol = settingsDetailModel!.currency_symbol!
				ConfirmViewController?.checkoutCurrencyShortForm = settingsDetailModel!.currency_short_form!
				ConfirmViewController?.selectedShopId = 1
				ConfirmViewController?.couponName = coupon.couponName!
				ConfirmViewController?.couponAmount = coupon.couponAmount!
                ConfirmViewController?.isGiftingToSomeone = self.isGiftingToSomeone
                ConfirmViewController?.giftRecipientName = self.recipientNameTextField.text
                ConfirmViewController?.giftRecipientAddress = self.recipientAddressTextView.text
                ConfirmViewController?.giftRecipientMobile = self.recipientMobileNumber.text


				self.navigationController?.pushViewController(ConfirmViewController!, animated: true)
			} else {
			   _ = SweetAlert().showAlert(language.couponDiscountTitle, subTitle: language.couponInvalid, style: AlertStyle.customImag(imageFile: "Logo"))
			}
		}
    }

	func selectedPaymentType() -> String? {
		let paymentIndex = self.paymentButton.firstIndex { (button) -> Bool in
			return button.backgroundColor == UIColor.gold
		}

		if let index = paymentIndex {
			let paymentTypeLabel = self.paymentTypeLabel[index]
			return paymentTypeLabel.text?.lowercased()
		}
		return nil
	}

	func selectedDeliveryType() -> String? {
		let deliveryIndex = self.deliveryButton.firstIndex { (button) -> Bool in
			return button.backgroundColor == UIColor.gold
		}
		if let index = deliveryIndex {
			let deliveryTypeLabel = self.deliveryTypeLabel[index]
			return deliveryTypeLabel.text?.lowercased()
		}
		return nil
	}
}

extension CheckoutViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let screenRect = collectionView.frame//UIScreen.main.bounds
		let margin:CGFloat = 0
		let width = ((screenRect.width - margin)/2)

		let outlets = self.outlets()
		let outlet = outlets[indexPath.row]

		var height = outlet.name!.height(withConstrainedWidth: (width-50.0), font: self.optionLabelFont!)
		if height < CGFloat(40.0) {
			height = 40.0
		}
		if height > collectionCellHeight {
			collectionCellHeight = height
		}
		let size = CGSize(width: width, height: height)
        return size
    }

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets.zero
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}

extension CheckoutViewController : UICollectionViewDelegate, UICollectionViewDataSource {

	func outlets() -> [Outlet] {
		guard let outlets = self.allOutlets else {
			return []
		}

		return outlets.filter { (outlet) -> Bool in
			if let pickup = outlet.has_pickup, pickup == 1, let show = outlet.show_in_list, show == 1, let isOpen = outlet.is_open, isOpen == 1 {
				return true
			}
            //For Testing
//            if let pickup = outlet.has_pickup, pickup == 1{
//                return true
//            }
			return false
		}
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let outlets = self.outlets()
		return outlets.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickupPlaceCell", for: indexPath) as! PickupPlaceCell

		let outlets = self.outlets()
		let outlet = outlets[indexPath.row]
        
        if(appDelegate.selectedOutletByUser != nil){
          
            if(appDelegate.selectedOutletByUser?.id == outlet.id){
                cell.isSelected = true
                cell.isUserInteractionEnabled = false
                cell.placeLabel.textColor = .gray
                cell.checkbox.backgroundColor = UIColor.gray
                cell.checkbox.layer.borderColor = UIColor.gray.cgColor
            }else{
                cell.isUserInteractionEnabled = false
                cell.placeLabel.textColor = .north30Grey
                cell.checkbox.layer.borderColor = UIColor.gray.cgColor

            }
        }
		cell.placeLabel?.text = outlet.name

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let cell = collectionView.cellForItem(at: indexPath)
		cell?.isSelected = true

		let outlets = self.outlets()
		let outlet = outlets[indexPath.row]
		self.outlet = outlet
	}
}

extension CheckoutViewController : UITextFieldDelegate {
	  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == recipientNameTextField){
            placeholderRecipientName = textField.text

        }else if(textField == recipientMobileNumber){
            if textField.text?.count == 0 && string == "0" {
                return false
            }
            placeholderRecipientMobile = textField.text
            return string == string.filter("0123456789.".contains)
        }else{
            if textField.text?.count == 0 && string == "0" {
                return false
            }
            return string == string.filter("0123456789.".contains)
        }
        
        return true

	}
    
     func textFieldDidBeginEditing(_ textField: UITextField){
        if(textField == recipientNameTextField){
            if textField.text == "RECIPIENT NAME" {
            textField.text = ""
            }
        }else if(textField == recipientMobileNumber){
            if textField.text == "MOBILE NUMBER" {
            textField.text = ""
            }
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == recipientNameTextField){
            if textField.text!.isEmpty {
            textField.text = "RECIPIENT NAME"
            placeholderRecipientName = ""
            }}else if(textField == recipientMobileNumber){
            if textField.text!.isEmpty {
            textField.text = "MOBILE NUMBER"
            placeholderRecipientMobile = ""
                }}
            else {
            placeholderRecipientName = textField.text
            }
        }
}

extension CheckoutViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }

}


extension CheckoutViewController : UITextViewDelegate {
    
   func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "DELIVERY ADDRESS" {
    textView.text = ""
    textView.textColor = .white
    }
    }
      
    
    func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
    textView.text = "DELIVERY ADDRESS"
    textView.textColor = UIColor.white
    placeholderAddressGift = ""
    } else {
    placeholderAddressGift = textView.text
    }
    }
    
    func textViewDidChange(_ textView: UITextView) {
    placeholderAddressGift = textView.text
    }
}

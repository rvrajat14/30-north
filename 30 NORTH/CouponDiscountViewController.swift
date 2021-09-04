//
//  CouponDiscountViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 20/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class CouponDiscountViewController : UIViewController {
    
    @IBOutlet weak var applyCoupon: UIButton!
    @IBOutlet weak var withoutCoupon: UIButton!
    @IBOutlet weak var couponCode: UITextField!
    @IBOutlet weak var couponMessage: UILabel!
    
    var selectedShopId:Int = 1
    var totalAmount: Float = 0.0

	var outlet:Outlet? = nil
    var selectedPaymentOption: String = ""
    var selectedShopArrayIndex: Int!
    var checkoutCurrencySymbol: String = ""
    var checkoutCurrencyShortForm: String = ""

    @IBOutlet var contentView: UIView!
    var defaultValue: CGPoint!

	override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground


        self.hideKeyboardWhenTappedAround()
        couponMessage.text = language.couponMessageLabel
        
        applyCoupon.alpha = 0
        withoutCoupon.alpha = 0
        couponCode.alpha = 0
        couponMessage.alpha = 0
        
        defaultValue = contentView?.frame.origin
        animateContentView()
        
        //skiping discount screen
//        skipDiscountScreen()
    }
    
    
    @IBAction func doWithCoupon(_ sender: AnyObject) {
        
        if(couponCode.text != "") {
            let params: [String : AnyObject] = [
                "shop_id" : selectedShopId as AnyObject,
                "coupon_code" : couponCode.text! as AnyObject
            ]
            
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            _ = Alamofire.request(APIRouters.CouponSearch(selectedShopId, params)).responseObject{
                (response: DataResponse<Coupon>) in
                
                _ = EZLoadingActivity.hide()
                
                if response.result.isSuccess {
                    if let coupon = response.result.value {
                        
                        if(coupon.couponName != "") {
                            weak var ConfirmViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CheckoutConfirm") as? CheckoutConfirmViewController
                            ConfirmViewController?.subTotalAmount = self.totalAmount
                            ConfirmViewController?.selectedPaymentOption = self.selectedPaymentOption
							ConfirmViewController?.outlet = self.outlet
                            ConfirmViewController?.selectedShopArrayIndex = self.selectedShopArrayIndex
                            ConfirmViewController?.checkoutCurrencySymbol = settingsDetailModel!.currency_symbol!
                            ConfirmViewController?.checkoutCurrencyShortForm = settingsDetailModel!.currency_short_form!
                            ConfirmViewController?.selectedShopId = 1
                            ConfirmViewController?.couponName = coupon.couponName!
                            ConfirmViewController?.couponAmount = coupon.couponAmount!
//                            ConfirmViewController?.settingsDetailModel = settingsDetailModel
                            self.navigationController?.pushViewController(ConfirmViewController!, animated: true)
                            
                            self.updateBackButton()
                        } else {
                             _ = SweetAlert().showAlert(language.couponDiscountTitle, subTitle: language.couponInvalid, style: AlertStyle.customImag(imageFile: "Logo"))
                        }
                        
                    }
                } else {
                   //print(response)
                }
            }
        } else {
            _ = SweetAlert().showAlert(language.couponDiscountTitle, subTitle: language.couponEmpty, style: AlertStyle.customImag(imageFile: "Logo"))
        }
    }
    
    @IBAction func doWithoutCoupon(_ sender: AnyObject) {
        weak var ConfirmViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CheckoutConfirm") as? CheckoutConfirmViewController
        ConfirmViewController?.subTotalAmount = self.totalAmount
		ConfirmViewController?.outlet = self.outlet
        ConfirmViewController?.selectedPaymentOption = self.selectedPaymentOption
        ConfirmViewController?.selectedShopArrayIndex = self.selectedShopArrayIndex
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
        
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func animateContentView() {
        
        moveOffScreen()
            self.contentView?.frame.origin = self.defaultValue
            self.applyCoupon.alpha = 1.0
            self.withoutCoupon.alpha = 1.0
            self.couponCode.alpha = 1.0
            self.couponMessage.alpha = 1.0
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
}

//
//  PaymentOptionsViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 5/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class PaymentOptionsViewController : UIViewController {
    
//    var selectedShopArrayIndex: Int!
    var totalAmount: Float = 0.0
    var currencySymbol: String = ""
    var currencyShortForm: String = ""
//    var selectedShopId: Int!
//    var shopsData = [ShopModel]()
    var pickerData = [String]()
    var selectedIndex = -1
    var defaultValue: CGPoint!
    
    
    @IBOutlet var contentView: UIScrollView!
    @IBOutlet var myPickerView : UIPickerView!
    @IBOutlet weak var pickerView: UIView!

    @IBOutlet weak var paypalView: UIView!
    @IBOutlet weak var paypalViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var CODView: UIView!
    @IBOutlet weak var CODViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var StripeView: UIView!
    @IBOutlet weak var StripeViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var BTView: UIView!
    @IBOutlet weak var BTViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var POCView: UIView!
    @IBOutlet weak var payonCashViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var btnStripeGo: UIButton!
    
    @IBOutlet weak var btnCODGo: UIButton!
    
    @IBOutlet weak var btnBankGo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground


        if let _ = settingsDetailModel{
            currencySymbol = settingsDetailModel!.currency_symbol!
            currencyShortForm = settingsDetailModel!.currency_short_form!
        }else{
            appDelegate.doSettingsAPI()
            return
        }

        //if(ShopsListModel.sharedManager.shops[selectedShopArrayIndex].paypalEnabled == "0") {
            paypalView.isHidden = true
            paypalViewHeight.constant = 0
        //}
//        self.shopsData = ShopsListModel.sharedManager.shops
        self.pickerData = [shopModel!.name]
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        
//        if selectedShopArrayIndex == nil {
//            var i=0
//            for shop in ShopsListModel.sharedManager.shops {
//
//                if Int(shop.id)! == selectedShopId {
//                    selectedShopArrayIndex = i
//                    break
//                }
//
//                i += 1
//            }
//        }
        
        
        CODView.alpha = 0
        POCView.alpha = 0
        BTView.alpha = 0
        StripeView.alpha = 0

//        doSettingsAPI()
        self.loadPaymentView()

        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    func loadPaymentView(){
        
        if let settingsDetail = settingsDetailModel{
            
            if(settingsDetail.stripe_enabled! == "0") {
                StripeView.isHidden = true
                StripeViewHeight.constant = 0
                StripeView.alpha = 0

            }else{
                StripeView.alpha = 1
            }
            
            if(settingsDetail.cash_pickup_enabled! == "0") {
                POCView.isHidden = true
                payonCashViewHeight.constant = 0
                POCView.alpha = 0
            }else{
                POCView.alpha = 1
            }
            
            
            if(settingsDetail.cod_enabled! == "0") {
                CODView.isHidden = true
                CODViewHeight.constant = 0
                CODView.alpha = 0
            }else{
                CODView.alpha = 1
            }
            
//            if(ShopsListModel.sharedManager.shops[selectedShopArrayIndex].bankTransferEnabled == "0") {

            if(settingsDetail.banktransfer_enabled! == "0") {
                BTView.isHidden = true
                BTViewHeight.constant = 0
                
                BTView.alpha = 0
            }else{
                BTView.alpha = 1
            }
            
            
//            if(ShopsListModel.sharedManager.shops[selectedShopArrayIndex].bankTransferEnabled == "0" && (ShopsListModel.sharedManager.shops[selectedShopArrayIndex].codEnabled == "0") && (ShopsListModel.sharedManager.shops[selectedShopArrayIndex].cashPickupEnabled != "0") && (ShopsListModel.sharedManager.shops[selectedShopArrayIndex].stripeEnabled == "0")) {
            
            if((settingsDetail.banktransfer_enabled! == "0") && (settingsDetail.cod_enabled! == "0") && (settingsDetail.cash_pickup_enabled! != "0") && (settingsDetail.stripe_enabled! == "0")) {
                self.pickerView.isHidden = false
                self.pickerView.alpha = 1
                self.title = "Choose Shop"
            }
        }
    }
    @IBAction func BTGo(_ sender: AnyObject) {
        loadCouponDiscount("bank")
    }
    
    @IBAction func CODGo(_ sender: AnyObject) {
        loadCouponDiscount("cod")
    }
    
    @IBAction func StripeGo(_ sender: AnyObject) {
        loadCouponDiscount("stripe")
    }
    @IBAction func cashGo(_ sender: AnyObject) {
        // UIPickerView
        UIView.animate(withDuration: 1.0) {
            self.pickerView.isHidden = false
            self.pickerView.alpha = 1
            self.view.setNeedsLayout()
        }
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        self.pickerView.isHidden = true
        self.pickerView.alpha = 0
        self.selectedIndex = -1
    }
    @IBAction func doneClick(_ sender: Any) {
        self.selectedIndex = self.myPickerView.selectedRow(inComponent: 0)
        self.pickerView.isHidden = true
        self.pickerView.alpha = 0
        loadCouponDiscount("poc")
    }
    
    @IBAction func PaypalGo(_ sender: AnyObject) {
        //loadCheckoutConfirm("paypal")
        
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func loadCouponDiscount(_ paymentOption: String) {
        
//        skipDiscountScreen(paymentOption: paymentOption)

        weak var CouponViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CouponDiscount") as? CouponDiscountViewController
        CouponViewController?.title = language.couponDiscountTitle
//        CouponViewController?.selectedShopId = (selectedIndex != -1 ? Int(self.shopsData[selectedIndex].id) ?? 1 : selectedShopId)
        CouponViewController?.totalAmount = totalAmount
        CouponViewController?.selectedPaymentOption = paymentOption
//        CouponViewController?.selectedShopArrayIndex = (selectedIndex != -1 ? selectedIndex : selectedShopArrayIndex)
//        CouponViewController?.checkoutCurrencySymbol = settingsDetailModel!.currency_symbol!
//        CouponViewController?.checkoutCurrencyShortForm = settingsDetailModel!.currency_short_form!
//        CouponViewController?.settingsDetailModel = settingsDetailModel!
        self.navigationController?.pushViewController(CouponViewController!, animated: true)
        updateBackButton()
        
    }
    
    func skipDiscountScreen(paymentOption: String){
        weak var ConfirmViewController =  self.storyboard?.instantiateViewController(withIdentifier: "CheckoutConfirm") as? CheckoutConfirmViewController
        ConfirmViewController?.subTotalAmount = self.totalAmount
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
    func animateContentView() {
        
        moveOffScreen()
        self.contentView?.frame.origin = self.defaultValue
//        self.CODView.alpha = 1.0
//        self.StripeView.alpha = 1.0
//        self.BTView.alpha = 1.0
        
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
 
    //MARK: API Call
   
    /*
      func doSettingsAPI()  {
         //print("need to laod from API")
          
          _ = EZLoadingActivity.show("Loading...", disableUI: true)
          Alamofire.request("http://lvngs.com/index.php/rest/settings/get").responseJSON { (response) in
              _ = EZLoadingActivity.hide()

              switch response.result {
              case .success:
                      let jsonData = response.data
                      do{
                          let coupon: Settings = try JSONDecoder().decode(Settings.self, from: jsonData!)
                         //print(coupon)
                          
                          if coupon.status == "success"{
                                self.settingsDetailModel = coupon.data
                                self.loadPaymentView()
                          }
                       
                      }catch {
                         //print("Error: \(error)")
                      }
                  
              case .failure(let error):
                 //print(error)
              }

              
          }
    
      }
 */
    
}

extension PaymentOptionsViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
   
}

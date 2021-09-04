//
//  ReservationViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 27/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class ReservationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var shopPicker: UIPickerView!
    @IBOutlet weak var reserveDateTimePicker: UIDatePicker!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    
    @IBOutlet weak var contactPhone: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var additionalNote: UITextView!
    var placeholderLabel : UILabel!
    var loginUserId: String = ""
    @IBOutlet weak var contentView: UIView!
    var defaultValue: CGPoint!
    
    @IBAction func doSubmit(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/M/yyyy,HH:mm"
        let revDate = dateFormatter.string(from: reserveDateTimePicker.date)
        
        let strRevSplit = revDate.components(separatedBy: ",")
       //print(strRevSplit.first!)
       //print(strRevSplit.last!)
        
        let selectedValue = 1
       //print(selectedValue)
        if(contactName.text != "" || contactEmail.text != "" || contactPhone.text != "") {
            let params: [String : AnyObject] = [
                "resv_date"   : strRevSplit.first! as AnyObject,
                "resv_time"   : strRevSplit.last! as AnyObject,
                "note"        : additionalNote.text! as AnyObject,
                "shop_id"     : selectedValue as AnyObject,
                "user_id"     : loginUserId as AnyObject,
                "user_email"  : contactEmail.text! as AnyObject,
                "user_phone_no" : contactPhone.text! as AnyObject,
                "user_name"   : contactName.text! as AnyObject
            ]
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            _ = Alamofire.request(APIRouters.ReservationSubmit(1, params)).responseObject{
                (response: DataResponse<StdResponse>) in
                _ = EZLoadingActivity.hide()
                if response.result.isSuccess {
                    if let resp = response.result.value {
                        if(resp.status == "success") {
                            _ = SweetAlert().showAlert(language.reservationPageTitle, subTitle: language.inquirySentSuccess, style: AlertStyle.customImag(imageFile: "Logo"))
                            
                        } else {
                            _ = SweetAlert().showAlert(language.reservationPageTitle, subTitle: language.somethingWrong, style: AlertStyle.customImag(imageFile: "Logo"))
                            
                        }
                    }
                } else {
                   //print(response)
                }
            }
            
        } else {
            _ = SweetAlert().showAlert(language.reservationPageTitle, subTitle: language.inquiryEmpty, style: AlertStyle.customImag(imageFile: "Logo"))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        self.hideKeyboardWhenTappedAround()
        
        btnSubmit.backgroundColor = Common.instance.colorWithHexString(configs.btnColorCode)
        
//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
//        }
        
        self.shopPicker.dataSource = self;
        self.shopPicker.delegate = self;
        self.additionalNote.delegate = self
        
        setupTextViewPlaceHolder()
        bindUserInfo()
        
        contentView.alpha = 0
        defaultValue = contentView?.frame.origin
        animateContentView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.reservationPageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    func setupTextViewPlaceHolder() {
        placeholderLabel = UILabel()
        placeholderLabel.text = "Additional Note"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (additionalNote.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        additionalNote.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (additionalNote.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !additionalNote.text.isEmpty
    }
    
    func textViewDidChange(_ additionalNote: UITextView) {
        placeholderLabel.isHidden = !additionalNote.text.isEmpty
    }
    
    func numberOfComponents(in shopPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ shopPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ shopPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shopModel!.name
    }
    
    func pickerView(_ shopPicker: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = shopModel!.name //ShopsListModel.sharedManager.shops[row].name
        pickerLabel.font = UIFont(name: customFont.normalFontName , size: CGFloat(customFont.pickerFontSize)) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func bindUserInfo() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: plistPath)) {
            if let bundlePath = Bundle.main.path(forResource: "LoginUserInfo", ofType: "plist") {
                
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: plistPath)
                } catch{
                    
                }
            } else {
                //print("LoginUserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
            
        } else {
            //print("LoginUserInfo.plist already exits at path.")
        }
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        
        if let dict = myDict {
            /*
             loginUserId           = Int(dict.object(forKey: "_login_user_id") as! String)!
             loginUserName         = dict.object(forKey: "_login_user_username") as! String
             loginUserProfilePhoto = dict.object(forKey: "_login_user_profile_photo") as! String
             loginUserEmail        = dict.object(forKey: "_login_user_email") as! String
             loginUserAboutMe      = dict.object(forKey: "_login_user_about_me") as! String
             loginUserPhone = dict.object(forKey: "_login_user_phone") as! String
             loginUserDeliveryAddress = dict.object(forKey: "_login_user_delivery_address") as! String
             loginUserBillingAddress = dict.object(forKey: "_login_user_billing_address") as! String
             
             
             txtName.text = loginUserName
             txtEmail.text = loginUserEmail
             txtAbout.text = loginUserAboutMe
             txtDeliveryAddress.text = loginUserDeliveryAddress
             txtBillingAddress.text = loginUserBillingAddress
             txtPhone.text = loginUserPhone
             */
            loginUserId = "\(Common.instance.getLoginUserId(dict: dict))"
            contactName.text = dict.object(forKey: "_login_user_username") as? String
            contactEmail.text = dict.object(forKey: "_login_user_email") as? String
            contactPhone.text = dict.object(forKey: "_login_user_phone") as? String
            
            
            
        } else {
           //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func animateContentView() {
        
        moveOffScreen()
        
        self.contentView?.frame.origin = self.defaultValue
        
        self.contentView.alpha = 1.0
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
}



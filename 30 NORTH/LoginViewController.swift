//
//  LoginViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 13/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

@objc protocol UserLoginDelegate: class {
    func updateLoginUserId(_ UserId: Int)
}

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    var fromWhere:String = ""
    var selectedItemId:Int = 0
    var selectedShopId:Int = 1
    weak var reviewListRefreshReviewCountsDelegate : ReviewListRefreshReviewCountsDelegate!
    weak var itemDetailLoginUserIdDelegate : ItemDetailLoginUserIdDelegate!
	weak var delegate:UserLoginDelegate?

    weak var sendMessageDelegate : SendMessageDelegate?
    
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    var defaultValue: CGPoint!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    
    
    @IBAction func loadRegister(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review" || self.fromWhere == "favourite" || self.fromWhere == "like" || self.fromWhere == "cart") {
            weak var UserRegViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as? RegisterViewController
            UserRegViewController?.fromWhere = self.fromWhere
            self.navigationController?.pushViewController(UserRegViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("register")
        }
    }
    
    @IBAction func loadForgotPassword(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review" || self.fromWhere == "favourite" || self.fromWhere == "like" || self.fromWhere == "cart") {
            weak var passworForgotViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentForgot") as? ForgotPasswordViewController
            passworForgotViewController!.fromWhere = "review"
            self.navigationController?.pushViewController(passworForgotViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("forgot")
        }
    }
    
    func validateEmailAndPassword() -> Bool{
    
        var isValidate = true
        if txtEmail.text!.trim().count < 1{
            emailErrorLabel.text = "Please enter your email"
            emailErrorLabel.isHidden = false
            isValidate = false
        }else if txtEmail.text!.trim().count < 4{
            emailErrorLabel.text = "Email must be atleast 4 characters"
            isValidate = false
            emailErrorLabel.isHidden = false
        }else if Common.instance.isValidEmail(txtEmail.text!) == false {
            emailErrorLabel.text = "Please enter a valid email"
            isValidate = false
            emailErrorLabel.isHidden = false
        }else if txtPassword.text!.trim().count < 1{
            passwordErrorLabel.text = "Please enter your password"
            isValidate = false
            passwordErrorLabel.isHidden = false
        }else if txtPassword.text!.trim().count < 4{
            passwordErrorLabel.text = "Password must be atleast 4 characters"
            isValidate = false
            passwordErrorLabel.isHidden = false
        }
        return isValidate
    }
    
    @IBAction func submitLogin(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        

            if validateEmailAndPassword() {
                
                _ = EZLoadingActivity.show("Loading...", disableUI: true)
                
                let param: [String: AnyObject] = ["email": txtEmail.text! as AnyObject, "password": txtPassword.text! as AnyObject]
                _ = Alamofire.request(APIRouters.UserLogin(param)).responseObject {
                    (response: DataResponse<User>) in
                    if response.result.isSuccess {
                        
                        if let user = response.result.value {

                            self.updateDeviceToken(user: user)

                            // Normal ( From Profile Login)
                            if self.fromWhere == "" {
                            
                                
                                let defaultImage = UIImage(named: "default_user_profile")
                                self.saveImage(defaultImage)
                                
                                // Update menu
                                (self.revealViewController().rearViewController as? MenuListController)?.userLoggedIn = true
                                
                                // Add the user info to local
                                self.addToPlist(user)
                                
                                // Open profile Page
                                // self.sendMessageDelegate?.returnmsg("profile")
                                
                                _ = EZLoadingActivity.hide()
                                
                                //                                        _ = self.navigationController?.popViewController(animated: true)
                                self.performSegue(withIdentifier: "showMainHome", sender: self)

                                
//                                let img : UIImageView = UIImageView()
//
//                                img.loadImage(urlString: imageURL) { (status, url, image, msg) in
//                                    if status == STATUS.success {
//                                        self.saveImage(image)
//
//
//
//
//                                    } else {
//                                        _ = EZLoadingActivity.hide()
//
//                                        _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.customImag(imageFile: "Logo"))
//                                       //print(response)
//                                    }
//                                }

                                
                            }else{ // For others
                                
                                // Add the user info to local
                                self.addToPlist(user)
                                
                                let imageURL = configs.imageUrl + user.profilePhoto!
                                
                                let img : UIImageView = UIImageView()
                                
                                let defaultImage = UIImage(named: "default_user_profile")
                                self.saveImage(defaultImage)

//                                img.loadImage(urlString: imageURL) { (status, url, image, msg) in
//                                    if status == STATUS.success {
//                                        self.saveImage(image)
//
//                                    }
//                                }
                                // Update menu
                                (self.revealViewController().rearViewController as? MenuListController)?.userLoggedIn = true
                                
                                if(self.fromWhere == "review") {
                                    _ = self.navigationController?.popViewController(animated: true)
                                    let reviewFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewEntryViewController") as? ReviewEntryViewController
                                    reviewFormViewController?.reviewListRefreshReviewCountsDelegate = self.reviewListRefreshReviewCountsDelegate
                                    reviewFormViewController?.selectedItemId = self.selectedItemId
//                                    reviewFormViewController?.selectedShopId = self.selectedShopId
                                    self.navigationController?.pushViewController(reviewFormViewController!, animated: true)
                                    self.itemDetailLoginUserIdDelegate?.updateLoginUserId(Int(user.id!)!)
                                    _ = EZLoadingActivity.hide()
                                    
                                } else if (self.fromWhere == "favourite") {
                                    self.itemDetailLoginUserIdDelegate?.updateLoginUserId(Int(user.id!)!)
                                    _ = self.navigationController?.popViewController(animated: true)
                                    _ = EZLoadingActivity.hide()
                                } else if (self.fromWhere == "like") {
                                    self.itemDetailLoginUserIdDelegate?.updateLoginUserId(Int(user.id!)!)
                                    _ = self.navigationController?.popViewController(animated: true)
                                    _ = EZLoadingActivity.hide()
                                } else if (self.fromWhere == "cart") {
                                
                                    self.itemDetailLoginUserIdDelegate.updateLoginUserId(Int(user.id!)!)
                                    _ = self.navigationController?.popViewController(animated: true)
                                    _ = EZLoadingActivity.hide()
                                
                                }  else {
									self.delegate?.updateLoginUserId(Int(user.id!)!)
									_ = self.navigationController?.popViewController(animated: true)
									_ = EZLoadingActivity.hide()
								}
                            }
                        }else{
                            _ = EZLoadingActivity.hide()
                            _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.customImag(imageFile: "Logo"))
                           //print(response)
                        }
                        
                    } else {
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.customImag(imageFile: "Logo"))
                       //print(response)
                    }
                }
                
//            } else {
//                _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.emailValidation, style: AlertStyle.customImag(imageFile: "Logo"))
//            }
        }
    }

    func updateDeviceToken(user:User) {
        //Get device token from UserDefaults
        let prefs = UserDefaults.standard

        if let deviceID = prefs.string(forKey: notiKey.deviceIDKey), let devicePlatform = prefs.string(forKey: notiKey.devicePlatform), let deviceToken = prefs.data(forKey: notiKey.deviceTokenKey) {

            //var deviceTokenKey = String(format: "%@", deviceToken as CVarArg)
            var deviceTokenKey = deviceToken.map { String(format: "%02x", $0)
            }.joined()
            // Remove All Space, >, <
            deviceTokenKey = deviceTokenKey.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
            deviceTokenKey = deviceTokenKey.replacingOccurrences(of: ">", with: "", options: NSString.CompareOptions.literal, range: nil)
            deviceTokenKey = deviceTokenKey.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)

           //print("Device ID Key : " + deviceID)
           //print("Device Token Key : " + deviceTokenKey)
           //print("Device Platforma : " + devicePlatform)


            if(deviceID != "" && deviceTokenKey != "" && devicePlatform != "") {

                let params: [String: AnyObject] = [
                    "reg_id"    :  deviceTokenKey as AnyObject,
                    "device_id" :  deviceID as AnyObject,
                    "os_type"   :  devicePlatform as AnyObject,
                    "platformName": "ios" as AnyObject,
                    "user_id"    :    user.id as AnyObject
                ]

                _ =  Alamofire.request(APIRouters.RegitsterPushNoti(params)).responseObject {
                    (response: DataResponse<StdResponse>) in
                   //print(response)
                    if response.result.isSuccess {
                        if let res = response.result.value {
                           //print("Success \(res.intData)")
                            prefs.set("YES", forKey: notiKey.isRegister)
                        }
                    } else {
                       //print("Fail \(response)")
                    }
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

       self.hideKeyboardWhenTappedAround()
//       btnSubmit.backgroundColor = Common.instance.colorWithHexString(configs.btnColorCode)
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtEmail.alpha = 0
        txtPassword.alpha = 0
        btnSubmit.alpha = 0
        btnRegister.alpha = 0
        btnForgot.alpha = 0
        defaultValue = contentView?.frame.origin
        animateContentView()
//        changePlaceholderColor(textfield: txtEmail, placeholderText: "Email")
//        changePlaceholderColor(textfield: txtPassword, placeholderText: "Password")
        btnSubmit.layer.cornerRadius = 5
        
    }
    
    
    
    func saveImage(_ image: UIImage?){
        let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
        if image != nil {
            // Save it to our Documents folder
            let result = Common.instance.saveImage(image!, path: imagePath)
           //print("Image saved? Result: \(result)")
            
        }
    }
    @IBAction func onRegisterButton(_ sender: Any) {
        popToRegisterViewControllerIfPresent()
    }
    
    func popToRegisterViewControllerIfPresent(){
        if let viewControllers = self.navigationController?.viewControllers{
            for vc in viewControllers {
                if vc is RegisterViewController{
                    self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
        pushToRegister()
    }
    
    func pushToRegister() {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as! RegisterViewController
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    func popToForgotPasswordViewControllerIfPresent(){
        if let viewControllers = self.navigationController?.viewControllers{
            for vc in viewControllers {
                if vc is ForgotPasswordViewController{
                    self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
        pushToForgotPassword()
    }
    
    func pushToForgotPassword() {
        let forgotPasswordViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentForgot") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    @IBAction func onForgotPasswordButton(_ sender: Any) {
        pushToForgotPassword()
    }
    
    func addToPlist(_ user: User) {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let dict: NSMutableDictionary = [:]
        let userID : Int = Int(user.id!)!
        dict.setObject("\(userID)" , forKey: "_login_user_id" as NSString)
        dict.setObject(user.username ?? "", forKey: "_login_user_username" as NSString)
        dict.setObject(user.email ?? "", forKey: "_login_user_email" as NSString)
        dict.setObject(user.is_phone_verified ?? "", forKey: "_is_phone_verified" as NSString)
        dict.setObject(user.aboutMe ?? "", forKey: "_login_user_about_me" as NSString)
        dict.setObject(user.profilePhoto ?? "default_user_profile.png", forKey: "_login_user_profile_photo" as NSString)
        dict.setObject(user.phone ?? "", forKey: "_login_user_phone" as NSString)
        dict.setObject(user.birth_date ?? "", forKey: "_login_user_birth_date" as NSString)
        dict.setObject(user.deliveryAddress ?? "", forKey: "_login_user_delivery_address" as NSString)
        //dict.setObject(user.billingAddress ?? "", forKey: "_login_user_billing_address" as NSString)
		dict.setObject(user.district_id ?? "", forKey: "_login_user_district_id" as NSString)

        
        dict.write(toFile: plistPath, atomically: false)
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.LoginTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func animateContentView() {
        
        moveOffScreen()
        
                self.txtEmail.alpha = 1.0
                self.txtPassword.alpha = 1.0
                self.btnSubmit.alpha = 1.0
                self.btnRegister.alpha = 1.0
                self.btnForgot.alpha = 1.0
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEmail{
            emailErrorLabel.isHidden = true
        }
        if textField == txtPassword{
            passwordErrorLabel.isHidden = true
        }
        
        return true
    }
}



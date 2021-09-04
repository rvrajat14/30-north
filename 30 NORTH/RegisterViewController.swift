//
//  RegisterViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 13/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class RegisterViewController: UIViewController , UITextFieldDelegate{
    
    var fromWhere:String = ""
    weak var sendMessageDelegate : SendMessageDelegate?
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    var defaultValue: CGPoint!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var lastnameErrorLabel: UILabel!

    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!

    @IBAction func loadLogin(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
        UserLoginViewController?.fromWhere = self.fromWhere
        self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
        updateBackButton()
    }
    
    @IBAction func onForgotPassword(_ sender: Any) {
        popToForgotPasswordViewControllerIfPresent()
    }
    
    @IBAction func onBackToLogin(_ sender: Any) {
      popToLoginViewControllerIfPresent()
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
    
    func popToLoginViewControllerIfPresent(){
        if let viewControllers = self.navigationController?.viewControllers{
            for vc in viewControllers {
                if vc is LoginViewController{
                    self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
        pushToLogin()
    }
    
    func pushToLogin() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func loadForgotPassword(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review") {
            weak var passworForgotViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentForgot") as? ForgotPasswordViewController
            passworForgotViewController!.fromWhere = "review"
            self.navigationController?.pushViewController(passworForgotViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("forgot")
        }
    }
    
    func textfieldValidation() -> Bool{
        
        var isValidate = true
        
        if userName.text!.trim().count < 1{
            usernameErrorLabel.text = "Please enter First name"
            usernameErrorLabel.isHidden = false
            isValidate = false
        }else if userName.text!.trim().count < 3{
            usernameErrorLabel.text = "First name must be atleast 3 characters"
            isValidate = false
            usernameErrorLabel.isHidden = false
        }else if lastName.text!.trim().count < 1{
            lastnameErrorLabel.text = "Please enter Last name"
            lastnameErrorLabel.isHidden = false
            isValidate = false
        }else if lastName.text!.trim().count < 3{
            lastnameErrorLabel.text = "Last name must be atleast 3 characters"
            isValidate = false
            lastnameErrorLabel.isHidden = false
        } else if userEmail.text!.trim().count < 1{
            emailErrorLabel.text = "Please enter your email"
            emailErrorLabel.isHidden = false
            isValidate = false
        }else if userEmail.text!.trim().count < 4{
            emailErrorLabel.text = "Email must be atleast 4 characters"
            isValidate = false
            emailErrorLabel.isHidden = false
        }else if Common.instance.isValidEmail(userEmail.text!) == false {
            emailErrorLabel.text = "Please enter a valid email"
            isValidate = false
            emailErrorLabel.isHidden = false
        }else if userPassword.text!.trim().count < 1{
            passwordErrorLabel.text = "Please enter your password"
            isValidate = false
            passwordErrorLabel.isHidden = false
        }else if userPassword.text!.trim().count < 4{
            passwordErrorLabel.text = "Password must be atleast 4 characters"
            isValidate = false
            passwordErrorLabel.isHidden = false
        }
        return isValidate
    }
    
    @IBAction func submitUser(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        if textfieldValidation(){
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            let params: [String: AnyObject] = [
                "username"  :  userName.text! as AnyObject,
				"last_name"  :  lastName.text! as AnyObject,
                "email"     :  userEmail.text! as AnyObject,
                "password"  :  userPassword.text! as AnyObject,
                //"about_me"  :  "" as AnyObject
            ]
            
            _ = Alamofire.request(APIRouters.AddAppUser(params)).responseObject {
                (response: DataResponse<StdResponse>) in
                
                if response.result.isSuccess {
                    if let res = response.result.value {
                        
                        if res.status == "success" {
                           print(res)
                            
                            
                            /*Do this after user auto logs in*/
                            /*
                            // Update menu
                            (self.revealViewController().rearViewController as? MenuListController)?.userLoggedIn = true
                            // Add the user info to local
                            let plistPath = Common.instance.getLoginUserInfoPlist()
                            let dict: NSMutableDictionary = [:]
                            let userID : Int = Int(res.intData)
                           //print("User ID \(userID)")
                            dict.setObject("\(userID)" , forKey: "_login_user_id" as NSString)
                            dict.setObject(self.userName.text ?? "", forKey: "_login_user_username" as NSString)
                            dict.setObject(self.lastName.text ?? "", forKey: "_login_user_lastname" as NSString)
                            dict.setObject(self.userEmail.text ?? "", forKey: "_login_user_email" as NSString)
                            dict.setObject("default_user_profile.png", forKey: "_login_user_profile_photo" as NSString)
                            dict.setObject("", forKey: "_login_user_phone" as NSString)
                            dict.setObject("", forKey: "_login_user_delivery_address" as NSString)
//                            dict.setObject("", forKey: "_login_user_billing_address" as NSString)
							dict.setObject("", forKey: "_login_user_district_id" as NSString)
                            dict.write(toFile: plistPath, atomically: false)
                                */
                            
                            _ = SweetAlert().showAlert(language.registerTitle, subTitle: language.registerSuccess, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Ok", buttonColor: UIColor.colorFromRGB(0xAEDEF4), action: { (isOk) in
                                               //self.performSegue(withIdentifier: "showMainHome", sender: self)
                                                self.AutoLoginUser(email: self.userEmail.text!, pass: self.userPassword.text!)
                                           })
                        }else{
                            _ = SweetAlert().showAlert(language.registerTitle, subTitle: res.data, style: AlertStyle.customImag(imageFile: "Logo"))
                        }
                    }
                } else {
                   //print(response)
                }
                
                _ = EZLoadingActivity.hide()
                
            }
        }
        
    }
    
    func AutoLoginUser(email: String, pass: String) {
            
            // Dismiss the keyboard
                    
                    _ = EZLoadingActivity.show("Loading...", disableUI: true)
                    let param: [String: AnyObject] = ["email": email as AnyObject, "password": pass as AnyObject]
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
                                    _ = EZLoadingActivity.hide()
                                    self.performSegue(withIdentifier: "showMainHome", sender: self)

                                }
                            
                        } else {
                            _ = EZLoadingActivity.hide()
                            _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.customImag(imageFile: "Logo"))
                        }
                    }
        }
    }
    
    func saveImage(_ image: UIImage?){
        let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
        if image != nil {
            // Save it to our Documents folder
            let result = Common.instance.saveImage(image!, path: imagePath)
           print("Image saved? Result: \(result)")
            
        }
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
           dict.setObject(user.deliveryAddress ?? "", forKey: "_login_user_delivery_address" as NSString)
           //dict.setObject(user.billingAddress ?? "", forKey: "_login_user_billing_address" as NSString)
           dict.setObject(user.district_id ?? "", forKey: "_login_user_district_id" as NSString)

           
           dict.write(toFile: plistPath, atomically: false)
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        self.hideKeyboardWhenTappedAround()
        
        userName.alpha = 0
		lastName.alpha = 0
        userEmail.alpha = 0
        userPassword.alpha = 0
        btnRegister.alpha = 0
        btnLogin.alpha = 0
        btnForgot.alpha = 0
        
        defaultValue = contentView?.frame.origin
        animateContentView()
        btnRegister.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationItemFont()
        
    }
    
    func setNavigationItemFont() {
        self.navigationController?.navigationBar.topItem?.title = language.registerTitle
//        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func animateContentView() {
        
        moveOffScreen()
        
        
        self.contentView?.frame.origin = self.defaultValue
        
        self.userName.alpha = 1.0
		self.lastName.alpha = 1.0
        self.userEmail.alpha = 1.0
        self.userPassword.alpha = 1.0
        self.btnRegister.alpha = 1.0
        self.btnLogin.alpha = 1.0
        self.btnForgot.alpha = 1.0
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userName {
            usernameErrorLabel.isHidden = true
        }
		if textField == lastName {
            lastnameErrorLabel.isHidden = true
        }
        if textField == userEmail{
            emailErrorLabel.isHidden = true
        }
        if textField == userPassword{
            passwordErrorLabel.isHidden = true
        }
        return true
    }
}

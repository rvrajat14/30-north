//
//  ForgotPasswordViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 14/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class ForgotPasswordViewController : UIViewController, UITextFieldDelegate {
    var fromWhere: String = ""
    weak var sendMessageDelegate : SendMessageDelegate?
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    var defaultValue: CGPoint!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    @IBAction func loadLogin(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review") {
            weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
            UserLoginViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("login")
        }
    }
    @IBAction func onBackToLogin(_ sender: Any) {
        popToLoginViewControllerIfPresent()
    }
    @IBAction func onRegister(_ sender: Any) {
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
    
    @IBAction func loadRegister(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        if(self.fromWhere == "review") {
            weak var UserRegViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as? RegisterViewController
            UserRegViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserRegViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("register")
        }
    }
    
    func textfieldValidation() -> Bool{
        
        var isValidate = true

        if userEmail.text!.trim().count < 1{
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
        }
        return isValidate
    }
    @IBAction func submitPassword(_ sender: AnyObject) {
        

        // Dismiss the keyboard
        self.dismissKeyboard()
        
        if(textfieldValidation()) {
            
            let params: [String: AnyObject] = [
                "email"  :  userEmail.text! as AnyObject
            ]
            
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            _ = Alamofire.request(APIRouters.ResetPassword(params)).responseObject {
                (response: DataResponse<StdResponse>) in
                
                _ = EZLoadingActivity.hide()
                if response.result.isSuccess {
                    if let res = response.result.value {
                       //print(res.data)

                        _ = SweetAlert().showAlert(language.resetTitle, subTitle: language.resetSuccess, style: AlertStyle.customImag(imageFile: "Logo"))
                        self.sendMessageDelegate?.returnmsg("login")
                        
                    }
                } else {
                   //print(response)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        self.hideKeyboardWhenTappedAround()
//        btnSubmit.backgroundColor = Common.instance.colorWithHexString(configs.btnColorCode)
        
        userEmail.alpha = 0
        btnSubmit.alpha = 0
        btnRegister.alpha = 0
        btnLogin.alpha = 0
        lblTitle.alpha = 0
        
        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationItemFont()
        userEmail.text = ""
    }
    
    override func viewDidDisappear(_ animated: Bool) {

    }
    
    func setNavigationItemFont() {
        self.navigationController?.navigationBar.topItem?.title = language.forgotTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func animateContentView() {
        
        moveOffScreen()
            self.contentView?.frame.origin = self.defaultValue
            self.userEmail.alpha = 1.0
            self.btnSubmit.alpha = 1.0
            self.btnRegister.alpha = 1.0
            self.btnLogin.alpha = 1.0
            self.lblTitle.alpha = 1.0
     
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userEmail{
            emailErrorLabel.isHidden = true
        }
        return true
    }
}


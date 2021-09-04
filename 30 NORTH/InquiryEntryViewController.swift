//
//  InquiryEntryViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 18/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class InquiryEntryViewController: UIViewController, UITextViewDelegate {
    
    var placeholderLabel : UILabel!
    //var titleLabel : UILabel!
    var selectedItemId:Int = 0
    var selectedShopId:Int = 1
    var defaultValue: CGPoint!

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "Get in Touch")
		}
	}
//    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var inquiryMessage: UITextView!
    @IBOutlet weak var submit: UIButton!
	@IBOutlet weak var contentView: UIView! {
		didSet {
			contentView.backgroundColor = .clear
		}
	}
    @IBOutlet weak var Pagetitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        addPlaceHolder()
        self.hideKeyboardWhenTappedAround()

        contentView.alpha = 0
        defaultValue = contentView?.frame.origin
        animateContentView()
        configUI()
        
        let plistPath = Common.instance.getLoginUserInfoPlist()
       //print(plistPath)
        
        if Common.instance.isUserLogin() {
            bindUserInfo()
            userName.isUserInteractionEnabled = false
            userEmail.isUserInteractionEnabled = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

        submit.setTitle(language.submit, for: UIControl.State())
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
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
            let loginUserName = dict.object(forKey: "_login_user_username") as! String
            let loginUserEmail = dict.object(forKey: "_login_user_email") as! String
            
            userName.text = loginUserName
            userEmail.text = loginUserEmail
            
        } else {
           //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    @IBAction func SubmitInquiry(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        if(userName.text != "" || userEmail.text != "" || inquiryMessage.text != "") {
            
            let params: [String : AnyObject] = [
                "name"   : userName.text! as AnyObject,
                "email"  : userEmail.text! as AnyObject,
                "message": inquiryMessage.text! as AnyObject,
                "shop_id": "1" as AnyObject
            ]
            
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            _ = Alamofire.request(APIRouters.AddItemInquiry(selectedItemId, params)).responseObject{
                (response: DataResponse<StdResponse>) in
                
                _ = EZLoadingActivity.hide()
                
                if response.result.isSuccess {
                    if let resp = response.result.value {
                        if(resp.status == "success") {
                            _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.inquirySentSuccess, style: AlertStyle.customImag(imageFile: "Logo"))
                            self.cleanTextInput()
                        } else {
                            _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.somethingWrong, style: AlertStyle.customImag(imageFile: "Logo"))
                        }
                    }
                } else {
                   //print(response)
                }
            }
            
        } else {
            _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.inquiryEmpty, style: AlertStyle.customImag(imageFile: "Logo"))   
        }
    }
    
    func addPlaceHolder() {
        Pagetitle.text = "We'd love to hear from you \n Fill our the form and we'll be in touch soon!"
        inquiryMessage.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = language.typeInquiryMessage
        placeholderLabel.font = UIFont.systemFont(ofSize: inquiryMessage.font!.pointSize)
        placeholderLabel.sizeToFit()
        inquiryMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: inquiryMessage.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !inquiryMessage.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func cleanTextInput() {
        userName.text = ""
        userEmail.text = ""
        inquiryMessage.text = ""
    }

    
    private func configUI() {
        self.view.isHidden = false
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

//
//  ReviewEntryViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 15/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class ReviewEntryViewController: UIViewController, UITextViewDelegate {
    
    var placeholderLabel : UILabel!
    var selectedItemId:Int = 0
    var loginUserId:Int = 0
//    var selectedShopId:Int = 1
    var reviews = [ReviewModel]()
    
    weak var reviewListRefreshReviewCountsDelegate : ReviewListRefreshReviewCountsDelegate!
    
    @IBOutlet weak var loginUserName: UILabel!
    @IBOutlet weak var loginUserEmail: UILabel!
    
    @IBOutlet weak var userReview: UITextView!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var contentView: UIView!
    var defaultValue: CGPoint!
    
    @IBAction func reviewSubmit(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        if(userReview.text != "") {
            
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            let params = [
                "appuser_id": loginUserId,
                "review"    : userReview!.text!,
                "shop_id"   : 1
                ] as [String : Any]
           //print(params)
            _ = Alamofire.request(APIRouters.AddItemReview(selectedItemId, params as[String : AnyObject])).responseObject{
                (response: DataResponse<Item>) in
                
                _ = EZLoadingActivity.hide()
                
                if response.result.isSuccess {
                    if let item = response.result.value {
                        if(item.reviews.count > 0){
                            for review in item.reviews {
                                let oneReview = ReviewModel(review: review)
                                self.reviews.append(oneReview)
                            }
                            self.reviewListRefreshReviewCountsDelegate.updateReviewCounts(self.reviews)
                            self.navigationController!.popToRootViewController(animated: true)
                        }
                        
                        
                        
                        
                    }
                } else {
                   //print(response)
                }
            }
            
        } else {
            _ = SweetAlert().showAlert(language.reviewTitle, subTitle: language.reviewEmpty, style: AlertStyle.customImag(imageFile: "Logo"))
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        addPlaceHolder()
        loadLoginUserId()
        self.hideKeyboardWhenTappedAround()
        submit.backgroundColor = Common.instance.colorWithHexString(configs.btnColorCode)
        
        contentView.alpha = 0
        defaultValue = contentView?.frame.origin
        animateContentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        submit.setTitle(language.submit, for: UIControl.State())
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userReview = nil
        loginUserName = nil
        loginUserEmail = nil
        submit = nil
    }
    
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {
            loginUserId = Common.instance.getLoginUserId(dict: dict)
           //print(loginUserId)
            loginUserName.text = dict.object(forKey: "_login_user_username") as! String
            loginUserEmail.text = dict.object(forKey: "_login_user_email") as! String
        } else {
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func addPlaceHolder() {
        userReview.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = language.typeReviewMessage
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: userReview.font!.pointSize)
        placeholderLabel.sizeToFit()
        userReview.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: userReview.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !userReview.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.reviewEntryPageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
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

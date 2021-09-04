//
//  UserProfileEditViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 25/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseUI

class UserProfileEditViewController: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var loginUserId: Int = 0
    var loginUserName: String = ""
	var loginUserLastName: String = ""
    var loginUserProfilePhoto: String = ""
    var loginUserEmail: String = ""
    var loginUserPhone: String = ""
	var loginUserBirthDate: String = ""
    //var loginUserAboutMe: String = ""
    var loginUserDeliveryAddress: String = ""
    var loginUserBillingAddress: String = ""


	let textColor = UIColor(displayP3Red: 0.717, green: 0.717, blue: 0.717, alpha: 1)
	//let labelColor = UIColor(displayP3Red: 0.635, green: 0.635, blue: 0.635, alpha: 1)
	let textFont = UIFont(name: AppFontName.regular, size: 17)
	let labelFont = UIFont(name: AppFontName.regular, size: 17)

	var selectedIndex:Int = -1
	var selectedDistrict:NSDictionary? = nil

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
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

	@IBOutlet weak var nameLabel: UILabel!{
		didSet {
			nameLabel.textColor = UIColor.gold
			nameLabel.font = labelFont
		}
	}
	@IBOutlet weak var lastNameLabel: UILabel!{
		didSet {
			lastNameLabel.textColor = UIColor.gold
			lastNameLabel.font = labelFont
		}
	}
	@IBOutlet weak var emailLabel: UILabel!{
		didSet {
			emailLabel.textColor = UIColor.gold
			emailLabel.font = labelFont
		}
	}
	@IBOutlet weak var phoneLabel: UILabel!{
		didSet {
			phoneLabel.text = "MOBILE"
			phoneLabel.textColor = UIColor.gold
			phoneLabel.font = labelFont
		}
	}
	@IBOutlet weak var dateOfBirth: UILabel!{
		didSet {
			dateOfBirth.text = "Date of Birth (optional)"
			dateOfBirth.textColor = UIColor.gold
			dateOfBirth.font = labelFont
		}
	}
	@IBOutlet weak var deliveryLabel: UILabel!{
		didSet {
			deliveryLabel.textColor = UIColor.gold
			deliveryLabel.font = labelFont
		}
	}
	@IBOutlet weak var billingLabel: UILabel!{
		didSet {
			billingLabel.textColor = UIColor.gold
			billingLabel.font = labelFont
		}
	}
	@IBOutlet weak var changePasswordLabel: UILabel!{
		didSet {
			changePasswordLabel.textColor = UIColor.gold
			changePasswordLabel.font = labelFont
		}
	}
	@IBOutlet weak var newPasswordLabel: UILabel!{
		didSet {
			newPasswordLabel.textColor = UIColor.gold
			newPasswordLabel.font = labelFont
		}
	}
	@IBOutlet weak var confirmPasswordLabel: UILabel!{
		didSet {
			confirmPasswordLabel.textColor = UIColor.gold
			confirmPasswordLabel.font = labelFont
		}
	}

	@IBOutlet weak var txtName: UITextField! {
		didSet {
			txtName.layer.borderWidth = 0
			txtName.textColor = textColor
			txtName.font = textFont
			changePlaceHolderColor(textField: txtName)
		}
	}
	@IBOutlet weak var txtLastName: UITextField! {
		didSet {
			txtLastName.layer.borderWidth = 0
			txtLastName.textColor = textColor
			txtLastName.font = textFont
			changePlaceHolderColor(textField: txtLastName)
		}
	}
    @IBOutlet weak var txtEmail: UITextField!{
		didSet {
			txtEmail.layer.borderWidth = 0
			txtEmail.textColor = textColor
			txtEmail.font = textFont
			changePlaceHolderColor(textField: txtEmail)
		}
	}
    @IBOutlet weak var txtPhone: UITextField!{
		didSet {
			txtPhone.layer.borderWidth = 0
			txtPhone.textColor = textColor
			txtPhone.font = textFont
			changePlaceHolderColor(textField: txtPhone)
		}
	}
	@IBOutlet weak var txtBirthDate: UITextField!{
		   didSet {
			   txtBirthDate.layer.borderWidth = 0
			   txtBirthDate.textColor = textColor
			   txtBirthDate.font = textFont
			   changePlaceHolderColor(textField: txtBirthDate)
		   }
	   }
	@IBOutlet weak var txtNewPassword: UITextField!{
		didSet {
			txtNewPassword.layer.borderWidth = 0
			txtNewPassword.textColor = textColor
			txtNewPassword.font = textFont
			changePlaceHolderColor(textField: txtNewPassword)
		}
	}
	@IBOutlet weak var txtConfirmPassword: UITextField!{
		didSet {
			txtConfirmPassword.layer.borderWidth = 0
			txtConfirmPassword.textColor = textColor
			txtConfirmPassword.font = textFont
			changePlaceHolderColor(textField: txtConfirmPassword)
		}
	}
	
    //@IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var txtDeliveryAddress: UITextView!{
        didSet {
            txtDeliveryAddress.layer.borderWidth = 0
        }
    }

	@IBOutlet weak var areaButton: UIButton! {
		didSet {
			areaButton.contentHorizontalAlignment = .left
			areaButton.backgroundColor = .clear
			areaButton.setTitle("Area", for: .normal)
			areaButton.setTitleColor(textColor, for: .normal)
			areaButton.titleLabel?.font = textFont
			areaButton.clipsToBounds = true
		}
	}

	@IBOutlet weak var txtBillingAddress: UITextView!{
        didSet {
            txtBillingAddress.layer.borderWidth = 0
        }
    }
    
    @IBOutlet weak var ProfilePhoto: UIImageView!
    @IBOutlet weak var btnChoose: UIButton!
    @IBOutlet weak var btnUpload: UIButton!

	@IBOutlet weak var verifyButton: UIButton!{
		didSet {
			verifyButton.layer.cornerRadius = 3.0
            verifyButton.backgroundColor = UIColor.gold
			verifyButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 15)
			verifyButton.setTitle("Verify Now", for: .normal)
			verifyButton.setTitleColor(UIColor.white, for: .normal)

			verifyButton.imageView?.contentMode = .scaleAspectFit
			verifyButton.clipsToBounds = true
		}
	}

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var innerView: UIView!
    var defaultValue: CGPoint!
    
    @IBAction func doProfileUpdate(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        updateUserInfo()
    }
    
    @IBAction func loadImageFromLibrary(_ sender: AnyObject) {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
        btnUpload.isEnabled = true
    }
    
    @IBAction func changePassword(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        updateUserInfo()
    }

	@IBAction func areaAction(_ sender: UIButton) {
		self.showPopupView()
	}

	func setupBirthField() {
		let datePickerView = UIDatePicker()
		datePickerView.datePickerMode = .date
		//1 Month ago date
		let secondsInMonth: TimeInterval = 30 * 24 * 60 * 60 * -1
		datePickerView.maximumDate = Date(timeInterval: secondsInMonth, since: Date())

		txtBirthDate.inputView = datePickerView
		datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
	}

	@objc func handleDatePicker(sender: UIDatePicker) {
	   let dateFormatter = DateFormatter()
	   dateFormatter.dateFormat = "yyyy/MM/dd"
	   txtBirthDate.text = dateFormatter.string(from: sender.date)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
	   self.view.endEditing(true)
	}

    @IBAction func btnUpload(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        _ = EZLoadingActivity.show("Uploading...", disableUI: true)
        
        // set imagePath
        let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
        var image2 = ProfilePhoto.image
       //print("image width and height \(String(describing: image2?.size.width)) \(String(describing: image2?.size.height))")
        
        let size:CGSize = Common.instance.getImageSize(image2!.size)
        image2 = Common.instance.scaleUIImageToSize(image2!, size: size)
       //print("Converted size : \(String(describing: image2?.size.width)) \(String(describing: image2?.size.height))")
        ProfilePhoto.image = image2
        
        UploadImage(url: APIRouters.profilePhotoUpload,userID : loginUserId, image: ProfilePhoto) { (status, data, msg) in
            
            if status == STATUS.success {
                self.loginUserProfilePhoto = data
               //print("Profile : " + self.loginUserProfilePhoto)
                self.updateLocalProfile()
                
                if image2 != nil {
                    // Save it to our Documents folder
                    let result = Common.instance.saveImage(image2!, path: imagePath)
                   //print("Image saved? Result: \(result)")
                    
                    // Load image from our Documents folder
                    let loadedImage = Common.instance.loadImageFromPath(imagePath)
                    if loadedImage != nil {
                       //print("Image loaded: \(loadedImage!)")
                        self.ProfilePhoto.image = loadedImage
                    }
                }
                
                _ = EZLoadingActivity.hide()
                
                _ = SweetAlert().showAlert(language.profileUpdate,subTitle: language.profilePhotoUploaded ,style:AlertStyle.customImag(imageFile: "Logo"))
                
                
            } else {
                _ = EZLoadingActivity.hide()
                _ = SweetAlert().showAlert(language.profileUpdate,subTitle: language.tryAgainToConnect ,style:AlertStyle.customImag(imageFile: "Logo"))
                //print("error : " + msg)
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        _ = Common.instance.circleImageView(ProfilePhoto)
        //_ = Common.instance.setTextViewBorderColor(txtAbout)
        //_ = Common.instance.setTextViewBorderColor(txtDeliveryAddress)
        //_ = Common.instance.setTextViewBorderColor(txtBillingAddress)
        bindUserInfo()
        picker?.delegate=self
        btnUpload.isEnabled = false
        
        self.hideKeyboardWhenTappedAround()
        
        innerView.alpha = 0
        defaultValue = contentView?.frame.origin
        animateContentView()
		setupBirthField()
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0);
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}

	func changePlaceHolderColor(textField:UITextField) {
		let placeholder = textField.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
		textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : textColor])
	}

	func updateUserInfo(isPhoneVerified:Bool = false) {
        self.dismissKeyboard()
		
        if(txtNewPassword.text == "" && txtConfirmPassword.text == "") {
			
            //If District is required make it optional until the user tries to order a delivery order (https://trello.com/c/YIKYulOx/136-edit-profile-problem)
            /*
            guard let district = self.selectedDistrict else {
               _ = SweetAlert().showAlert(language.profileUpdate,subTitle: language.selectDistrict ,style:AlertStyle.customImag(imageFile: "Logo"))
				return
			}*/
            
            
            
			var varified = false
			if isPhoneVerified {
				varified = true
			} else if self.verifyButton.image(for: .normal) != nil, self.loginUserPhone == self.txtPhone.text {
				varified = true
			}
            var params: [String: AnyObject] = [
                "email"   : txtEmail.text! as AnyObject,
                "username": txtName.text! as AnyObject,
				"last_name":txtLastName.text! as AnyObject,
                "phone"   : txtPhone.text! as AnyObject,
				"birth_date"   : txtBirthDate.text as AnyObject,
                "delivery_address" : txtDeliveryAddress.text! as AnyObject,
                "platformName": "ios" as AnyObject,
				"is_phone_verified": (varified ? "1" : "0") as AnyObject
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
                    if let res = response.result.value {
						self.updatePhoneVerificationButton(verified: varified)
                        _ = SweetAlert().showAlert(language.profileUpdate,subTitle:res.data ,style:AlertStyle.customImag(imageFile: "Logo"))
                        self.updateLocalProfile()
                    }
                } else {
                    if let res = response.result.value {
                        //EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.profileUpdate,subTitle:res.data ,style:AlertStyle.customImag(imageFile: "Logo"))
                    }
                }
            }
        } else if(txtNewPassword.text != "" || txtConfirmPassword.text != "") {
            if(txtNewPassword.text != txtConfirmPassword.text) {
                //EZLoadingActivity.hide()
                _ = SweetAlert().showAlert(language.profileUpdate,subTitle:language.doNotMatch ,style:AlertStyle.customImag(imageFile: "Logo"))
            } else {
                let params: [String: AnyObject] = [
                    "email"   : txtEmail.text! as AnyObject,
                    "username": txtName.text! as AnyObject,
					"last_name": txtLastName.text! as AnyObject,
                    //"about_me": txtAbout.text! as AnyObject,
                    "password": txtConfirmPassword.text! as AnyObject,
                    "phone"   : txtPhone.text! as AnyObject,
					"birth_date"   : txtBirthDate.text as AnyObject,
                    "delivery_address" : txtDeliveryAddress.text! as AnyObject,
                    //"billing_address" : txtBillingAddress.text! as AnyObject,
					"district": self.selectedDistrict?.value(forKey: "id") as AnyObject,
                    "platformName": "ios" as AnyObject
                ]
                
                _ = EZLoadingActivity.show("Loading...", disableUI: true)
                _ = Alamofire.request(APIRouters.UpdateAppUser(loginUserId , params)).responseObject {
                    (response: DataResponse<StdResponse>) in
                    _ = EZLoadingActivity.hide()
                    if response.result.isSuccess {
                        if let res = response.result.value {
                            //EZLoadingActivity.hide()
                            _ = SweetAlert().showAlert(language.profileUpdate,subTitle:res.data ,style:AlertStyle.customImag(imageFile: "Logo"))
                            self.updateLocalProfile()
                        }
                    } else {
                        if let res = response.result.value {
                            //EZLoadingActivity.hide()
                            _ = SweetAlert().showAlert(language.profileUpdate,subTitle:res.data ,style:AlertStyle.customImag(imageFile: "Logo"))
                        }
                    }
                }
            }
        }
    }
    
	@IBAction func verifyPhoneAction(_ sender: UIButton) {
		var message = ""
		guard let phone = self.txtPhone?.text, phone.count > 0 else {
			_ = SweetAlert().showAlert("Sorry", subTitle: "Please enter Phone Number" ,style:AlertStyle.customImag(imageFile: "Logo"))
			return
        }
		guard phone.isValidPhone() == true else {
			_ = SweetAlert().showAlert("Sorry", subTitle: "Invalid Phone Number" ,style:AlertStyle.customImag(imageFile: "Logo"))
			return
        }
		self.navigateToVerifyPhone(phoneNumber: phone)
	}

	@IBAction func selectAction(_ sender: UIButton) {
        
        
		if selectedIndex == -1 {
			_ = SweetAlert().showAlert("30 North", subTitle: "Please choose a district.", style: AlertStyle.customImag(imageFile: "Logo"))
		 return
		}
		let districts = self.getDistricts()
		let item = districts[selectedIndex]
		self.selectedDistrict = item
		self.closeButton.sendActions(for: .touchUpInside)

		if let name = item.value(forKey:"name") as? String {
			self.areaButton.setTitle(name, for: .normal)
		}
	}

	@IBAction func closeAction(_ sender: UIButton) {
		self.popupView.isHidden = true
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
            loginUserId           = Common.instance.getLoginUserId(dict: dict)
            loginUserName         = dict.object(forKey: "_login_user_username") as! String
			loginUserLastName     = dict.object(forKey: "_login_user_lastname") as? String ?? ""
            loginUserProfilePhoto = dict.object(forKey: "_login_user_profile_photo") as! String
            loginUserEmail        = dict.object(forKey: "_login_user_email") as! String
            loginUserPhone = dict.object(forKey: "_login_user_phone") as! String
            loginUserBirthDate = dict.object(forKey: "_login_user_birth_date") as? String ?? ""
            loginUserDeliveryAddress = dict.object(forKey: "_login_user_delivery_address") as! String

			if let districtID = dict.object(forKey:"_login_user_district_id") as? String {
				self.selectedDistrict = self.getDistricts().first(where: { (dist) -> Bool in
					if let id = dist.value(forKey: "id") as? String {
						return id == districtID
					}
					return false
				})
				if let district = self.selectedDistrict, let name = district.value(forKey: "name") as? String {
					self.areaButton.setTitle(name, for: .normal)
                }
			}


			if let isPhoneVerified = dict.object(forKey: "_is_phone_verified") as? String, isPhoneVerified == "1" {
				self.updatePhoneVerificationButton(verified: true)
			} else {
				self.updatePhoneVerificationButton(verified: false)
			}
            txtName.text = loginUserName
			txtLastName.text = loginUserLastName

            txtEmail.text = loginUserEmail
			if let date = Date(fromString: loginUserBirthDate, format: .custom("yyyy-MM-dd")) {
				txtBirthDate.text = date.toString(format: .custom("yyyy/MM/dd"))
			}
            txtDeliveryAddress.text = loginUserDeliveryAddress
            //txtBillingAddress.text = loginUserBillingAddress
            txtPhone.text = loginUserPhone
            
            // set imagePath
            let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
            let loadedImage = Common.instance.loadImageFromPath(imagePath)
            if loadedImage != nil {
               //print("Image loaded: \(loadedImage!)")
                self.ProfilePhoto.image = loadedImage
            }
        } else {
           //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }

	func navigateToVerifyPhone(phoneNumber:String?) {

		let authVC = FUIAuth.defaultAuthUI()
		authVC?.delegate = self

		let phone = FUIPhoneAuth(authUI: authVC!)
		authVC?.providers = [phone]
        phone.signIn(withPresenting: self, phoneNumber: phoneNumber)
	}

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		// Local variable inserted by Swift 4.2 migrator.
		let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            ProfilePhoto.contentMode = .scaleAspectFit
            ProfilePhoto.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateLocalProfile() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let dict: NSMutableDictionary = [:]
        
        dict.setObject("\(loginUserId)", forKey: "_login_user_id" as NSString)
        dict.setObject(txtName.text ?? "", forKey: "_login_user_username" as NSString)
        dict.setObject(txtLastName.text ?? "", forKey: "_login_user_lastname" as NSString)
        dict.setObject(txtEmail.text ?? "", forKey: "_login_user_email" as NSString)
        dict.setObject(loginUserProfilePhoto, forKey: "_login_user_profile_photo" as NSString)
        dict.setObject(txtPhone.text ?? "", forKey: "_login_user_phone" as NSString)
        dict.setObject(txtBirthDate.text ?? "", forKey: "_login_user_birth_date" as NSString)
        dict.setObject(txtDeliveryAddress.text ?? "", forKey: "_login_user_delivery_address" as NSString)
		dict.setObject(self.selectedDistrict?.value(forKey: "id") ?? "", forKey: "_login_user_district_id" as NSString)

		if self.verifyButton.image(for: .normal) == nil {
			dict.setObject("0", forKey: "_is_phone_verified" as NSString)
		} else {
			dict.setObject("1", forKey: "_is_phone_verified" as NSString)
		}
        dict.write(toFile: plistPath, atomically: false)
    }
    
    func animateContentView() {
        moveOffScreen()
		self.contentView?.frame.origin = self.defaultValue
		self.innerView.alpha = 1
    }
    
    fileprivate func moveOffScreen() {
        //contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!, y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }

	func updatePhoneVerificationButton(verified:Bool) {
		if verified {
			self.verifyButton.setImage(UIImage(named: "verified"), for: .normal)
			self.verifyButton.setTitle("", for: .normal)
			self.verifyButton.backgroundColor = .clear
		} else {
			self.verifyButton.setTitle("Verify Now", for: .normal)
			self.verifyButton.setImage(nil, for: .normal)
			self.verifyButton.backgroundColor = UIColor.gold
		}
	}
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}


extension UserProfileEditViewController : FUIAuthDelegate {

	/** @fn authUI:didSignInWithUser:error:<br/>
	@brief Message sent after the sign in process has completed to report the signed in user or
	error encountered.<br/>
	@param authUI The @c FUIAuth instance sending the message.<br/>
	@param user The signed in user if the sign in attempt was successful.<br/>
	@param error The error that occurred during sign in, if any.<br/>
	*/

	func authUI(_ authUI: FUIAuth, didSignInWith user: FirebaseAuth.User?, error: Error?) {
		guard let authError = error else {

            let phone = user!.phoneNumber!
            //let index = phone.index(phone.startIndex, offsetBy: phone.count-11)
            let phoneNumber = String(phone.suffix(10))
            let enteredPhoneNumber = txtPhone.text!
            var last11 : String = ""
            if(enteredPhoneNumber.count >= 10) {
                last11 = String(enteredPhoneNumber.suffix(10))
                //last11 = enteredPhoneNumber.substring(from:enteredPhoneNumber.index(enteredPhoneNumber.endIndex, offsetBy: -11))
            }
            else{
                last11 = enteredPhoneNumber
            }

			guard phoneNumber == last11 else {
				self.updatePhoneVerificationButton(verified: false)
                _ = SweetAlert().showAlert(language.profileUpdate,subTitle: "You have registered with xxxxxxx\(String(last11.suffix(3))), please use same phone number to authenticate." ,style:AlertStyle.customImag(imageFile: "Logo"))
				return
			}
			self.updatePhoneVerificationButton(verified: true)
			//Need to call Update profile API with status of phone number verification.
			updateUserInfo(isPhoneVerified:true)
			return
		}

		let errorCode = UInt((authError as NSError).code)
		switch errorCode {
		case FUIAuthErrorCode.userCancelledSignIn.rawValue:
			print("User cancelled sign-in");
			break
		default:
			let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
			print("Login error: \((detailedError as! NSError).localizedDescription)");
		}
	}
}

extension UserProfileEditViewController : UITableViewDelegate, UITableViewDataSource {

	func showPopupView() {
        
        self.view.endEditing(true);
        
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
}

//
//  TransactionHistoryTableViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 30/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Alamofire
import XLPagerTabStrip
import AcceptSDK

class TransactionHistoryTableViewController : UIViewController {
    
    var itemInfo: IndicatorInfo = "PREVIOUS"
    var loginUserId: Int = 0
    var loginUserName: String = ""
    var loginUserEmail: String = ""
    var loginUserPhone: String = ""
	var loginUserLastName: String = ""
    var isPhoneVerified: Bool = false


    var trans = [TransactionModel]()
    var completedTrans = [TransactionModel]()
    var isPedingTableActive : Bool = true

    var defaultValue: CGPoint!
    // var carbonNavigation : CarbonTabSwipeNavigation?
	var activeTransaction:TransactionModel?

    @IBOutlet weak var menuButton: UIBarButtonItem!
    let buttonColor = UIColor(displayP3Red: 0.176, green: 0.192, blue: 0.235, alpha: 1)

    //MARK:- Property
    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.backgroundColor = self.buttonColor
        }
    }

    @IBOutlet weak var pendlingListButton: UIButton! {
        didSet {
            pendlingListButton.layer.borderColor = UIColor.black.cgColor
            pendlingListButton.layer.borderWidth = 1.0
            pendlingListButton.layer.cornerRadius = 3.0
            pendlingListButton.clipsToBounds = true
        }
    }

    @IBOutlet weak var completedListButton: UIButton! {
        didSet {
            completedListButton.layer.borderColor = UIColor.black.cgColor
            completedListButton.layer.borderWidth = 1.0
            completedListButton.layer.cornerRadius = 3.0
            completedListButton.clipsToBounds = true
        }
    }
    private func configUI() {
        self.pendlingListButton.sendActions(for: .touchUpInside)
    }
    
    
	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "Order History")
		}
	}
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.estimatedRowHeight = 160
			tableView.separatorStyle = .none
			tableView.backgroundColor = .clear
			tableView.delegate = self
			tableView.dataSource = self
		}
	}
    
    
    @IBOutlet weak var completedTableView: UITableView! {
        didSet {
            completedTableView.estimatedRowHeight = 160
            completedTableView.separatorStyle = .none
            completedTableView.backgroundColor = .clear
            completedTableView.delegate = self
            completedTableView.dataSource = self
        }
    }

    @IBAction func pendinListButtonAction(_ sender: UIButton) {
        
        isPedingTableActive = true
        
        sender.backgroundColor = .black
        completedListButton.backgroundColor = self.buttonColor

        sender.isEnabled = false
        tableView.isHidden = false

        self.completedListButton.isEnabled = true
        completedTableView.isHidden = true
    }

    @IBAction func completedListButtonAction(_ sender: UIButton) {
        
        isPedingTableActive = false
        
        sender.backgroundColor = .black
        pendlingListButton.backgroundColor = self.buttonColor

        sender.isEnabled = false
        completedTableView.isHidden = false

        self.pendlingListButton.isEnabled = true
        tableView.isHidden = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        configUI()
		loadLoginUserId()
        loadTransaction()
        defaultValue = tableView?.frame.origin
        animateTableView()
    }

    func hideOrShowEarnNow(cell: TransactionCell, index: Int, transactionModel : TransactionModel){
        if transactionModel.pointsEarned == "0"{
            cell.pointsEarnedLabel.text = "Points Earned: 0" //(Tap to Earn)
        }else{
            cell.pointsEarnedLabel.text = "Points Earned: \(transactionModel.pointsEarned)"
        }
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.showCartButton()
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}
	
    internal static func instantiate(with  itemInfo: IndicatorInfo) -> TransactionHistoryTableViewController {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionHistory") as! TransactionHistoryTableViewController
        vc.itemInfo = itemInfo
        return vc
    }

    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func loadTransaction() {
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
		Alamofire.request(APIRouters.UserTransactionHistory(loginUserId)).responseCollection {
            (response: DataResponse<[Transaction]>) in
            
            _ = EZLoadingActivity.hide()
            
            if response.result.isSuccess {

				self.completedTrans.removeAll()
				self.trans.removeAll()

                if let trans: [Transaction] = response.result.value {
                    for tran in trans {
                        let oneTran = TransactionModel(transData: tran)
						if(oneTran.transactionStatus.lowercased() == "completed"){
							self.completedTrans.append(oneTran)
                        }
                        else{
                            self.trans.append(oneTran)
                        }
                    }
                    self.tableView.reloadData()
                    self.completedTableView.reloadData()
                } else {
                   //print(response)
                }
            }
        }
    }
    
    func loadLoginUserId() {
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
            loginUserId = Common.instance.getLoginUserId(dict: dict)
        } else {
           //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func animateTableView() {
        moveOffScreen()
        self.tableView?.frame.origin = self.defaultValue
    }
    
    fileprivate func moveOffScreen() {
        tableView?.frame.origin = CGPoint(x: (tableView?.frame.origin.x)!, y: (tableView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }

	@objc func payNow(_ sender:UIButton) {
		guard let cell = sender.superview?.superview?.superview as? TransactionCell, let indexPath = self.tableView.indexPath(for: cell) else {
			return
		}
		self.activeTransaction = self.trans[indexPath.row]
		guard let paymentKey = self.activeTransaction?.acceptPaymentKey else{
			return
		}
		let keyComponents = paymentKey.components(separatedBy: ":")
		if let acceptPaymentKey = keyComponents.last {
			self.LaunchCardSDKWithPaymentKey(pKey: acceptPaymentKey)
		}
		//self.getAuthenticationTokenForPayment()
	}
}

extension TransactionHistoryTableViewController : UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == completedTableView) {
            return completedTrans.count
        }else{
            return trans.count
        }
    }

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == completedTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionCell
            
            let tran : TransactionModel
            if(tableView == completedTableView) {
                tran = completedTrans[(indexPath as NSIndexPath).row]
            }
            else {
                tran = trans[(indexPath as NSIndexPath).row]
            }
            
            if(tran.is_gift == "1"){
                cell.giftIcon.isHidden = false
            }else{
                cell.giftIcon.isHidden = true
            }
            
            
            cell.configure(tran.id, paymentMethod: tran.paymentMethod, transStatus: tran.transactionStatus, total: tran.totalAmount + tran.currencySymbol)
            cell.selectionStyle = .none

            cell.detailsButton.addTarget(self, action: #selector(detailAction(_:)), for: .touchUpInside)

            cell.transactionNo.alpha = 0
            cell.totalAmount.alpha = 0
            cell.transactionStatus.alpha = 0
            cell.transIcon.alpha = 0

            cell.transactionNo.alpha = 1.0
            cell.totalAmount.alpha = 1.0
            cell.transactionStatus.alpha = 1.0
            cell.transIcon.alpha = 1.0

            let transactionModel = completedTrans[indexPath.row]
            hideOrShowEarnNow(cell: cell, index: indexPath.row, transactionModel: transactionModel)

            cell.backgroundColor = .clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionCell
            
            let tran : TransactionModel
            if(tableView == completedTableView) {
                tran = completedTrans[(indexPath as NSIndexPath).row]
            }
            else {
                tran = trans[(indexPath as NSIndexPath).row]
            }
            if(tran.paymentMethod == "poc" && tran.pickUpLocation != "0") {
                cell.locationButton.isHidden = false
            } else {
                cell.locationButton.isHidden = true
            }
                        if(tran.is_gift == "1"){
                           cell.giftIcon.isHidden = false
                       }else{
                           cell.giftIcon.isHidden = true
                       }
            

			//Set Pay Now Button
			if (tran.paymentMethod == "epayment" && tran.acceptPaymentKey.count > 0 && tran.transactionStatus.lowercased() == "unpaid") {
				cell.payNowButton.isHidden = false
			} else {
				cell.payNowButton.isHidden = true
			}
			cell.payNowButton.addTarget(self, action: #selector(payNow(_:)), for: .touchUpInside)

            cell.locationButton.tag = Int(tran.pickUpLocation)!
            cell.locationButton.addTarget(self, action: #selector(locationAction(_:)), for: .touchUpInside)

            cell.configure(tran.id, paymentMethod: tran.paymentMethod, transStatus: tran.transactionStatus, total: tran.totalAmount + tran.currencySymbol)
            cell.selectionStyle = .none

            cell.detailsButton.addTarget(self, action: #selector(detailAction(_:)), for: .touchUpInside)

            cell.transactionNo.alpha = 0
            cell.totalAmount.alpha = 0
            cell.transactionStatus.alpha = 0
            cell.transIcon.alpha = 0

            cell.transactionNo.alpha = 1.0
            cell.totalAmount.alpha = 1.0
            cell.transactionStatus.alpha = 1.0
            cell.transIcon.alpha = 1.0

            let transactionModel = trans[indexPath.row]
            hideOrShowEarnNow(cell: cell, index: indexPath.row, transactionModel: transactionModel)

            cell.backgroundColor = .clear
            return cell
        }
    }


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isPedingTableActive == true) {
            self.openTransationDetail(index: (indexPath as NSIndexPath).row, tablView: self.tableView)
        }
        else {
            self.openTransationDetail(index: (indexPath as NSIndexPath).row, tablView: self.completedTableView)
        }
	}

    @objc func locationAction(_ sender:UIButton){
		print("Location ID: \(sender.tag)")
		let imageName = "\(sender.tag).png"
		self.showOrderLocationPopup(imageName: imageName)
    }

	@objc func detailAction(_ sender:UIButton){
        if(isPedingTableActive == true) {
            if let cell = sender.superview?.superview?.superview as? TransactionCell, let indexPath = self.tableView.indexPath(for: cell) {
				self.openTransationDetail(index: (indexPath as NSIndexPath).row, tablView: self.tableView)
			}
        } else {
            if let cell = sender.superview?.superview?.superview as? TransactionCell, let indexPath = self.completedTableView.indexPath(for: cell) {
				self.openTransationDetail(index: (indexPath as NSIndexPath).row, tablView: self.completedTableView)
			}
		}
    }

    func openTransationDetail(index:Int, tablView : UITableView) {
		let tranDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "TransDetail") as? TransactionHistoryDetailViewController
			tranDetailViewController?.title = language.transactionHistoryDetail
        if(tablView == completedTableView){
        tranDetailViewController?.allTrans = completedTrans

        }else{
            tranDetailViewController?.allTrans = trans
        }
			tranDetailViewController?.rowIndex = index
			self.navigationController?.pushViewController(tranDetailViewController!, animated: true)

			   updateBackButton()
	}
}

extension TransactionHistoryTableViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}


extension TransactionHistoryTableViewController: AcceptSDKDelegate {
	//MARK: Payment API Calls
	func getAuthenticationTokenForPayment(acceptOrderId:String) {
		guard let trans = self.activeTransaction else {
			return
		}
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        let urlString = APIRouters.basePaymentURLString + APIRouters.getAuthenticationToken
        let params : Parameters = ["api_key": APIRouters.PaymentAPIKey]
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .failure:
                    // Do whatever here
                    _ = EZLoadingActivity.hide()
                    return

                case .success(let data):
                    // First make sure you got back a dictionary if that's what you expect
                    guard let json = data as? [String : AnyObject] else {
                        print("Failed to get expected response from webserver.")
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    // Then make sure you get the actual key/value types you expect
                    guard let token = json["token"] as? String else {
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    print("This is Token =  \(token)")
                    //Step 2: Get Order Id.
                    //Multiplied by 100 to get Cents.
					let amount = trans.totalAmount.floatValue
					if acceptOrderId == "" {
						let paramsStep2 : Parameters = ["auth_token": token,"delivery_needed":"false","merchant_id":APIRouters.MerchantID ,"amount_cents":String((amount.rounded(.up))*100),"currency":"EGP","merchant_order_id":trans.id]
						self.getOrderIDForPayment(params: paramsStep2)
					} else {
						let paramsStep3 : Parameters = ["auth_token": token as Any,"order_id":acceptOrderId,"expiration":"3600","amount_cents":String((amount.rounded(.up))*100),"currency":"EGP","integration_id":APIRouters.PaymentIntegrationId]
						self.getPaymentKeyPerPayment(params: paramsStep3)
					}
                }
        }
    }

    func getOrderIDForPayment(params:Parameters){
        let urlString = APIRouters.basePaymentURLString + APIRouters.getOrderId
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .failure:
                    // Do whatever here
                    _ = EZLoadingActivity.hide()
                    return

                case .success(let data):

                    // First make sure you got back a dictionary if that's what you expect
                    guard let json = data as? [String : AnyObject] else {
                        print("Failed to get expected response from webserver.")
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    //Let's handle duplicate case first. This happens when we try to get order id again for same merchant order id
                    if let message = json["message"] as? String, message == "duplicate" {
                        print("Duplicate Case")
						_ = EZLoadingActivity.hide()
                        //Get Order now by calling orders api list.
                        //let paramsStep5 : Parameters = ["auth_token": params["auth_token"] as Any,"merchant_id":APIRouters.MerchantID]
                        //self.getOrderIdFromAcceptForDuplicateCase(params: paramsStep5)
                        return
                    }

                    // Then make sure you get the actual key/value types you expect
                    guard let OrderId = json["id"] else {
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    print("This is OrderId =  \(OrderId)")
                    //Step 3:

					let paramsStep3 : Parameters = ["auth_token": params["auth_token"] as Any,"order_id":String((OrderId as! Int)),"expiration":"3600","amount_cents": params["amount_cents"]!,"currency":"EGP","integration_id":APIRouters.PaymentIntegrationId]
                    print(paramsStep3)
                    self.getPaymentKeyPerPayment(params: paramsStep3)
                }
        }
    }


    func getPaymentKeyPerPayment(params:Parameters){

        let urlString = APIRouters.basePaymentURLString + APIRouters.getPaymentKeyPerOrder
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                switch response.result {
                case .failure:
                    // Do whatever here
                    _ = EZLoadingActivity.hide()
                    return

                case .success(let data):
                    // First make sure you got back a dictionary if that's what you expect
                    guard let json = data as? [String : AnyObject] else {
                       print("Failed to get expected response from webserver.")
                        _ = EZLoadingActivity.hide()
                        return
                    }

                    // Then make sure you get the actual key/value types you expect
                    guard let KeyForPayment = json["token"] else {
                        _ = EZLoadingActivity.hide()
                        return
                    }
                    _ = EZLoadingActivity.hide()
                print("This is KeyForPayment = \(KeyForPayment)")
                //Step 4:
                //Launch Card Sdk From here
                self.LaunchCardSDKWithPaymentKey(pKey: KeyForPayment as! String)
            }
        }
    }
    func isNecessaryInfoAvailableToProcessOnlineOrder() -> Bool{
           guard loginUserName != "" else {
                     _ = SweetAlert().showAlert(language.checkoutConfirmationTitle, subTitle:language.userInfoRequiredFirstName, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                         self.openEditProfile()
                     })
                     return false
                 }
                 guard loginUserLastName != "" else {
                     _ = SweetAlert().showAlert(language.checkoutConfirmationTitle, subTitle:language.userInfoRequiredLastName, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                         self.openEditProfile()
                     })
                     return false
                 }
                 guard loginUserEmail != "" else {
                     _ = SweetAlert().showAlert(language.checkoutConfirmationTitle, subTitle:language.userInfoRequiredEmail, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                         self.openEditProfile()
                     })
                     return false
                 }
                 guard loginUserPhone != "" else {
                     _ = SweetAlert().showAlert(language.checkoutConfirmationTitle, subTitle:language.userInfoRequiredPhoneNumber, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
                         self.openEditProfile()
                     })
                     return false
                 }
           
           return true
       }
	func LaunchCardSDKWithPaymentKey(pKey: String){
		// Place your billing data here
		// billing data can not be empty
		// if empty, type in NA instead
	 if(isNecessaryInfoAvailableToProcessOnlineOrder() == false){
                       return
                   }
        
		let bData = ["apartment": "NA",
					 "email": loginUserEmail,
					 "floor": "NA",
					 "first_name": loginUserName,
					 "street": "NA",
					 "building": "NA",
					 "phone_number": loginUserPhone,
					 "shipping_method": "NA",
					 "postal_code": "NA",
					 "city": "NA",
					 "country": "NA",
					 "last_name": loginUserLastName,
					 "state": "NA"
		]
		do {
			let accept = AcceptSDK()
			accept.delegate = self
			try accept.presentPayVC(vC: self, billingData: bData, paymentKey: pKey, saveCardDefault:
			true, showSaveCard: true, showAlerts: false)
		} catch AcceptSDKError.MissingArgumentError(let errorMessage) {
			print(errorMessage)
		} catch let error {
			print(error.localizedDescription)
		}
	}

	func showPaymentFailedMsg(message:String){
        self.updateTransactionStatus(transactionStatus: "5")
      _ = SweetAlert().showAlert(language.orderFailTitle, subTitle: message, style: AlertStyle.customImag(imageFile: "Logo"))
    }

    //MARK: ACCEPT PAYMENT SDK Delegates
    func userDidCancel() {
        print("User cancelled")
		self.showPaymentFailedMsg(message: language.paymentCancelledByUser)
    }

    func paymentAttemptFailed(_ error: AcceptSDKError, detailedDescription: String) {
        print("Payment attempt Failed \(detailedDescription)")
		/*guard let paymentKey = self.activeTransaction?.acceptPaymentKey else {
			return
		}
		let keyComponents = paymentKey.components(separatedBy: ":")
		if let acceptOrderID = keyComponents.first {
			self.getAuthenticationTokenForPayment(acceptOrderId: acceptOrderID)
		} else {
			self.showPaymentFailedMsg(message: language.orderFailedOnline)
		}*/
		self.showPaymentFailedMsg(message: language.orderFailedOnline)
    }

    func transactionRejected(_ payData: PayResponse) {
        print("Transaction Rejected \(payData)")
		/*guard let paymentKey = self.activeTransaction?.acceptPaymentKey else {
			return
		}
		let keyComponents = paymentKey.components(separatedBy: ":")
		if let acceptOrderID = keyComponents.first {
			self.getAuthenticationTokenForPayment(acceptOrderId: acceptOrderID)
		} else {
			self.showPaymentFailedMsg(message: language.orderFailedOnline)
		}*/
        self.showPaymentFailedMsg(message: language.orderFailedOnline)
    }

    func transactionAccepted(_ payData: PayResponse) {
        print("Transaction Accepted \(payData)")
        self.updateTransactionStatus(transactionStatus: "4")
    }

    func transactionAccepted(_ payData: PayResponse, savedCardData: SaveCardResponse) {
        print("Transaction Accepted with saved data \(payData) And card data \(savedCardData)")
        self.updateTransactionStatus(transactionStatus: "4")
    }

    func userDidCancel3dSecurePayment(_ pendingPayData: PayResponse) {
        print("Cancelled 3d secure payment \(pendingPayData)")
        self.showPaymentFailedMsg(message: language.paymentCancelledByUser)
    }

	//MARK: Update Transaction Status
    func updateTransactionStatus(transactionStatus : String) {
		guard let trans = self.activeTransaction else {
			return
		}

        _ = EZLoadingActivity.show("Updating transaction...", disableUI: true)
		let params : Parameters = ["id": trans.id, "transaction_status":transactionStatus]
        do {
            let urlString = APIRouters.baseURLString + APIRouters.updateTransactionStatus
            try  Alamofire.request(urlString.asURL(), method: .post, parameters: params, encoding: JSONEncoding.default)
				.responseJSON { response in
					print("Response for update transaction \(response)")
					_ = EZLoadingActivity.hide()

					self.activeTransaction = nil

					switch response.result {
					case .failure:
						return

					case .success(let data):
						// First make sure you got back a dictionary if that's what you expect
						guard let json = data as? [String : AnyObject] else {
						   print("Failed to get expected response from webserver.")
							return
						}
						if json["status"] as? String == "success", transactionStatus == "4" {
							//_ = self.navigationController?.popToRootViewController(animated: true)
							_ = SweetAlert().showAlert(language.orderSuccessTitle, subTitle: language.orderSuccessOnlinePayment, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: " OK ") {
								(isOtherButton) -> Void in
								if isOtherButton == true {
									//Go back to root
									self.loadTransaction()
								}
							}
						}
					}
				}
        } catch {
            print("")
        }
     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindUserInfo()
    }

    func bindUserInfo() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: plistPath)) {
            if let bundlePath = Bundle.main.path(forResource: "LoginUserInfo", ofType: "plist") {

                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: plistPath)
                } catch {
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
            loginUserEmail        = dict.object(forKey: "_login_user_email") as! String
            loginUserPhone        = dict.object(forKey: "_login_user_phone") as! String
			loginUserLastName     = dict.object(forKey: "_login_user_lastname") as? String ?? ""
        
        } else {
           //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }

	func openEditProfile() {
		let shopProfileViewController = self.storyboard?.instantiateViewController(identifier: "ComponentUserProfileEdit") as! UserProfileEditViewController
		self.navigationController?.pushViewController(shopProfileViewController, animated: true)
	}
}

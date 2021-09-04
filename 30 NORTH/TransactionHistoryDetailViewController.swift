//
//  TransactionHistoryViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 30/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//
import UIKit
import Alamofire

class TransactionHistoryDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var allTrans = [TransactionModel]()
    var rowIndex: Int = 0
    var transModel : TransactionModel? = nil
    var transDetail: TransactionDetail? = nil
    var defaultValue: CGPoint!
    var requestTypeArray: [RequestTypeDetail]?
    

	@IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        //Get Request type detail
//        getRequestTypeAPI()
        
        // get selected transaction model
        transModel = allTrans[rowIndex]
        
        
        // set datasource and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
    
        // init the pinterest layout
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.numberOfColumns = 1
            layout.bottomPadding = 100
        }
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.showCartButton()
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
        	}

    @IBAction func onEarnNow(_ sender: Any) {
        doAddNotification()
    }
    
    func hideOrShowEarnNow(cell: TransactionHeaderCell){
        if let transactionModel = transModel{
            if transactionModel.rewardsStatus == "0"{
                cell.pointsEarnedLabel.isHidden = true
                cell.earnNowButton.isHidden = false
            }else{
                cell.pointsEarnedLabel.isHidden = false
                cell.earnNowButton.isHidden = true
                
                cell.pointsEarnedLabel.text = transactionModel.pointsEarned
            }
        }
    }
    
    //MARK: API Call
    func doAddNotification(){
        
        guard let transactionModel = transModel else { return }
        
        let params: [String: AnyObject] = [
            "shop_id"    :  transactionModel.shopId as AnyObject,
            "user_id" :  transactionModel.userId  as AnyObject,
            "transaction_id"   :  transactionModel.paymentTransId as AnyObject,
            "request_type_id": "2" as AnyObject,
            "message" : "Redeem Points Request" as AnyObject,
            "total_amount" : transactionModel.totalAmount as AnyObject,
            "status" : "1" as AnyObject
        ]
        
        _ =  Alamofire.request(APIRouters.AddNotification(params)).responseObject {
            (response: DataResponse<StdResponse>) in
           //print(response)
            if response.result.isSuccess {
                if let res = response.result.value {
                   //print("Success \(res)")
                    if res.status == "success"{
                        let msg = res.data
                        _ = SweetAlert().showAlert("Earn Now", subTitle: msg, style: AlertStyle.customImag(imageFile: "Logo"))
                    }
                }
            } else {
               //print("Fail \(response)")
            }
        }
    }
    
    func getRequestTypeAPI() {
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        Alamofire.request(APIRouters.GetRequestType).responseJSON { (response) in
		   _ = EZLoadingActivity.hide()

		   switch response.result {
		   case .success:
				   let jsonData = response.data
				   do{
					   let requestTypeJson: RequestType = try JSONDecoder().decode(RequestType.self, from: jsonData!)
					  //print(requestTypeJson)

					   if requestTypeJson.status == "success"{
						   self.requestTypeArray = requestTypeJson.data
					   }
				   }catch {
					  //print("Error: \(error)")
				   }

		   case .failure(let error):
			  print(error)
		   }
	   }
    }
    
    
    //MARK: Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transModel!.transactionDetail.count + 1 // Need to add 1 because transaction info will show in first cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.item == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionHeaderCell", for: indexPath) as! TransactionHeaderCell
            cell.configure(transModel!)
            hideOrShowEarnNow(cell: cell)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionDetailCell", for: indexPath) as! TransactionDetailCell
            
            cell.configure((transModel?.transactionDetail[indexPath.item - 1].itemName)!,
                           price: (transModel?.transactionDetail[indexPath.item - 1].unitPrice)! + (transModel?.currencySymbol)!,
                           qty: (transModel?.transactionDetail[indexPath.item - 1].qty)!,
                           attribute: (transModel?.transactionDetail[indexPath.item - 1].itemAttribute)!)

            return cell
        }
    }
}

extension TransactionHistoryDetailViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        
        // No image, So return 0
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        if indexPath.item == 0 {
            return getTransactionInfoHeight(indexPath: indexPath)
        } else {
            return 100
        }
    }
    
    func getTransactionInfoHeight (indexPath: IndexPath) -> CGFloat {
        let transInfoTopMargin : CGFloat  = 12
        let transInfoHeight : CGFloat  = 125
        let transInfoBottomMargin : CGFloat  = 19
        let lineBreakHeight : CGFloat  = 1
        let lineBreakBottomMargin : CGFloat  = 19
        
        let headingLabel : CGFloat  = 18
        var headingCount : CGFloat  = 3

        let paddingHeight : CGFloat  = 5
        var paddingCount : CGFloat  = 5

        let AddressPaddingLeft : CGFloat = 37
        let AddressPaddingRight : CGFloat = 20
        
        let bottomMargin : CGFloat = 40
        let pointsEarnedHeight : CGFloat = 0

        // Prepare for estimate label height
        let approximateWidthOfBioTextView = collectionView.frame.width - AddressPaddingLeft - AddressPaddingRight
        let size = CGSize(width: approximateWidthOfBioTextView, height : 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        
        // Est Phone height
        let estimatePhoneFrame  = NSString(string: (transModel?.phone)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estPhoneHeight : CGFloat = estimatePhoneFrame.height
        
        // Est Email height
        let estimateEmailFrame = NSString(string: (transModel?.email)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estEmailHeight : CGFloat = estimateEmailFrame.height
        
        // Est Billing Address height
        let estimateBillingFrame = NSString(string: (transModel?.billingAddress)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estBillingHeight : CGFloat = estimateBillingFrame.height
        
        // Est Delivery Address height
        let estimateDeliveryFrame = NSString(string: (transModel?.deliveryAddress)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estDeliveryHeight : CGFloat = estimateDeliveryFrame.height

		//Estimated Pickup height
        let estimatePickupFrame = NSString(string: (transModel?.pickUpLocationAddress)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estPickupHeight : CGFloat = estimatePickupFrame.height

		if estBillingHeight > 1 {
			headingCount += 1
			paddingCount += 1
		}
		if estDeliveryHeight > 1 {
			headingCount += 1
			paddingCount += 1
		}
		if estPickupHeight > 1 {
			headingCount += 1
			paddingCount += 1
		}

        let headingLabelTotal : CGFloat  = headingLabel * headingCount
        let paddingTotal : CGFloat  = paddingHeight * paddingCount

        let cellHeight = transInfoTopMargin +
            transInfoHeight +
            transInfoBottomMargin +
            lineBreakHeight +
            lineBreakBottomMargin +
            headingLabelTotal +
            paddingTotal +
            estPhoneHeight +
            estEmailHeight +
            estBillingHeight +
            estDeliveryHeight +
			estPickupHeight +
            bottomMargin + pointsEarnedHeight
        
        return cellHeight
    }
    
}


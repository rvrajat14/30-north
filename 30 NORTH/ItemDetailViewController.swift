//
//  ItemDetailViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 11/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire
import Social
import UIKit
import SQLite
import AVFoundation
import DropDown

@objc protocol ItemDetailRefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int)
}

@objc protocol ItemDetailLoginUserIdDelegate: class {
    func updateLoginUserId(_ UserId: Int)
}

@objc protocol ItemDetailBasketCountUpdateDelegate: class {
    func updateBasketCount()
}

class ItemDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, SearchDelegate {

    weak var refreshLikeCountsDelegate : RefreshLikeCountsDelegate!
    weak var refreshReviewCountsDelegate : RefreshReviewCountsDelegate!
    weak var favRefreshLikeCountsDelegate : FavRefreshLikeCountsDelegate!
    weak var favRefreshReviewCountsDelegate : FavRefreshReviewCountsDelegate!
    weak var searchRefreshLikeCountsDelegate : SearchRefreshLikeCountsDelegate!
    weak var searchRefreshReviewCountsDelegate : SearchRefreshReviewCountsDelegate!
    weak var refreshBasketCountsDelegate: RefreshBasketCountsDelegate!
    weak var basketTotalAmountUpdateDelegate: BasketTotalAmountUpdateDelegate!

    @IBOutlet weak var optionsHeightConstraint: NSLayoutConstraint! // defualt = 39
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var shopTableHeight: NSLayoutConstraint!
	@IBOutlet weak var shopListTableView: UITableView! {
		didSet {
			shopListTableView.delegate = self
			shopListTableView.dataSource = self
		}
	}
    @IBOutlet weak var attributeListTableHeight: NSLayoutConstraint!
    @IBOutlet weak var attributeItemTableHeight: NSLayoutConstraint!
	@IBOutlet weak var attributeItemTable: UITableView! {
		didSet {
			attributeItemTable.delegate = self
			attributeItemTable.dataSource = self
			attributeItemTable.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "AttributeItemCell")
		}
	}
	@IBOutlet weak var attributeListTableView: UITableView! {
		didSet {
			attributeListTableView.delegate = self
			attributeListTableView.dataSource = self
		}
	}
    @IBOutlet weak var attributeNameLabel: UILabel!
    @IBOutlet weak var attributeTableHeight: NSLayoutConstraint!
	@IBOutlet weak var attributeTableView: UITableView! {
		didSet {
			attributeTableView.delegate = self
			attributeTableView.dataSource = self
		}
	}
    @IBOutlet weak var likeCountImage: UIImageView!
    @IBOutlet weak var reviewCountImage: UIImageView!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!

    @IBOutlet weak var itemLikeCount: UILabel!
    @IBOutlet weak var itemReviewCount: UILabel!
	@IBOutlet weak var ratingPopupView: UIView! {
		didSet {
			ratingPopupView.isHidden = true
		}
	}
	@IBOutlet weak var socialSharePopupView: UIView! {
		didSet {
			socialSharePopupView.isHidden = true
		}
	}
    @IBOutlet weak var itemQty: UILabel!
    @IBOutlet weak var ratingCountView: CosmosView!
	@IBOutlet weak var ratingInputView: CosmosView! {
		didSet {
			ratingInputView.rating = 0
			ratingInputView.didFinishTouchingCosmos = didFinishTouchingCosmos
		}
	}
	@IBOutlet weak var attributePopupView: UIView! {
		didSet {
			attributePopupView.isHidden = true
		}
	}
	@IBOutlet weak var txtQty: UITextField! {
		didSet {
			txtQty.delegate = self
			txtQty.keyboardType = .numberPad
		}
	}

    @IBOutlet var mainView: UIView!
    @IBOutlet var qtyView: UIView!
    @IBOutlet var attributesStackView: UIStackView!



    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var socialSharePopupCenterX: NSLayoutConstraint!
    @IBOutlet weak var ratingPopupCenterX: NSLayoutConstraint!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var availableAtLabel: UILabel!

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var acidityView: UIView!
    @IBOutlet weak var aromaView: UIView!
    @IBOutlet weak var tasteView: UIView!
    @IBOutlet weak var profileView: UIView!

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var acidityLabel: UILabel!
    @IBOutlet weak var aromaLabel: UILabel!
    @IBOutlet weak var tasteLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!

    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!

	@IBOutlet weak var itemName: UILabel!{
		didSet {
			itemName.textAlignment = .left
			itemName.font = UIFont(name: AppFontName.bold, size: 17)
			itemName.numberOfLines = 0
		}
	}
	@IBOutlet weak var itemDescriptionLabel: UILabel! {
		didSet {
			itemDescriptionLabel.textAlignment = .left
			itemDescriptionLabel.font = UIFont(name: AppFontName.regular, size: 14)
			itemDescriptionLabel.numberOfLines = 0
		}
	}

    var shopArray : [ShopAvailability]? = nil
    var selectedSubCategoryId:Int = 0
    var selectedAttibuteItemIndex = -1
    var selectedAttibuteIndex = -1
    var selectedAttributeKey = ""
    let cellReuseIdentifier = "cell"
    let doneButton = UIButton(type: UIButton.ButtonType.custom)
    var attributesArray:[String] = []
    var attributesDetailArray:[String] = []
    var attributesDetailModelArray = [AttributeDetailModel]()
    var attributesDetailModelFilterArray = [AttributeDetailModel]()
    var attributesModelArray = [AttributeModel]()
    var attributesDetailSelectedArray = [AttributeDetailModel]()
    var attributeItemArray: [ItemAttribute]? = nil
    var selectedItemId:Int = 0
    var selectedAttributeArray = [String]()
    var selectedAttributePrice = [String]()
    var selectedAttributeTitle = [String]()

    var selectedShopId:Int = 1
    var selectedShopLat: String!
    var selectedShopLng: String!
    var selectedShopName: String!
    var selectedShopDesc: String!
    var selectedShopPhone: String!
    var selectedShopEmail: String!
    var selectedShopAddress: String!
    var selectedShopCoverImage: String!

    var selectedItemName: String = ""
    var selectedItemDesc: String = ""
    var selectedItemPrice: String = ""
    var selectedItemPriceAfterDiscount: String = ""

    var selectedItemDiscountPercent: String = ""
    var selectedItemImagePath: String = ""
    var selectedItemCurrencySymbol: String = ""
    var selectedItemCurrencyShortform: String = ""
    var selectedItemDiscountName: String = ""
    var loginUserId:Int = 0
    var itemTitle: String = ""
    var itemSubTitle: String = ""
    var selectedAttributeStr: String = ""
    var selectedAttributeIdsStr: String = ""
    var originalBeingEditedAttributeIdsStr: String = ""

    var reviews = [ReviewModel]()
    var itemImages = [ImageModel]()
    var button: UIButton = UIButton()
    var isHighLighted:Bool = false
    var buttonY: CGFloat = 20
    var calculatedPrice: Float = 0.0
    var additionalPrice: Float = 0.0
    var basketButton = MIBadgeButton()
    var itemNavi = UIBarButtonItem()
    var isBasketItem:Bool = false
    var selectedShopArrayIndex: Int!
    var isShownAlreadyBasketButton: Bool = false
    var isOpenPopup: Bool = false
    var tempPrice: String = ""
    var defaultValue: CGPoint!
    var isEditMode : Bool = false
    var navTitle : String = language.itemDetailPageTitle
    var qtyDropdown = DropDown()
    var qtyData = ["1","2","3","4","5","6","7","8","9","10+"]
    var isQtyMore = false

	var shop:Shop?
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideOutletsWhilePageLoads(hideThem: true)
		self.view.backgroundColor = UIColor.mainViewBackground

		self.qtyDropdown.dataSource = self.qtyData
        if let settings = settingsDetailModel {
            selectedItemCurrencySymbol = settings.currency_symbol!
            selectedItemCurrencyShortform = settings.currency_short_form!
        }
		self.loadShopDataFromServer()
        self.setupDoneButtonOnKeyboard()

        attributesDetailSelectedArray.removeAll()
        ratingCountView.updateOnTouch = false

        updateQtyFromBasket()

        if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {
            if(Common.instance.isUserLogin()) {
                //setupBasketButton()
                self.showCartButton()
                isShownAlreadyBasketButton = true
            }
        }
        scrollView.alpha = 1
        ratingPopupCenterX.constant -= view.bounds.width
        socialSharePopupCenterX.constant -= view.bounds.width
        defaultValue = mainView?.frame.origin
        itemImage.layer.masksToBounds = true
    }

	func refreshView() {
        self.hideOutletsWhilePageLoads(hideThem: false)
        loadItemData()
        ImageViewTapRegister()
        loadLoginUserId()
        isLikedChecking()
        isFavouritedChecking()
        addItemTouchCount()
        loadItemProperties()
        
        

	}

    func loadItemProperties() {

        bodyView.isHidden = true
        acidityView.isHidden = true
        aromaView.isHidden = true
        tasteView.isHidden = true
        profileView.isHidden = true
        itemDescriptionLabel.isHidden = true

        var isBody = true
        var isAcidity = true
        var isAroma = true
        var isTaste = true
        var isProfile = true

        let item = itemDetail!
        let body = item.body
        if body.count > 0{
            bodyView.isHidden = false
            bodyLabel.text = item.body
            isBody = false
        }

        let acidity = item.acidity
        if acidity.count > 0{
            acidityView.isHidden = false
            acidityLabel.text = item.acidity
            isAcidity = false
        }

        let aroma = item.aroma
        if aroma.count > 0 {
            aromaView.isHidden = false
            aromaLabel.text = item.aroma
            isAroma = false
        }

        let taste = item.taste
        if taste.count > 0{
            tasteView.isHidden = false
            tasteLabel.text = item.taste
            isTaste = false
        }

        let profile = item.profile
        if profile.count > 0{
            profileView.isHidden = false
            profileLabel.text = item.profile
            isProfile = false
        }

        if isProfile {
            profileView.isHidden = true
        }
        if isBody && isAcidity {
            stackView1.isHidden = true
        }
        if isTaste && isAroma {
            stackView2.isHidden = true
        }

        /*if isBody && isAcidity && isAroma && isTaste && isProfile {
            itemDescriptionLabel.isHidden = true
        }*/

		if !item.itemDesc.isEmpty {
			itemDescriptionLabel.isHidden = false
			itemDescriptionLabel.text = item.itemDesc
		}


        //           let priceNote = item.price_note
        //           let price = item.itemPrice
        //           if Int(price)! > 0{
        //               subitemPrice.text = price + " \(selectedItemCurrencySymbol) \(priceNote)"
        //           }else{
        //               subitemPrice.text = "0 \(selectedItemCurrencySymbol) \(priceNote)"
        //           }

    }
    override func viewDidLayoutSubviews(){

    }
    
    //MARK: This hides outlets until we get data from API, to make UI better.
    func hideOutletsWhilePageLoads(hideThem: Bool){
               optionsLabel.isHidden = hideThem
               availableAtLabel.isHidden = hideThem
               qtyView.isHidden = hideThem
               addToCartButton.isHidden = hideThem
               bodyView.isHidden = hideThem
               acidityView.isHidden = hideThem
               aromaView.isHidden = hideThem
               tasteView.isHidden = hideThem
               profileView.isHidden = hideThem
               itemDescriptionLabel.isHidden = hideThem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        self.showCartButton()

    }

    @IBAction func FacebookShare(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)

            facebookSheet.setInitialText(language.shareMessage)
            facebookSheet.add(URL(string: language.shareURL))

            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: language.accountLogin, message: language.fbLogin, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func TwitterShare(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(language.shareMessage)
            twitterSheet.add(URL(string: language.shareURL))
            self.present(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: language.accountLogin, message: language.twLogin, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func configDropdown(dropdown: DropDown, sender: UIView) {
        dropdown.anchorView = sender
        dropdown.direction = .any
        dropdown.dismissMode = .onTap
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.bounds.height)
        dropdown.width = sender.frame.size.width
        dropdown.cellHeight = 40.0
        dropdown.backgroundColor = UIColor.white
    }

    @IBAction func GoToShopProfile(_ sender: AnyObject) {
        let shopProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShopProfileViewController") as? ShopProfileViewController
        shopProfileViewController?.title = language.shopProfile

//        shopProfileViewController?.selectedShopId = selectedShopId
        shopProfileViewController?.selectedShopName = selectedShopName
        shopProfileViewController?.selectedShopDesc = selectedShopDesc
        shopProfileViewController?.selectedShopPhone = selectedShopPhone
        shopProfileViewController?.selectedShopEmail = selectedShopEmail
        shopProfileViewController?.selectedShopAddress = selectedShopAddress
        shopProfileViewController?.selectedShopLat = selectedShopLat
        shopProfileViewController?.selectedShopLng = selectedShopLng
        shopProfileViewController?.selectedShopCoverImage = selectedShopCoverImage

        self.navigationController?.pushViewController(shopProfileViewController!, animated: true)
        updateBackButton()

    }


    @IBAction func attributePopupClose(_ sender: AnyObject) {

        if(isOpenPopup == true) {
            self.attributePopupView.isHidden = true
            isOpenPopup = false
        }
    }


    @IBAction func socialSharePopupClose(_ sender: AnyObject) {
        if(isOpenPopup == true) {
            self.socialSharePopupView.isHidden = true
            socialSharePopupCenterX.constant -= view.bounds.width
            isOpenPopup = false
        }
    }


    @IBAction func attributePopupSelect(_ sender: AnyObject) {
        if selectedAttibuteIndex == -1{
            _ = SweetAlert().showAlert("30 North", subTitle: "Please choose any attribute.", style: AlertStyle.customImag(imageFile: "Logo"))
         return
        }

        let headerId = attributesDetailModelFilterArray[selectedAttibuteIndex].headerId
        attributesDetailSelectedArray = attributesDetailSelectedArray.filter({$0.headerId != headerId})

        let selectedAttribute = AttributeDetailModel(id: attributesDetailModelFilterArray[selectedAttibuteIndex].id,
                                                     shopId: attributesDetailModelFilterArray[selectedAttibuteIndex].shopId,
                                                     headerId: attributesDetailModelFilterArray[selectedAttibuteIndex].headerId,
                                                     itemId: attributesDetailModelFilterArray[selectedAttibuteIndex].itemId,
                                                     name: attributesDetailModelFilterArray[selectedAttibuteIndex].name,
                                                     additionalPrice: attributesDetailModelFilterArray[selectedAttibuteIndex].additionlPrice)

        attributesDetailSelectedArray.append(selectedAttribute)

        additionalPrice = 0.0

        attributePopupView.isHidden = true

        selectedAttributeStr = ""
        selectedAttributeIdsStr = ""
        if(attributesDetailSelectedArray.count > 0) {
            for attDetail in attributesDetailSelectedArray {
                selectedAttributeStr += attDetail.name + ","
                selectedAttributeIdsStr += attDetail.id + ","
                additionalPrice += set0ForEmtpyString(amount: attDetail.additionlPrice)
            }
            selectedAttributeStr = String(selectedAttributeStr.dropLast())
            selectedAttributeIdsStr = String(selectedAttributeIdsStr.dropLast())
        }

        if selectedAttributeArray.count < 1 {
            setupAttributeArray()
        }
        selectedAttributeArray[selectedAttibuteItemIndex] = attributesDetailModelFilterArray[selectedAttibuteIndex].name
        selectedAttributePrice[selectedAttibuteItemIndex] = attributesDetailModelFilterArray[selectedAttibuteIndex].additionlPrice + " " + selectedItemCurrencySymbol
//        selectedAttributes.text = "Selected " + selectedAttributeKey + " : (" + selectedAttributeStr + ")"

        for index in 0..<self.attributesModelArray.count {
            if self.attributesModelArray[index].id == selectedAttribute.headerId {
                self.attributesModelArray[index].name = selectedAttribute.name
            }
        }

        //update price
        if(additionalPrice != 0.0) {
            calculatedPrice = Float(selectedItemPriceAfterDiscount)! + additionalPrice

            var totAmt = calculatedPrice
            if let qty = txtQty.text, qty.count > 0{
                totAmt = calculatedPrice * Float(qty)!
            }
            
//            if(selectedItemDiscountName == "") {
//                totalPriceLabel.text = language.total + String(totAmt) + " " + selectedItemCurrencySymbol
//            } else {
//                self.totalPriceLabel.text = language.total + String(totAmt) + " " + self.selectedItemCurrencySymbol + " (After Discount)"
//            }
            
            let priceStr = language.total + String(totAmt) + " " + selectedItemCurrencySymbol
            if(itemDetail.discountPercent != ""){
                //self.totalPriceLabel.text = language.total + String(totAmt) + " " + self.selectedItemCurrencySymbol + " (After Discount)"
                let attrString = NSMutableAttributedString(string: priceStr, attributes: [NSAttributedString.Key.font: customFont.totalPriceLabelFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]);
                attrString.append(NSMutableAttributedString(string: " (After Discount)", attributes: [NSAttributedString.Key.font: customFont.totalPriceDiscountFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]));
                self.totalPriceLabel.attributedText = attrString
            }else{
                let attrString = NSMutableAttributedString(string: priceStr, attributes: [NSAttributedString.Key.font: customFont.totalPriceLabelFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]);
                self.totalPriceLabel.attributedText = attrString
            }
            
            
            
            
            selectedItemPrice = String(calculatedPrice)

        }

       //print("selectedAttributeArray: ",selectedAttributeArray)
        attributeTableView.reloadData()
        attributeItemTable.reloadData()
        attributeListTableView.reloadData()
        isOpenPopup = false
//        attributePopupCenterX.constant -= view.bounds.width

    }

    @IBAction func AddNewRating(_ sender: AnyObject) {
        if(isOpenPopup == false) {
            showRatingPopupView()
        }
    }

    @IBAction func CloseRatingPopup(_ sender: AnyObject) {
        if(isOpenPopup == true) {
            ratingPopupView.isHidden = true
            ratingPopupCenterX.constant -= view.bounds.width
            isOpenPopup = false
        }
    }


    fileprivate func didFinishTouchingCosmos(_ rating: Double) {
        if(loginUserId != 0) {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)

            let params: [String: AnyObject] = [
                "appuser_id": loginUserId as AnyObject,
                "shop_id"   : "1" as AnyObject,
                "rating"    : ratingInputView.rating as AnyObject
            ]

            _ = Alamofire.request(APIRouters.AddItemRating(selectedItemId, params)).responseObject{
                (response: DataResponse<StdResponse>) in

                _ = EZLoadingActivity.hide()

                if response.result.isSuccess {
                    if let res = response.result.value {
                        if(res.status! == "success") {
                            self.ratingInputView.rating = Double(res.data!)!
//                            self.itemRatingCount.text = language.rating + String(res.data!)

                            self.ratingCountView.rating = Double(res.data!)!

                            self.ratingInputView.rating = 0
                            self.ratingPopupView.isHidden = true
                            self.ratingPopupCenterX.constant -= self.view.bounds.width
                            self.isOpenPopup = false

                        } else {
                            if(res.data! == "already_rated") {
                                _ = SweetAlert().showAlert(language.ratingTitle, subTitle: language.alreadyRated, style: AlertStyle.customImag(imageFile: "Logo"))
                            } else {
                                _ = SweetAlert().showAlert(language.ratingTitle, subTitle: language.ratingProblem, style: AlertStyle.customImag(imageFile: "Logo"))
                            }
                        }

                    }
                } else {
                   //print(response)
                }
            }
        } else {
            _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.customImag(imageFile: "Logo"))
            ratingInputView.rating = 0
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        //TOFIX
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /*
        if tableView == self.tableView{
        let totalCount = self.attributesModelArray.count - 1
       //print("Current Index \(indexPath.item) & total count \(totalCount)")
        if(indexPath.item == totalCount ) {
           //print("Attribute Count : \(self.attributesModelArray.count)")
            if(self.attributesModelArray.count > 0) {

                var heightOfTableView: CGFloat = 0.0
                // Get visible cells and sum up their heights
                let cells = self.tableView.visibleCells
                for cell in cells {
                    heightOfTableView += cell.frame.height
                }

                tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
                tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                attributeViewHeight.constant = tableView.frame.height + 50
//                shopProfileButtonTop.constant = tableView.frame.height + 50
               //print("Attribute Height : \(attributeViewHeight.constant)")
                scrollView.contentSize.height = scrollView.contentSize.height + attributeViewHeight.constant + 70
            }else {
                tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 0)
                tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
                attributeViewHeight.constant = 0
//                shopProfileButtonTop.constant = 10
               //print("Attribute Height : \(attributeViewHeight.constant)")
                scrollView.contentSize.height = scrollView.contentSize.height + attributeViewHeight.constant + 70
            }
        }
        }*/
    }

    @IBAction func doOpenInquiryView(_ sender: Any) {
        let inquiryFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "InquiryViewController") as? InquiryEntryViewController
        inquiryFormViewController?.selectedItemId = selectedItemId
        inquiryFormViewController?.selectedShopId = 1
        self.navigationController?.pushViewController(inquiryFormViewController!, animated: true)
        updateBackButton()
    }

	@objc func onAttributeAction(_ sender:UIButton) {
		openAttributePopup(index: sender.tag-1)
	}

	func configureAttributedItemCell(table:UITableView, indexPath:IndexPath) -> UITableViewCell {
		let cell = table.dequeueReusableCell(withIdentifier: "AttributeItemCell", for: indexPath)

		var tag:Int = 1
		var rect = CGRect(x: 0, y: 8, width: 100, height: 44)

		for item in self.selectedAttributeTitle {
			var aButton = cell.contentView.viewWithTag(tag) as? UIButton
			if aButton == nil {
				aButton = UIButton(type: .custom)
				aButton?.tag = tag
				//aButton?.backgroundColor = UIColor(displayP3Red: 0.815, green: 0.521, blue: 0.043, alpha: 1)
                aButton?.backgroundColor = UIColor.thirtyNorthGold
				aButton?.setTitleColor(.white, for: .normal)
				aButton?.addTarget(self, action: #selector(onAttributeAction(_:)), for: .touchUpInside)

				aButton?.layer.cornerRadius = 3.0
				aButton?.clipsToBounds = true

				cell.contentView.addSubview(aButton!)
			}
			aButton?.setTitle("  + \(item)  ", for: .normal)
			aButton?.frame = rect

			aButton?.sizeToFit()
			rect = aButton!.frame
			if rect.maxX > UIScreen.main.bounds.width {
				//check current button rect for right margin
				rect.origin.x = 0
				rect.origin.y = rect.maxY + 8

				aButton?.frame = rect
				aButton?.sizeToFit()
			}

			//Calculate rect for next button
			rect.origin.x = (rect.maxX + 8)
			if rect.maxX >= UIScreen.main.bounds.width {
				rect.origin.x = 0
				rect.origin.y = rect.maxY + 8
			}
			tag += 1
		}

		cell.selectionStyle = .none

		let backView = UIView(frame: cell.bounds)
		backView.backgroundColor = .black
		cell.backgroundView = backView

		return cell
	}


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == attributeTableView{
            return 60
        }else if tableView == attributeListTableView{
            return 30
        }else if tableView == attributeItemTable{
			return attributeItemTable.frame.height
        }else if tableView == shopListTableView{
            return 30
        }
        return 30
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == attributeTableView{
            return self.attributesDetailModelFilterArray.count
        }else if tableView == attributeListTableView{
            return self.attributesModelArray.count
        }else if tableView == attributeItemTable{
			return 1
            /*let count = self.selectedAttributeArray.count
            let rowCount = count / 2
            let rem = count % 2
            var totalCount = 0
            if rem == 0{
                totalCount = rowCount
            }else{
                totalCount = rowCount + 1
            }
           //print("totalCount : ",totalCount)
            return totalCount*/
        }else if tableView == shopListTableView{
			guard let item = itemDetail else {
                availableAtLabel.isHidden = true
				return 0
			}
            //availableAtLabel.isHidden = false
            return item.shops.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            if tableView == attributeTableView {
				let cell = tableView.dequeueReusableCell(withIdentifier: "AttributesListTableViewCell") as! AttributesListTableViewCell
				cell.titleButton.tag = indexPath.row;
				if indexPath.row < self.attributesDetailModelFilterArray.count {
					let attribute = self.attributesDetailModelFilterArray[indexPath.row]
					var title = attribute.name
					if attribute.additionlPrice.floatValue > 0 {
						title.append(" (\(attribute.additionlPrice) \(self.selectedItemCurrencySymbol))")
					}
					cell.titleButton.setTitle(title, for: .normal)
					if selectedAttibuteIndex == indexPath.row{
						cell.plusImage.image = UIImage(named: "ic_radio_check")
					}else{
						cell.plusImage.image = UIImage(named: "ic_radio_uncheck")
					}
				}
				return cell
            } else if tableView == attributeItemTable {
				return self.configureAttributedItemCell(table: tableView, indexPath: indexPath)
            } else if tableView == attributeListTableView{
				let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeListTableViewCell") as! AttributeListTableViewCell
                let title = selectedAttributeTitle[indexPath.row] + " :"
                let selectedAttName = selectedAttributeArray[indexPath.row]
                let selectedAttPrice = selectedAttributePrice[indexPath.row]
                cell.attributeTitle.text = title
                if selectedAttName == ""{
                    cell.attributeName.text = "Please Choose"
                }else{
                    cell.attributeName.text = selectedAttName
                }
				if let price = selectedAttPrice.components(separatedBy: " ").first?.floatValue, price > 0 {
					cell.price.text = selectedAttPrice
				} else {
					cell.price.text = nil
				}
                return cell
        } else if tableView == shopListTableView{
			let cell = tableView.dequeueReusableCell(withIdentifier: "ShopListTableViewCell") as! ShopListTableViewCell
			cell.titleLabel.text = "" //itemDetail.shops[indexPath.row].shopName
			return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /*if tableView == self.tableView{

            let attId: String = attributesModelArray[(indexPath as NSIndexPath).row].id
            attributesDetailModelFilterArray = attributesDetailModelArray.filter({$0.headerId == attId})

            //        pickerView.reloadAllComponents()

            if(isOpenPopup == false) {
                attributePopupView.isHidden = true
                showAttributePopupView()
            }
        }*/
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.attributesDetailModelFilterArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.attributesDetailModelFilterArray[row].name
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black

        if(self.attributesDetailModelFilterArray[row].additionlPrice == "0") {
            pickerLabel.text = self.attributesDetailModelFilterArray[row].name
        } else {
            pickerLabel.text = self.attributesDetailModelFilterArray[row].name + " (" + self.attributesDetailModelFilterArray[row].additionlPrice + selectedItemCurrencySymbol + ")"
        }

        pickerLabel.font = UIFont(name: customFont.normalFontName , size: CGFloat(customFont.pickerFontSize))
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }

    func showAttributePopupView() {
        attributeNameLabel.text = selectedAttributeTitle[selectedAttibuteItemIndex]
        attributePopupView.isHidden = false
        attributePopupView.layer.cornerRadius = CGFloat(8)
        attributePopupView.layer.borderWidth = 1
        attributePopupView.layer.borderColor = UIColor.black.cgColor
        attributePopupView.clipsToBounds = true

        let count = self.attributesDetailModelFilterArray.count
        if count > 3{
            attributeTableHeight.constant = CGFloat(4 * 60) + 100
        }else{
            attributeTableHeight.constant = CGFloat(count * 60) + 100
        }
        UIView.animate(withDuration: 0.5) {
            //            self.attributePopupCenterX.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }

        isOpenPopup = true
    }

    func showRatingPopupView() {
        ratingPopupView.isHidden = false
        ratingPopupView.layer.cornerRadius = CGFloat(5)
        ratingPopupView.layer.borderWidth = 1
        ratingPopupView.layer.borderColor = UIColor.red.cgColor
        ratingPopupView.clipsToBounds = true

        UIView.animate(withDuration: 0.5) {
            self.ratingPopupCenterX.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }
        isOpenPopup = true

    }

    @IBAction func doShowSocialSharePopupView(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: ["Hello"+language.shareMessage, NSURL(string: language.shareURL)!], applicationActivities: nil)

        self.present(vc, animated: true, completion: nil)
        if let popOver = vc.popoverPresentationController {
            popOver.sourceView = sender as? UIView
            popOver.permittedArrowDirections = .init(rawValue: 0)

        }
    }


    func showSocialSharePopupView() {
        socialSharePopupView.isHidden = false
        socialSharePopupView.layer.cornerRadius = CGFloat(5)
        socialSharePopupView.layer.borderWidth = 1
        socialSharePopupView.layer.borderColor = UIColor.red.cgColor
        socialSharePopupView.clipsToBounds = true

        UIView.animate(withDuration: 0.5) {
            self.socialSharePopupCenterX.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }
        isOpenPopup = true


    }

    func updateQtyFromBasket() {

        let id : Int64 = checkItemInBasket().0
       //print(" ID : \(id)")
        if( id != 0) {
            for basket in BasketTable.getByKeyIds("1", selectedId: id) {
               //print(" Basket ID : \(String(describing: basket.id))")
                if(basket.id != 0) {
                    isBasketItem = true
                    txtQty.text = String(basket.qty!)

//                    self.hideShowPriceHeight(totalPrice: Int(calculatedPrice))
//                    if let qty = txtQty.text, qty.count > 0{
//                        calculatedPrice = calculatedPrice * Float(qty)!
//                    }
//                    itemPrice.text = language.price + String(calculatedPrice) + " " + selectedItemCurrencySymbol
                    txtQty.layer.cornerRadius = 5.0
                    txtQty.layer.masksToBounds = true
                    txtQty.layer.borderColor = Common.instance.colorWithHexString(configs.barColorCode).cgColor
                    txtQty.layer.borderWidth = 1.0
                }else {
                    isBasketItem = false
                }
            }
        }


    }

    func checkItemInBasket() -> (Int64,Int64) {

        if(self.originalBeingEditedAttributeIdsStr == ""){
            self.originalBeingEditedAttributeIdsStr = String(self.selectedAttributeIdsStr)
        }

        // Editing item if we are coming from cart view
        let vc = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2]
        print ("\(String(describing: vc?.description))")
        if vc!.isKind(of: BasketViewController.classForCoder()) {
           //print("Update Logic")
            let tempSring = selectedAttributeIdsStr
            selectedAttributeIdsStr = self.originalBeingEditedAttributeIdsStr
            self.originalBeingEditedAttributeIdsStr = tempSring
        }
       //print("selected item id : \(String(selectedItemId))")
       //print("selected item attr : \(String(selectedAttributeIdsStr))")
       //print("Original item attr : \(String(originalBeingEditedAttributeIdsStr))")

        //let id = BasketTable.getByIdsAndAttrs(String(selectedItemId), paramAttrIds: self.selectedAttributeIdsStr)
        let id = BasketTable.getByIdsAndAttrs(String(selectedItemId), paramAttrIds:self.selectedAttributeIdsStr)

       //print("Check ID \(id)")
        return id
    }


    func loadItemData() {

            self.bindItemData()

            if(itemDetail.reviews.count > 0){
                for review in itemDetail.reviews {
                    let oneReview = ReviewModel(review: review)
                    self.reviews.append(oneReview)
                }
            }

            if(itemDetail.images.count > 0) {
                for image in itemDetail.images {
                    let oneImage = ImageModel(image: image)
                    self.itemImages.append(oneImage)

                }
            }

            if(itemDetail.attributes.count > 0) {
                //self.attributeItemArray = item.attributes
                //
                for att in itemDetail.attributes {
                    self.attributesArray.append(language.availableDiferent + att.name!)
                    let oneAttribute = AttributeModel(att: att)
                    self.attributesModelArray.append(oneAttribute)

                    if(att.attributesDetail.count > 0) {
                        for attDetail in att.attributesDetail {
                            let oneDetail = AttributeDetailModel(attDetail: attDetail)
                            self.attributesDetailModelArray.append(oneDetail)
                            self.attributesDetailModelFilterArray.append(oneDetail)
                        }
                    }
                    //                            self.pickerView.reloadAllComponents()
                    self.attributeTableView.reloadData()
                }
               //print("item.attributes : ",itemDetail.attributes)

               //print("attributesArray : ",self.attributesModelArray)


                // TP TODO
                if self.selectedAttributeStr != "" && self.selectedAttributeIdsStr != "" {

                    let selectedAttrIdsArray = self.selectedAttributeIdsStr.split(separator: ",")
                    let selectedAttrArray = self.selectedAttributeStr.split(separator: ",")
                    var tmpAttrPrice : Int = 0

                    for selectedIndex in 0..<selectedAttrIdsArray.count {
                        for headerIndex in 0..<self.attributesModelArray.count {
                            let tmpAttrDetail = self.attributesModelArray[headerIndex].attributeDetail
                            for index in 0..<tmpAttrDetail.count {

                                if let tmpId = tmpAttrDetail[index].id {

                                    if String(describing : selectedAttrIdsArray[selectedIndex]) == String(describing : tmpId) {
                                       //print(" IDS -> \(String(describing : selectedAttrIdsArray[selectedIndex])) , \(String(describing : tmpId))")
                                        self.attributesModelArray[headerIndex].name = String(selectedAttrArray[selectedIndex])


                                        for tmpDetailModel in self.attributesDetailModelArray {
                                            print (" detail ids \(tmpDetailModel.id) - \(tmpId)")
                                            if tmpDetailModel.id == tmpId {

                                                tmpAttrPrice = tmpAttrPrice + Int(tmpDetailModel.additionlPrice)!

                                                let selectedAttribute = AttributeDetailModel(id: tmpDetailModel.id ,
                                                                                             shopId: tmpDetailModel.shopId,
                                                                                             headerId: tmpDetailModel.headerId,
                                                                                             itemId: tmpDetailModel.itemId,
                                                                                             name: tmpDetailModel.name,
                                                                                             additionalPrice: tmpDetailModel.additionlPrice)

                                                self.attributesDetailSelectedArray.append(selectedAttribute)

                                            }
                                        }

                                    }
                                }
                            }

                        }
                    }
                    if tmpAttrPrice > 0 {
                       //print("Selected Item Price :\(self.selectedItemPrice)")
                       //print("Selected Attr Price : \(tmpAttrPrice)")

                        var price = self.selectedItemPrice
                        if self.selectedItemPrice.contains("-"){
                            let arrPrice = self.selectedItemPrice.components(separatedBy: "-")
                            price = arrPrice[1]
                        }
                       //print(price)
                        var totalPrice = Int(price)! + tmpAttrPrice
                        self.selectedItemPrice = String(totalPrice)
                        if self.txtQty.text!.count > 0{
                            totalPrice = totalPrice * Int(self.txtQty.text!)!
                        }
                        
                        let priceStr = language.total + String(totalPrice) + " " + self.selectedItemCurrencySymbol
                        if(itemDetail.discountPercent != ""){
                            //self.totalPriceLabel.text = language.total + String(totAmt) + " " + self.selectedItemCurrencySymbol + " (After Discount)"
                            let attrString = NSMutableAttributedString(string: priceStr, attributes: [NSAttributedString.Key.font: customFont.totalPriceLabelFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]);
                            attrString.append(NSMutableAttributedString(string: " (After Discount)", attributes: [NSAttributedString.Key.font: customFont.totalPriceDiscountFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]));
                            self.totalPriceLabel.attributedText = attrString
                        }else{
                            let attrString = NSMutableAttributedString(string: priceStr, attributes: [NSAttributedString.Key.font: customFont.totalPriceLabelFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]);
                            self.totalPriceLabel.attributedText = attrString
                        }
                    }
                }
            }

//            if(item.shops.count > 0) {
//                self.shopArray = item.shops
//            }

            self.setupAttributeArray()
        }

    /*
    func loadItemData(_ ItemId:Int, ShopId:Int) {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)


        _ = Alamofire.request(APIRouters.ItemById(ItemId, ShopId)).responseObject {
            (response: DataResponse<Item>) in
            _ = EZLoadingActivity.hide()
            if response.result.isSuccess {

                if let item: Item = response.result.value {
                    self.bindItemData(item)

                    if(item.reviews.count > 0){
                        for review in item.reviews {
                            let oneReview = ReviewModel(review: review)
                            self.reviews.append(oneReview)
                        }
                    }

                    if(item.images.count > 0) {
                        for image in item.images {
                            let oneImage = ImageModel(image: image)
                            self.itemImages.append(oneImage)

                        }
                    }

                    if(item.attributes.count > 0) {
//                        self.attributeItemArray = item.attributes
//

                        for att in item.attributes {
                            self.attributesArray.append(language.availableDiferent + att.name!)
                            let oneAttribute = AttributeModel(att: att)
                            self.attributesModelArray.append(oneAttribute)

                            if(att.attributesDetail.count > 0) {
                                for attDetail in att.attributesDetail {
                                    let oneDetail = AttributeDetailModel(attDetail: attDetail)
                                    self.attributesDetailModelArray.append(oneDetail)
                                    self.attributesDetailModelFilterArray.append(oneDetail)
                                }
                            }
//                            self.pickerView.reloadAllComponents()
                                self.attributeTableView.reloadData()
                        }
                       //print("item.attributes : ",item.attributes)

                       //print("attributesArray : ",self.attributesModelArray)


                        // TP TODO
                        if self.selectedAttributeStr != "" && self.selectedAttributeIdsStr != "" {

                            let selectedAttrIdsArray = self.selectedAttributeIdsStr.split(separator: ",")
                            let selectedAttrArray = self.selectedAttributeStr.split(separator: ",")
                            var tmpAttrPrice : Int = 0

                            for selectedIndex in 0..<selectedAttrIdsArray.count {
                                for headerIndex in 0..<self.attributesModelArray.count {
                                    let tmpAttrDetail = self.attributesModelArray[headerIndex].attributeDetail
                                    for index in 0..<tmpAttrDetail.count {

                                        if let tmpId = tmpAttrDetail[index].id {

                                            if String(describing : selectedAttrIdsArray[selectedIndex]) == String(describing : tmpId) {
                                               //print(" IDS -> \(String(describing : selectedAttrIdsArray[selectedIndex])) , \(String(describing : tmpId))")
                                                self.attributesModelArray[headerIndex].name = String(selectedAttrArray[selectedIndex])


                                                for tmpDetailModel in self.attributesDetailModelArray {
                                                    print (" detail ids \(tmpDetailModel.id) - \(tmpId)")
                                                    if tmpDetailModel.id == tmpId {

                                                        tmpAttrPrice = tmpAttrPrice + Int(tmpDetailModel.additionlPrice)!

                                                        let selectedAttribute = AttributeDetailModel(id: tmpDetailModel.id ,
                                                                                                     shopId: tmpDetailModel.shopId,
                                                                                                     headerId: tmpDetailModel.headerId,
                                                                                                     itemId: tmpDetailModel.itemId,
                                                                                                     name: tmpDetailModel.name,
                                                                                                     additionalPrice: tmpDetailModel.additionlPrice)

                                                        self.attributesDetailSelectedArray.append(selectedAttribute)

                                                    }
                                                }

                                            }
                                        }
                                    }

                                }
                            }
                            if tmpAttrPrice > 0 {
                               //print("Selected Item Price :\(self.selectedItemPrice)")
                               //print("Selected Attr Price : \(tmpAttrPrice)")

                                var price = self.selectedItemPrice
                                if self.selectedItemPrice.contains("-"){
                                    let arrPrice = self.selectedItemPrice.components(separatedBy: "-")
                                    price = arrPrice[1]
                                }
                               //print(price)
                                var totalPrice = Int(price)! + tmpAttrPrice
                                self.selectedItemPrice = String(totalPrice)
                                if self.txtQty.text!.count > 0{
                                    totalPrice = totalPrice * Int(self.txtQty.text!)!
                                }
                                self.totalPriceLabel.text = language.total + String(totalPrice) + " " + self.selectedItemCurrencySymbol
                               //print("attributesArray : ",self.attributesArray)

//                                self.hideShowPriceHeight(totalPrice: totalPrice)

                            }
                        }
                    }

                    if(item.shops.count > 0) {
                        self.shopArray = item.shops
                    }

                    self.setupAttributeArray()
                }

            }
        }

    }
    */

    func setupAttributeArray(){
        self.selectedAttributeArray.removeAll()
        self.selectedAttributePrice.removeAll()
        for i in 0..<self.attributesModelArray.count{
            self.selectedAttributeArray.append("")
            self.selectedAttributePrice.append("")
            let title = self.attributesModelArray[i].name
            self.selectedAttributeTitle.append(title)
        }

        let count = self.selectedAttributeArray.count
            let rowCount = count / 2
            let rem = count % 2
            var totalCount = 0
            if rem == 0{
                totalCount = rowCount
            }else{
                totalCount = rowCount + 1
            }
           //print("count : ", count)
            self.attributeItemTableHeight.constant = CGFloat(40 * totalCount)
            self.attributeListTableHeight.constant = CGFloat(30 * self.selectedAttributeArray.count)

        if count == 0{
            optionsLabel.isHidden = true
            self.optionsHeightConstraint.constant = 0
            self.attributeItemTableHeight.constant = 0
        }
//        var shopCount = 0
//         let shopArr = itemDetail.shops
//            shopCount = shopArr.count
//
//        if shopCount == 0{
//            shopCount = 1
//        }
        
        //showing values in a label
        //self.shopTableHeight.constant = CGFloat(30 * itemDetail.shops.count)
        self.shopTableHeight.constant = 0.0
        self.attributeItemTable.reloadData()
        self.attributeListTableView.reloadData()
        
        
        
        //We do not need shop list table view. We are showing data in a label
        if(itemDetail.shops.count > 0){
            
            let font = UIFont.systemFont(ofSize: 16, weight: .medium)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.init(red: 251/255, green: 151/255, blue: 4/255, alpha: 1.0),
            ]
            let attributedString1 : NSAttributedString = NSAttributedString(string: "Available at: ", attributes: attributes)

            var arrShopNames : [String] = []
            availableAtLabel.isHidden = false
            for item in itemDetail.shops {
                arrShopNames.append(item.shopName!)
            }
            let concatenatedString : String = arrShopNames.joined(separator: ", ")
            
            let font1 = UIFont.systemFont(ofSize: 16, weight: .regular)
            let attributes1: [NSAttributedString.Key: Any] = [
                .font: font1,
                .foregroundColor: UIColor.white,
            ]
            let attributedString2 = NSAttributedString(string: concatenatedString, attributes: attributes1)

            let result = NSMutableAttributedString()
            result.append(attributedString1)
            result.append(attributedString2)
           
            availableAtLabel.attributedText = result
        }else{
            availableAtLabel.isHidden = true
        }
        self.shopListTableView.reloadData()
    }

    func loadShopDataFromServer() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)

        _ = Alamofire.request(APIRouters.GetShopByID(1)).responseObject {
            (response: DataResponse<Shop>) in

            _ = EZLoadingActivity.hide()

            if response.result.isSuccess {
                if let shop: Shop = response.result.value {
					self.shop = shop
					self.fetchItem(itemID: self.selectedItemId)
                }
            } else {
				print("Error loadng data")
            }
        }
    }

	func fetchItem(itemID:Int) {
		guard let shop = self.shop else {
			self.loadShopDataFromServer()
			return
		}
		var itemsArr = [ItemModel]()
		for cat in shop.categories {
			for subCat in cat.subCategories {
				for item in subCat.item {
					let oneItem = ItemModel(item: item)
					itemsArr.append(oneItem)
				}
			}
		}
		let item = itemsArr.first { (item) -> Bool in
			return item.itemId == "\(itemID)"
		}
		itemDetail = item
		self.refreshView()
	}

    func bindItemData() {
		itemName.text = itemDetail.itemName
		itemLikeCount.text = String(itemDetail.itemLikeCount)
		itemReviewCount.text = String(itemDetail.itemReviewCount)
        
        //totalPriceLabel.text = language.total + itemDetail.itemPrice + " " + settingsDetailModel!.currency_symbol!
        let priceStr = language.total + itemDetail.itemPrice + " " + settingsDetailModel!.currency_symbol!
         let attrString = NSMutableAttributedString(string: priceStr, attributes: [NSAttributedString.Key.font: customFont.totalPriceLabelFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]);
        self.totalPriceLabel.attributedText = attrString
        
		calculatedPrice = set0ForEmtpyString(amount: itemDetail.itemPrice)
		itemQty.text = language.qty
		if(itemDetail.ratingCount != 0.0) {
			ratingCountView.rating = Double(itemDetail.ratingCount)
		} else {
			ratingCountView.rating = 0
		}
		selectedItemPrice = itemDetail.itemPrice
		if(itemDetail.discountTypeId != "0") {
			if itemDetail.itemPrice != ""{
				calculatedPrice = set0ForEmtpyString(amount: itemDetail.itemPrice) - (set0ForEmtpyString(amount: itemDetail.discountPercent) * set0ForEmtpyString(amount: itemDetail.itemPrice))/100
			}
			tempPrice = language.price + String(calculatedPrice) + " " + settingsDetailModel!.currency_symbol!
			selectedItemPrice = String(calculatedPrice)
			selectedItemPriceAfterDiscount = String(calculatedPrice)
			selectedItemDiscountName = itemDetail.discountName
            //totalPriceLabel.text = language.total + selectedItemPriceAfterDiscount + " " + settingsDetailModel!.currency_symbol! + " (After Discount)"
            
            let priceStr = language.total + selectedItemPriceAfterDiscount + " " + settingsDetailModel!.currency_symbol!
            let attrString = NSMutableAttributedString(string: priceStr, attributes: [NSAttributedString.Key.font: customFont.totalPriceLabelFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]);
            attrString.append(NSMutableAttributedString(string: " (After Discount)", attributes: [NSAttributedString.Key.font: customFont.totalPriceDiscountFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]));
            totalPriceLabel.attributedText = attrString
            
            
            

		} else {
			selectedItemPriceAfterDiscount = itemDetail.itemPrice
		}
		if itemDetail.images[0].path != nil {
			let coverImageName =  itemDetail.images[0].path! as String
			let imageURL = configs.imageUrl + coverImageName
			self.itemImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
				if(status == STATUS.success) {
				}else {
				}
			}
		}

		selectedItemName = itemDetail.itemName
		selectedItemDesc = itemDetail.itemDesc
		if(itemDetail.discountPercent != "") {
			selectedItemDiscountPercent = itemDetail.discountPercent
		} else {
			selectedItemDiscountPercent = "0.0"
		}
		selectedItemImagePath = itemDetail.images[0].path!
    }

    func set0ForEmtpyString(amount: String?) -> Float{
        let amt = amount ?? "0"
        return Float(amt == "" ? "0" : amt)!
    }

    @IBAction func onAttributeClick(_ sender: UIButton) {
        selectedAttibuteIndex = sender.tag
        attributeTableView.reloadData()
    }

    @IBAction func onFirstAttribute(_ sender: UIButton) {
		openAttributePopup(index: sender.tag)
    }

    @IBAction func onSecondAttribute(_ sender: UIButton) {
		openAttributePopup(index: sender.tag)
	}

    func openAttributePopup(index: Int){
        selectedAttibuteItemIndex = index
        attributesDetailModelFilterArray.removeAll()
        let attId: String = attributesModelArray[index].id
        attributesDetailModelFilterArray = attributesDetailModelArray.filter({$0.headerId == attId})
       //print("att cound: ",attributesDetailModelFilterArray.count)
        showAttributePopupView()
        attributeTableView.reloadData()
    }
	
    func ImageViewTapRegister() {

        let reviewTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.ReviewCountImageTapped(_:)))
        reviewTap.numberOfTapsRequired = 1
        reviewTap.numberOfTouchesRequired = 1
        self.reviewCountImage.addGestureRecognizer(reviewTap)
        self.reviewCountImage.isUserInteractionEnabled = true

        let likeTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.LikeCountImageTapped(_:)))
        likeTap.numberOfTapsRequired = 1
        likeTap.numberOfTouchesRequired = 1
        self.likeCountImage.addGestureRecognizer(likeTap)
        self.likeCountImage.isUserInteractionEnabled = true

        let favouriteTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.FavouriteImageTapped(_:)))
        favouriteTap.numberOfTapsRequired = 1
        favouriteTap.numberOfTouchesRequired = 1
        self.favouriteImage.addGestureRecognizer(favouriteTap)
        self.favouriteImage.isUserInteractionEnabled = true

		//MARK: Trello Bug: Cancel image tap
        /*let itemImageTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.ItemImageTapped(_:)))
        itemImageTap.numberOfTapsRequired = 1
        itemImageTap.numberOfTouchesRequired = 1
        self.itemImage.addGestureRecognizer(itemImageTap)
        self.itemImage.isUserInteractionEnabled = true*/
    }

    @objc func ItemImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizer.State.ended){
            let imgSliderViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSlider") as? ImageSliderViewController
            self.navigationController?.pushViewController(imgSliderViewController!, animated: true)
            imgSliderViewController?.itemImages = self.itemImages
            updateBackButton()
        }
    }


    @objc func ReviewCountImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizer.State.ended){
            let reviewsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsListTableViewController") as? ReviewsListTableViewController
            self.navigationController?.pushViewController(reviewsListViewController!, animated: true)
            reviewsListViewController?.reviews = self.reviews
            reviewsListViewController?.selectedItemId = selectedItemId
//            reviewsListViewController?.selectedShopId = selectedShopId
            reviewsListViewController?.itemDetailRefreshReviewCountsDelegate = self
            reviewsListViewController?.itemDetailLoginUserIdDelegate = self
            updateBackButton()
        }
    }

    @objc func LikeCountImageTapped(_ recognizer: UITapGestureRecognizer) {

        if(Reachability.isConnectedToNetwork()){
            if(loginUserId != 0) {
                if(recognizer.state == UIGestureRecognizer.State.ended){

                    _ = EZLoadingActivity.show("Loading...", disableUI: true)

                    let params: [String: AnyObject] = [
                        "appuser_id": loginUserId as AnyObject,
                        "shop_id"   : "1" as AnyObject,
                        "platformName": "ios" as AnyObject
                    ]

                    _ = Alamofire.request(APIRouters.AddItemLike(selectedItemId, params)).responseObject{
                        (response: DataResponse<StdResponse>) in

                        _ = EZLoadingActivity.hide()

                        if response.result.isSuccess {
                            if let res = response.result.value {

                                if(res.status == "like_success") {
                                    self.itemLikeCount.text = String(res.intData!)
                                    self.likeCountImage.image = UIImage(named: "Like-Lite-Red")
                                    self.animateUI(imgBtn: self.likeCountImage)
                                } else {
                                    self.itemLikeCount.text = String(res.intData!)
                                    self.likeCountImage.image = UIImage(named: "Like-Lite")
                                    self.animateUI(imgBtn: self.likeCountImage)
                                }

                                self.refreshLikeCountsDelegate?.updateLikeCounts(res.intData!)

                                self.favRefreshLikeCountsDelegate?.updateLikeCounts(res.intData)
                                self.searchRefreshLikeCountsDelegate?.updateLikeCounts(res.intData)


                            }
                        } else {
                           //print(response)
                        }
                    }
                }
            } else {
                _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.customImag(imageFile: "Logo"))
                weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
                UserLoginViewController?.title = "Login"
                UserLoginViewController?.itemDetailLoginUserIdDelegate = self
                UserLoginViewController?.fromWhere = "like"
                self.navigationController?.pushViewController(UserLoginViewController!, animated: true)

                updateBackButton()
            }
        } else {
            _ = SweetAlert().showAlert(language.offlineTitle, subTitle: language.offlineMessage, style: AlertStyle.customImag(imageFile: "Logo"))
        }

    }


    @objc func FavouriteImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(Reachability.isConnectedToNetwork()){
            if(loginUserId != 0) {


                if(recognizer.state == UIGestureRecognizer.State.ended){

                    _ = EZLoadingActivity.show("Loading...", disableUI: true)

                    let params: [String: AnyObject] = [
                        "appuser_id": loginUserId as AnyObject,
                        "shop_id"   : "1" as AnyObject,
                        "platformName": "ios" as AnyObject
                    ]


                    _ = Alamofire.request(APIRouters.AddItemFavourite(selectedItemId, params)).responseObject{
                        (response: DataResponse<StdResponse>) in

                        _ = EZLoadingActivity.hide()

                        if response.result.isSuccess {
                            if let res = response.result.value {
                                if(res.status! == "favourite_success") {
                                    self.favouriteImage.image = UIImage(named: "Favourite-Lite-Red")
                                    self.animateUI(imgBtn: self.favouriteImage)
                                } else {
                                    self.favouriteImage.image = UIImage(named: "Favourite-Lite-White")
                                    self.animateUI(imgBtn: self.favouriteImage)
                                }


                            }
                        } else {
                           //print(response)
                        }
                    }
                }
            } else {
                _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.customImag(imageFile: "Logo"))
                let UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
                UserLoginViewController?.title = "Login"
                UserLoginViewController?.itemDetailLoginUserIdDelegate = self
                UserLoginViewController?.fromWhere = "favourite"
                self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
                updateBackButton()

            }
        } else {
            _ = SweetAlert().showAlert(language.offlineTitle, subTitle: language.offlineMessage, style: AlertStyle.customImag(imageFile: "Logo"))
        }
    }

    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    func setupDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        doneToolbar.barTintColor = UIColor.gray

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(ItemDetailViewController.doneButtonAction))

        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()

        self.txtQty.inputAccessoryView = doneToolbar

    }

    @objc func doneButtonAction()
    {
        self.txtQty.resignFirstResponder()
    }

    func setupBasketButton() {

//        let btnSearch = UIButton()
//        btnSearch.setImage(UIImage(named: "Search-White"), for: UIControl.State())
//        btnSearch.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        btnSearch.addTarget(self, action: #selector(ItemDetailViewController.loadSearchPopUpView(_:)), for: .touchUpInside)
//        let itemSearch = UIBarButtonItem()
//        itemSearch.customView = btnSearch

        if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {
            basketButton = MIBadgeButton()
            basketButton.badgeString = String(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)
            basketButton.badgeTextColor = UIColor.black
            basketButton.badgeBackgroundColor = UIColor.white
            basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 35, bottom: 0, right: 10)
            basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            basketButton.setImage(UIImage(named: "bag-1"), for: UIControl.State())
            basketButton.addTarget(self, action: #selector(ItemDetailViewController.loadBasketViewController(_:)), for: UIControl.Event.touchUpInside)
            itemNavi.customView = basketButton
            //self.navigationItem.rightBarButtonItems = [itemNavi,itemSearch]
            self.navigationItem.rightBarButtonItems = [itemNavi]

        } else {
            //self.navigationItem.rightBarButtonItems = [itemSearch]
        }


    }

    func basketCountUpdate(_ itemCount: Int) {
        basketButton.badgeString = String(itemCount)
        basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 15, bottom: 0, right: 13)

    }
    @objc func loadSearchPopUpView(_ sender: UIBarButtonItem) {
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier:"SearchPopUpID") as! SearchPopUpViewController
        self.addChild(popOverVC)
        popOverVC.searchDelegate = self
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }

    internal func closePopup() {
    }

    @objc func loadBasketViewController(_ sender:UIButton) {

        if(isEditMode){
            self.navigationController?.popViewController(animated: true)
        }else {
            if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count > 0) {

                weak var BasketManagementViewController =  self.storyboard?.instantiateViewController(withIdentifier: "Basket") as? BasketViewController
                BasketManagementViewController?.title = "Basket"
                BasketManagementViewController?.selectedItemCurrencySymbol = selectedItemCurrencySymbol
                BasketManagementViewController?.selectedShopArrayIndex = selectedShopArrayIndex
                BasketManagementViewController?.selectedItemCurrencyShortForm = selectedItemCurrencyShortform
                BasketManagementViewController?.selectedShopId = 1
                BasketManagementViewController?.loginUserId = loginUserId
                BasketManagementViewController?.itemDetailBasketCountUpdateDelegate = self
                BasketManagementViewController?.fromWhere = "detail"
                self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
                //updateBackButton()

            } else {
                _ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.customImag(imageFile: "Logo"))
            }
        }

    }
    

//MARK: Add to cart
    @IBAction func doAddToCart(_ sender: Any) {
        var id : Int64 = 0
        let data = checkItemInBasket()
        id = data.0
        if id != 0 {
            isBasketItem = true
        }else{
            isBasketItem = false
        }

       print("selected Attributes : ",selectedAttributeStr)
        print("Selected attributed id string : ",selectedAttributeIdsStr)

        if(Int(txtQty.text!) != nil && String(txtQty.text!) != String(0)) {

            if self.attributesModelArray.count > 0{
                for i in 0..<attributesModelArray.count{
                    let isRequired = attributesModelArray[i].isRequired
                    if isRequired == "1" && selectedAttributeArray[i] == ""{
                        _ = SweetAlert().showAlert(language.addtoCart, subTitle: "Please select \(attributesModelArray[i].name)", style: AlertStyle.customImag(imageFile: "Logo"))
                        return
                    }
                }
            }

            if(loginUserId != 0) {
                
                //Before adding an item lets check if uesr is adding item from same outlet or not. Meaning if item is available in his selected outlet.
                if(appDelegate.selectedOutletByUser != nil){
                    //Chcecking if item exists at user selected store
                let itemsForOutlet = itemDetail.shops.filter({$0.shopId == appDelegate.selectedOutletByUser?.id })
                if(itemsForOutlet.count <= 0){
                    //We have to stop user here.item is not at his store
                    //If cart has more than zero items ask user to get rid of them first.
                    let allBasketSchemas = BasketTable.getByShopIdAndUserId(String(1), loginUserId: String(loginUserId))
                    if allBasketSchemas.count > 0 {
                     _ = SweetAlert().showAlert("", subTitle: String.init(format: "You are ordering an item which is not available at your store %@. Do you want to remove existing items from cart and add this new item?",appDelegate.selectedOutletByUser!.name!), style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "CONFIRM", buttonColor: .clear, otherButtonTitle: "CANCEL") { (isOk) in
                            if isOk {
                                //Let's remove item and then move on
                                if allBasketSchemas.count > 0 {
                                    for ab in allBasketSchemas{
                                        // BasketTable.deleteAll(ab)
                                        BasketTable.deleteByKeyIds("1", selectedId: Int64(ab.id!))
                                    }
                                }
                                //User pressed confirm so lets add item now
                                self.addToCartButton.sendActions(for: .touchUpInside)
                            } else {
                                //User tapped cancel
                                return
                            }
                        }
                        return
                        //Let's return until user does any action
                    }
                }
                }
                
                
                
                
                
                
                BasketTable.createTable()
                let basketSchema = BasketSchema()

                if(isBasketItem == true) {

                    //existing item so need to update
                    basketSchema.itemId = String(selectedItemId)
                    basketSchema.shopId = "1"
                    basketSchema.userId = String(loginUserId)
                    basketSchema.name   = selectedItemName
                    basketSchema.desc              = selectedItemDesc
                    basketSchema.unitPrice         = selectedItemPrice
                    basketSchema.discountPercent   = selectedItemDiscountPercent
                    //basketSchema.qty               = Int64(txtQty.text!)! + data.1
                    //Just add to cart what text field is showing
                    basketSchema.qty               = Int64(txtQty.text!)!
                    basketSchema.imagePath         = selectedItemImagePath
                    basketSchema.currencySymbol    = selectedItemCurrencySymbol
                    basketSchema.currencyShortForm = selectedItemCurrencyShortform
                    basketSchema.selectedAttribute = selectedAttributeStr
                    basketSchema.selectedAttributeIds = selectedAttributeIdsStr

                    let alert = UIAlertController(title: "", message: "\(selectedItemName) quantity updated in your cart", preferredStyle: UIAlertController.Style.alert)

                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                    BasketTable.updateAllByKeyId(basketSchema, selectedShopId: "1", selectedId: id)

                    //                    addToCartAnimation()

                } else {

                    let alert = UIAlertController(title: "", message: "Great job! You’ve added \(selectedItemName) to your cart", preferredStyle: UIAlertController.Style.alert)

                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: true, completion: nil)
                    }

                    basketSchema.itemId = String(selectedItemId)
                    basketSchema.shopId = "1"
                    basketSchema.userId = String(loginUserId)
                    basketSchema.name   = selectedItemName
                    basketSchema.desc              = selectedItemDesc
                    basketSchema.unitPrice         = selectedItemPrice
                    basketSchema.discountPercent   = selectedItemDiscountPercent
                    basketSchema.qty               = Int64(txtQty.text!)!
                    basketSchema.imagePath         = selectedItemImagePath
                    basketSchema.currencySymbol    = selectedItemCurrencySymbol
                    basketSchema.currencyShortForm = selectedItemCurrencyShortform
                    basketSchema.selectedAttribute = selectedAttributeStr
                    basketSchema.selectedAttributeIds = selectedAttributeIdsStr

                    basketSchema.id = BasketTable.insert(basketSchema)

                    if(isShownAlreadyBasketButton == true) {
                        basketCountUpdate(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)
                    } else {
                        setupBasketButton()
                    }
                    //basketButtonShake()
                    //                    addToCartAnimation()


                }

                self.refreshBasketCountsDelegate?.updateBasketCounts(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)

                self.basketTotalAmountUpdateDelegate?.updateTotalAmount(Float(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count), reloadAll: true)
                var totalAmount : Float = 0.0
                for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)) {
                    totalAmount += Float(basket.unitPrice!)! * Float(basket.qty!)
                }
                self.basketTotalAmountUpdateDelegate?.updatedFinalAmount(totalAmount)

            } else {
                _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.customImag(imageFile: "Logo"))
                weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
                UserLoginViewController?.title = "Login"
                UserLoginViewController?.itemDetailLoginUserIdDelegate = self
                UserLoginViewController?.fromWhere = "cart"
                self.navigationController?.pushViewController(UserLoginViewController!, animated: true)

                updateBackButton()
            }

        } else {

            _ = SweetAlert().showAlert(language.addtoCart, subTitle: language.fillQtyMessage, style: AlertStyle.customImag(imageFile: "Logo"))

        }

    }

    func addToCartAnimation() {
        let bounds = scrollView.bounds
        let smallFrame = scrollView.frame.insetBy(dx: scrollView.frame.size.width / 4, dy: scrollView.frame.size.height / 4)
        let finalFrame = smallFrame.offsetBy(dx: 0, dy: bounds.size.height)

        let snapshot = scrollView.snapshotView(afterScreenUpdates: false)
        snapshot?.frame = scrollView.frame
        view.addSubview(snapshot!)
        //scrollView.removeFromSuperview()

        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                snapshot?.frame = smallFrame
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                snapshot?.frame = finalFrame
            }
        }, completion: nil)
    }

    func updateNavigationStuff() {
        //self.navigationController?.navigationBar.topItem?.title = self.navTitle
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
    }


    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()

        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {
          loginUserId = Common.instance.getLoginUserId(dict: dict)
        } else {
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }

    func isLikedChecking() {
        let params: [String: AnyObject] = [
            "appuser_id": loginUserId as AnyObject,
            "shop_id"   : "1" as AnyObject,
            "platformName": "ios" as AnyObject
        ]

        _ = Alamofire.request(APIRouters.IsLikedItem(selectedItemId, params)).responseObject{
            (response: DataResponse<StdResponse>) in

            if response.result.isSuccess {
                if let res = response.result.value {

                    if(res.data == "yes") {
                        self.likeCountImage.image = UIImage(named: "Like-Lite-Red")
                    } else {
                        self.likeCountImage.image = UIImage(named: "Like-Lite")
                    }

                }
            } else {
                //print(response)
            }
        }
    }

    func isFavouritedChecking() {
        let params: [String: AnyObject] = [
            "appuser_id": loginUserId as AnyObject,
            "shop_id"   : "1" as AnyObject
        ]

        _ = Alamofire.request(APIRouters.IsFavouritedItem(selectedItemId, params)).responseObject{
            (response: DataResponse<StdResponse>) in

            if response.result.isSuccess {
                if let res = response.result.value {

                    if(res.data == "yes") {
                        self.favouriteImage.image = UIImage(named: "Favourite-Lite-Red")
                    } else {
                        self.favouriteImage.image = UIImage(named: "Favourite-Lite-White")
                    }

                }
            } else {
                //print(response)
            }
        }
    }

    func addItemTouchCount() {
        let params: [String: AnyObject] = [
            "appuser_id": loginUserId as AnyObject,
            "shop_id"   : "1" as AnyObject
        ]

        _ = Alamofire.request(APIRouters.AddItemTouch(selectedItemId, params)).responseObject{
            (response: DataResponse<StdResponse>) in

            if response.result.isSuccess {
                if let res = response.result.value {

                    if(res.status == "success") {
                        //print("Successfully insert for touch count")
                    } else {
                        //print("Touch count insert got problem")
                    }

                }
            } else {
               //print(response)
            }
        }
    }
    /*
    func animateMainView() {

        moveOffScreen()
//        self.mainView?.frame.origin = self.defaultValue
        self.scrollView.alpha = 1.0
        //        UIView.animate(withDuration: 1, delay: 0,
        //                       usingSpringWithDamping: 0.9,
        //                       initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseOut, animations: {
        //                        self.mainView?.frame.origin = self.defaultValue
        //        }, completion: { finished in
        //            UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
        //                self.scrollView.alpha = 1.0
        //            }, completion: nil)
        //        })
    }

    fileprivate func moveOffScreen() {
        mainView?.frame.origin = CGPoint(x: (mainView?.frame.origin.x)!,
                                         y: (mainView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }*/

    func animateUI(imgBtn : UIImageView) {

        AudioServicesPlaySystemSound(1057)

        imgBtn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.45),
                       initialSpringVelocity: CGFloat(5.10),
                       options: .allowUserInteraction,
                       animations: {
                        imgBtn.transform = .identity
        },
                       completion: { finished in

        }
        )


    }

}

extension ItemDetailViewController : ItemDetailRefreshReviewCountsDelegate {
    func updateReviewCounts(_ reviewCount: Int){
        self.itemReviewCount.text = "\(reviewCount)"
        refreshReviewCountsDelegate?.updateReviewCounts(reviewCount)
        favRefreshReviewCountsDelegate?.updateReviewCounts(reviewCount)
        searchRefreshReviewCountsDelegate?.updateReviewCounts(reviewCount)
    }
}

extension ItemDetailViewController: ItemDetailLoginUserIdDelegate {
    func updateLoginUserId(_ UserId: Int) {
        loginUserId = UserId
    }
}

extension ItemDetailViewController: ItemDetailBasketCountUpdateDelegate {
    func updateBasketCount() {
        basketCountUpdate(BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)).count)
        var totalAmount : Float = 0.0
        for basket in BasketTable.getByShopIdAndUserId("1", loginUserId: String(loginUserId)) {
            totalAmount += set0ForEmtpyString(amount: basket.unitPrice) * Float(basket.qty!)
        }
        self.basketTotalAmountUpdateDelegate?.updatedFinalAmount(totalAmount)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtQty {
            if !isQtyMore || Int(txtQty.text!) ?? 0 < 10 {
                configDropdown(dropdown: qtyDropdown, sender: textField)
                qtyDropdown.show()
                qtyDropdown.selectionAction = { (index, item) in
                    self.txtQty.text = item
                    if item == "10+" {
                        self.isQtyMore = true
                        self.qtyDropdown.hide()
                        self.qtyDropdown.removeFromSuperview()
                        self.txtQty.text = "10"
                    }
                    var totAmt = 0
                    if self.txtQty.text!.count > 0{
                        totAmt = Int(self.calculatedPrice * self.set0ForEmtpyString(amount: self.txtQty.text))
                    }
                    //self.totalPriceLabel.text = language.total + String(totAmt) + " " + self.selectedItemCurrencySymbol
                    let priceStr = language.total + String(totAmt) + " " + self.selectedItemCurrencySymbol
                    if(itemDetail.discountPercent != ""){
                        //self.totalPriceLabel.text = language.total + String(totAmt) + " " + self.selectedItemCurrencySymbol + " (After Discount)"
                        let attrString = NSMutableAttributedString(string: priceStr, attributes: [NSAttributedString.Key.font: customFont.totalPriceLabelFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]);
                        attrString.append(NSMutableAttributedString(string: " (After Discount)", attributes: [NSAttributedString.Key.font: customFont.totalPriceDiscountFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]));
                        self.totalPriceLabel.attributedText = attrString
                    }else{
                        let attrString = NSMutableAttributedString(string: priceStr, attributes: [NSAttributedString.Key.font: customFont.totalPriceLabelFont, NSAttributedString.Key.foregroundColor: UIColor.thirtyNorthGold]);
                        self.totalPriceLabel.attributedText = attrString

                    }
                    
                    
                    
                   
                    
                    
                    
                    
                    
                }
            }
            return isQtyMore ? true : false
        }
        return true

    }
}






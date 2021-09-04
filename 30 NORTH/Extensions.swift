//
//  Extensions.swift
//  CitiesDirectory
//
//  Created by Thet Paing Soe on 10/3/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher
import SwiftEntryKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    // For image loading from server with url
    func loadImage(urlString : String, completionHandler: @escaping (String, String, UIImage, String) -> Void) {
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            completionHandler(STATUS.success, urlString, imageFromCache, "success")
            return
        }
       //print("URL : " + urlString)
        Alamofire.request(urlString).responseData { response in
            guard let data = response.result.value else {
                let errmsg : String = "error in loading image."
                let img = UIImage()
                
                completionHandler(STATUS.fail, urlString, img, errmsg)
                
                return
            }
            self.image = UIImage(data:data,scale:1.0)
            
            
            if self.image != nil {
                
                imageCache.setObject(self.image!, forKey: urlString as AnyObject)
                completionHandler(STATUS.success, urlString, self.image!, "success")
            }else {
                completionHandler(STATUS.fail, urlString, UIImage(), "success")
            }
            
            
        }
        
    }
    
    public func imageWithURL(_ imageURL : String)
    {
        let url = URL(string: imageURL)
        
        var kf = self.kf
        
        let processor = DownsamplingImageProcessor(size: self.frame.size)
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: nil,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale + 20),
                .transition(.fade(1))
            ])
        self.contentMode = .scaleAspectFill
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension String {

	var floatValue: Float {
        return (self as NSString).floatValue
    }

    /** Get actual String after removing white spaces and new lines **/
    public func trim() -> String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

	func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

		return ceil(boundingBox.height)
	}

	func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

		return ceil(boundingBox.width)
	}

	func isValidPhone() -> Bool {

        var phoneString = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: self.range(of: self))
        phoneString = phoneString.folding(options: .diacriticInsensitive, locale: Locale.current)

        let types: NSTextCheckingResult.CheckingType = .phoneNumber

        let detector = try! NSDataDetector(types: types.rawValue)
        var matches = detector.matches(in: phoneString, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, phoneString.count))

        // no match at all
        if (matches.count == 0) {
            return false
        }
        if (phoneString.count < 8 || phoneString.count > 15) {
            return false
        }
        // found match but we need to check if it matched the whole string

        let result: NSTextCheckingResult = matches[0]

        if (result.resultType == NSTextCheckingResult.CheckingType.phoneNumber && result.range.location == 0 && result.range.length == phoneString.count) {
            // it matched the whole string
            return true;
        }
        else {
            // it only matched partial string
            return false
        }
    }
}
    
    
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
        var millisecondsSince1970:Int64 {
            return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        }

}


extension Double {
    func format(f: String) -> String {
        return String(format: "%.\(f)f", self)
        //calculatedPrice.format(f: configs.decimalPlaces)
    }
}

extension UIImageView {
    func rectangularImage() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red: 186/255, green: 140/255, blue: 43/255, alpha: 1).cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
//        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner] // Top right corner, Top left corner respectively

        self.clipsToBounds = true
    }
}
@IBDesignable
class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

extension EdgeInsetLabel {
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}

// overriding systemFont to customFont
struct AppFontName {
	static let nexaBlack = "NexaBlack"
    static let regular = "NexaLight"
    static let bold = "NexaBold"
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontName.bold
//        case "CTFontObliqueUsage":
//            fontName = AppFontName.italic
        default:
            fontName = AppFontName.bold
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension URL {
    func queryItemValueFor (key: String) -> String? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems
            else {
                return nil
        }
        
        return queryItems.first(where: { $0.name == key })?.value
    }
}

extension UIImage {
    func blurred(radius: CGFloat) -> UIImage {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        ciFilter.setValue(inputImage, forKey: kCIInputImageKey)
        ciFilter.setValue(radius, forKey: "inputRadius")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }

	func addShadowEffect(withColor color:UIColor=UIColor.gray, withEffect effect:CGFloat = 2.0) {
		layer.cornerRadius = 12.0
		layer.shadowColor = color.withAlphaComponent(0.9999).cgColor
		layer.shadowRadius = effect
		layer.shadowOpacity = 0.3
		//layer.shadowOffset = CGSize(width: effect, height: effect)
		layer.masksToBounds = false
	}
}

extension UIWindow {

	func showTickerToast(ticker : Ticker, font: UIFont, action:Selector, closeAction:Selector) {
		let screenRect = UIScreen.main.bounds
		var view = self.viewWithTag(1001)
		let top = self.safeAreaInsets.top + 44
		if view == nil {
			view = UIView(frame: CGRect(x: 0, y: top, width: screenRect.width, height: 50))
			view?.backgroundColor = UIColor.white
			view?.tag = 1001

			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let tapGesture = UITapGestureRecognizer(target: appDelegate, action: action)
			view!.addGestureRecognizer(tapGesture)

			self.addSubview(view!)
		}
		//view?.window?.windowLevel = .statusBar
		view?.layer.setValue(ticker.id ?? "", forKey: "TickerID")

		var textLabel:EFAutoScrollLabel? = view?.subviews.first(where: { (label) -> Bool in
			return label is EFAutoScrollLabel
		}) as? EFAutoScrollLabel

		if textLabel == nil {
			//CGRect(x: 0, y: 5, width: view!.frame.width , height: view!.frame.height)
			textLabel = EFAutoScrollLabel(frame: CGRect(x: 8, y: 0, width: view!.frame.width-16, height: view!.frame.height))//view!.bounds.insetBy(dx: 8, dy: 5))
			textLabel?.backgroundColor = .clear
			textLabel?.textColor = UIColor.black
			textLabel?.font = font
			textLabel?.textAlignment = .center;
			textLabel?.pauseInterval = 0              			 // Seconds of pause before scrolling starts again
			textLabel?.scrollSpeed = 30                        // Pixels per second
			textLabel?.textAlignment = NSTextAlignment.left    // Centers text when no auto-scrolling is applied
			textLabel?.fadeLength = 0                        // Length of the left and right edge fade, 0 to disable
			textLabel?.scrollDirection = EFAutoScrollDirection.left
			textLabel?.isUserInteractionEnabled = true
			view!.addSubview(textLabel!)
		}

		textLabel?.labelSpacing = 50                       // Distance between start and end labels
		textLabel?.text = ticker.title//"This is loral upsum text with new animations to heck out the actual size."

		var closeButton:UIButton? = view?.subviews.first(where: { (button) -> Bool in
			return button is UIButton
		}) as? UIButton
		if closeButton == nil {
			closeButton = UIButton(type: .custom)
			closeButton?.setImage(UIImage(named: "close-gray"), for: .normal)
			closeButton?.backgroundColor = .clear
			closeButton?.addTarget(nil, action:closeAction, for: .touchUpInside)
			view?.addSubview(closeButton!)
		}
		closeButton?.frame = CGRect(x: view!.frame.width-25, y: -5, width: 30, height: 30)
	}
}

extension UIViewController {

	func setTitle(text:String) {
		guard let titleLabel = self.navigationController?.navigationBar.topItem?.titleView as? UILabel else {
			let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
			titleLabel.text = text
			titleLabel.font = UIFont(name: AppFontName.bold, size: 20)
			titleLabel.textColor = UIColor.gold
			titleLabel.textAlignment = .center
			titleLabel.sizeToFit()
			self.navigationController?.navigationBar.topItem?.titleView = titleLabel
			return
		}
		titleLabel.text = text
		titleLabel.sizeToFit()
		self.navigationController?.navigationBar.topItem?.titleView = titleLabel
	}

//	NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "BasketCountChanged"), object: nil, queue: OperationQueue.main) { (notification) in
//		self.updateBasketCount()
//	}

	@objc func cartAction(_ sender: MIBadgeButton) {
		let userID = self.isUserLoggedIn()
		guard userID > 0 else {
			return
		}
		if(BasketTable.getByShopIdAndUserId("1", loginUserId: String(userID)).count > 0) {

			weak var BasketManagementViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Basket") as? BasketViewController
			BasketManagementViewController?.selectedShopId = 1
			BasketManagementViewController?.loginUserId = userID
			self.navigationController?.pushViewController(BasketManagementViewController!, animated: true)
		} else {
			_ = SweetAlert().showAlert(language.basketEmptyTitle, subTitle: language.basketEmptyMessage, style: AlertStyle.customImag(imageFile: "Logo"))
		}
	}

	func isUserLoggedIn() -> Int {
		var loginUserId = 0
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {
          loginUserId = Common.instance.getLoginUserId(dict: dict)
        }
		return loginUserId
    }

	func showCartButton(button:UIBarButtonItem?=nil) {
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "KRefreshHome"), object: nil, queue: OperationQueue.main) { (notication) in
			self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
		}
		let userID = self.isUserLoggedIn()
		if userID > 0 {
			let count = BasketTable.getByShopIdAndUserId(String(1), loginUserId: String(userID)).count
			if count > 0 {
				let basketButton = MIBadgeButton()
				basketButton.badgeString = String(count)
				basketButton.badgeTextColor = UIColor.black
				basketButton.badgeBackgroundColor = UIColor.white
				basketButton.badgeEdgeInsets = UIEdgeInsets.init(top: 6, left: 35, bottom: 0, right: 15)
				basketButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
				basketButton.setImage(UIImage(named: "bag-1"), for: UIControl.State())
				basketButton.addTarget(self, action: #selector(cartAction(_:)), for: .touchUpInside)

				let itemNaviBasket = UIBarButtonItem()
				itemNaviBasket.customView = basketButton

				if let searchButton = button {
					self.navigationController?.navigationBar.topItem?.rightBarButtonItems = [searchButton, itemNaviBasket]
				} else {
					self.navigationController?.navigationBar.topItem?.rightBarButtonItem = itemNaviBasket
				}
			} else {
				if let searchButton = button {
					self.navigationController?.navigationBar.topItem?.rightBarButtonItem = searchButton
				} else {
					self.navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
				}
			}
		} else if let searchButton = button {
			self.navigationController?.navigationBar.topItem?.rightBarButtonItem = searchButton
		}
	}

	func hideCustomPopUp() {
        SwiftEntryKit.dismiss()
	}

	func showPopup(vc:UIViewController, width ratioX:CGFloat, height ratioY:CGFloat, popupAttributes:EKAttributes?) {
		var attributes: EKAttributes {
            var attributes = EKAttributes.centerFloat
            attributes.displayDuration = .infinity
			attributes.screenBackground = .color(color: EKColor(UIColor(white: 0.5, alpha: 0.2)))
            attributes.entryBackground = .clear
            attributes.screenInteraction = .dismiss
            attributes.entryInteraction = .absorbTouches

			attributes.roundCorners = .all(radius: 8)
			attributes.border = .value(color: .white, width: 0)

            attributes.scroll = .enabled(swipeable: false, pullbackAnimation: EKAttributes.Scroll.PullbackAnimation.easeOut)
			attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 0.6))
            attributes.positionConstraints.size = .init(width: .ratio(value: ratioX), height: .ratio(value: ratioY))
            attributes.statusBar = .inferred

            attributes.entranceAnimation = .init(translate: .init(duration: 0.5, anchorPosition: .top,  spring: .init(damping: 1, initialVelocity: 0)))
            attributes.exitAnimation = .init(translate: .init(duration: 0.5, anchorPosition: .top, spring: .init(damping: 1, initialVelocity: 0)))
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0))))
            return attributes
        }

        // Display the view controller with the configuration
        SwiftEntryKit.display(entry: vc, using: popupAttributes ?? attributes)
	}

	func showPopup(title:String, description:String, imagePath:String?, titleColor:UIColor = UIColor(red: 186/255, green: 140/255, blue: 43/255, alpha: 1), descColor:UIColor = .white, titleFont:UIFont = UIFont(name: AppFontName.bold, size: 17)!, descFont:UIFont = UIFont(name: AppFontName.regular, size: 16)!) {

		let ratioX:CGFloat = 0.88
		let ratioY:CGFloat = 0.5

        var popupAttributes: EKAttributes {
            var attributes = EKAttributes.centerFloat
            attributes.displayDuration = .infinity
			attributes.screenBackground = .color(color: EKColor(UIColor(white: 0.5, alpha: 0.2)))
            attributes.entryBackground = .clear
            attributes.screenInteraction = .dismiss
            attributes.entryInteraction = .absorbTouches

			attributes.roundCorners = .all(radius: 8)
			attributes.border = .value(color: .white, width: 1.0)

            attributes.scroll = .enabled(swipeable: false, pullbackAnimation: EKAttributes.Scroll.PullbackAnimation.easeOut)
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 6))
            attributes.positionConstraints.size = .init(width: .ratio(value: ratioX), height: .ratio(value: ratioY))
            attributes.statusBar = .inferred

            attributes.entranceAnimation = .init(translate: .init(duration: 0.5, anchorPosition: .top,  spring: .init(damping: 1, initialVelocity: 0)))
            attributes.exitAnimation = .init(translate: .init(duration: 0.5, anchorPosition: .top, spring: .init(damping: 1, initialVelocity: 0)))
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0))))
            return attributes
        }

		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomPopupViewController") as! CustomPopupViewController
		vc.configureView(title: title, description: description, imagePath:imagePath, titleColor: titleColor, descColor: descColor, titleFont: titleFont, descFont: descFont)
        // Display the view controller with the configuration
		self.showPopup(vc: vc, width: ratioX, height: ratioY, popupAttributes: popupAttributes)
    }

	func showOrderLocationPopup(imageName:String) {
		let vc = UIViewController()

		let imageView = UIImageView(frame: vc.view.bounds.insetBy(dx: 8, dy: 8))
		imageView.layer.cornerRadius = 3.0
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
		vc.view.addSubview(imageView)

		let imageURL = configs.imageUrl + "PickupLocationImage/" + imageName
		 imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
			 if(status == STATUS.success) {
				print(url + " is loaded successfully.")
			 }else {
				print("Error in loading image" + msg)
			 }
		 }
		self.showPopup(vc: vc, width: 0.9, height: 0.5, popupAttributes: nil)
	}
}

//extension UIButton{
//    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        self.layer.mask = mask
//    }
//}


extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
}


extension UIApplication {
	class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UILabel {
	func titleStyle(text:String) {
		self.text = text.uppercased()
		self.textColor = UIColor.gold
		self.numberOfLines = 0
		self.textAlignment = .center
		self.font = UIFont(name: AppFontName.bold, size: 23)
	}
    
   
}
extension UIFont{
       func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
           let descriptor = fontDescriptor.withSymbolicTraits(traits)
           return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
       }

       func bold() -> UIFont {
           return withTraits(traits: .traitBold)
       }

       func italic() -> UIFont {
           return withTraits(traits: .traitItalic)
       }
   }

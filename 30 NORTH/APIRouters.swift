//
//  APIRouters.swift
//  Restaurateur
//
//  Created by Panacea-soft on 14/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Alamofire
import Foundation

enum APIRouters: URLRequestConvertible {
    static let baseURLString = configs.mainUrl
    static let basePaymentURLString = configs.mainPaymentURL

    static let imageURLString = configs.imageUrl
    static let newBaseURLString = configs.newBaseURL
    static let pointsURLString = configs.pointsUrl
    static let redeemPointsURLString = configs.redeemPointsURL

	static let getCoffeeFinderCases = configs.getCoffeeFinderCases
    static let getShops              = configs.getShops
    static let getOutlets              = configs.getOutlets
    static let getShopByID           = configs.getShopByID
    static let itemsBySubCategory    = configs.itemsBySubCategory
    static let allItemsBySubCategory = configs.allItemsBySubCategory
    static let itemById              = configs.itemById
    static let searchByGeo           = configs.searchByGeo
    static let userLogin             = configs.userLogin
    static let getFavouriteItems     = configs.getFavouriteItems
    static let addItemInquiry        = configs.addItemInquiry
    static let addItemReview         = configs.addItemReview
    static let addAppUser            = configs.addAppUser
    static let resetPassword         = configs.resetPassword
    static let updateAppUser         = configs.updateAppUser
	static let updateSubscription    = configs.updateSubscription

    static let profilePhotoUpload    = configs.profilePhotoUpload
    static let addItemLike           = configs.addItemLike
    static let isLikedItem           = configs.isLikedItem
    static let isFavouritedItem      = configs.isFavouritedItem
    static let addItemFavourite      = configs.addItemFavourite
    static let addItemTouch          = configs.addItemTouch
    static let getNewsFeedByShopId   = configs.getNewsFeedByShopId
    static let getRewardsFeedByShopId   = configs.getRewardsFeedByShopId
    static let searchByID            = configs.searchByID
    static let registerPushNoti      = configs.registerPushNoti
    static let addItemRating         = configs.addItemRating
    static let submitTransaction     = configs.transactionSubmit
    static let userTransactionHistory = configs.userTransactionHistory
    static let shopSearchByLocation  = configs.shopSearchByLocation
    static let couponSearch          = configs.couponSearch
    static let searchByKeyword       = configs.searchByKeyword
    static let reservationSubmit     = configs.reservationSubmit
    static let reservationHistory    = configs.reservationHistory
    static let getAbout = configs.getAbout
    static let getFeatured = configs.getFeatured
    static let getCoupon   =  configs.getCoupon
    static let getRewardFeedByShopId = configs.getRewardFeedByShopId
    static let getRequestType = configs.getRequestType
    static let addNotification = configs.addNotification
    static let getAnnouncements = configs.getAnnouncements
	static let getTickers = configs.getTickers
    static let getCuppings = configs.getCuppings
    static let getHeighlights = configs.getHeighlights
    static let getAuthenticationToken = configs.getAuthenticationToken
    static let getOrderId = configs.getOrderId
    static let getPaymentKeyPerOrder = configs.getPaymentKeyPerOrder
    static let updateTransactionStatus = configs.updateTransactionStatus
    static let saveAccept = configs.saveAccept

    static let getOrderIDFromOrderList = configs.getOrderIDFromOrderList
	static let getGrindTypes = configs.getGrindTypes

    static let PaymentAPIKey = "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2libUZ0WlNJNklqRTFPVEE0TmpJNE5UUXVOekF3TVRBeUlpd2ljSEp2Wm1sc1pWOXdheUk2T1RnMk0zMC44RVNZODNMX3pJQjdVLUg1VDBHWG52a1JHNDZTaUxKNU1uaE9WOUluYnA4eGlWZ2dic3VqMzRGMENrd0R2R3V4UURBLVFBNnlKLTZUTWJoc1dMNG91dw=="
    static let MerchantID = "9863"
    //static let PaymentIntegrationId = "17233"       //For Testing
    static let PaymentIntegrationId = "20118"     //For Production

	case GetCoffeeFinderCases
    case GetShops
    case GetOutlets
    case GetShopByID(Int)
    case ItemsBySubCategory(Int, Int, Int, Int, String, String)
    case AllItemsBySubCategory(Int, Int)
    case ItemById(Int, Int)
    case SearchByGeo(Float, Double, Double, Int, Int)
    case UserLogin([String : AnyObject])
    case GetFavouriteItems(Int, Int, Int)
    case AddItemInquiry(Int, [String : AnyObject])
    case AddItemReview(Int, [String: AnyObject])
    case AddAppUser([String: AnyObject])
    case ResetPassword([String: AnyObject])
    case UpdateAppUser(Int, [String: AnyObject])
    case UpdateSubscription([String: AnyObject])
	case SaveAccept([String: AnyObject])

    case AddItemLike(Int,[String: AnyObject])
    case IsLikedItem(Int,[String: AnyObject])
    case IsFavouritedItem(Int,[String: AnyObject])
    case AddItemFavourite(Int,[String: AnyObject])
    case AddItemTouch(Int,[String: AnyObject])
    case GetNewsFeedByShopId(Int)
    case GetRewardsFeedByShopId(Int)
    case SearchByID(Int,[String: AnyObject])
    case RegitsterPushNoti([String: AnyObject])
    case AddItemRating(Int, [String: AnyObject])
    case SubmitTransaction([String: AnyObject])
    case UserTransactionHistory(Int)
    case ShopSearchByLocation(Float, Double, Double)
    case CouponSearch(Int, [String : AnyObject])
    case SearchByKeyword([String: AnyObject])
    case ReservationSubmit(Int, [String : AnyObject])
    case ReservationHistory(Int)
    case GetAbout
    case GetPoints(Int)
    case GetFeatured
    case GetCoupon
    case GetRewardFeedByShopId(Int)
    case GetRequestType
    case AddNotification([String : AnyObject])
    case GetAnnouncements
    case GetTickers
    case GetCuppings
    case GetHeighlights
    case GetAuthenticationToken
	case GetGrindTypes

    public func asURLRequest() throws -> URLRequest {
        
        let (path, parameters, method) : (String, [String: AnyObject], HTTPMethod) = {
            
            switch self {
			case .GetCoffeeFinderCases:
                return (APIRouters.getCoffeeFinderCases, ["params":"no" as AnyObject], .get)

            case .GetShops:
                return (APIRouters.getShops, ["params":"no" as AnyObject], .get)
                
            case .GetOutlets:
                return (APIRouters.getOutlets, ["params":"no" as AnyObject], .get)
                
            case .ItemsBySubCategory(let cityId, let subCategoryId, let count, let from, let field, let type):
                let url: String = NSString(format: APIRouters.itemsBySubCategory as NSString, cityId, subCategoryId, count, from, field, type) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .AllItemsBySubCategory(let cityId, let subCategoryId) :
                let url: String = NSString(format: APIRouters.allItemsBySubCategory as NSString, cityId, subCategoryId) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .ItemById(let itemId, let cityId):
                let url: String = NSString(format: APIRouters.itemById as NSString, itemId, cityId) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .SearchByGeo(let mile, let lat, let long, let cityId, let subCatId):
                let url: String = NSString(format: APIRouters.searchByGeo as NSString, mile, lat, long, cityId, subCatId) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .UserLogin(let params):
                return (APIRouters.userLogin, params, .post)
                
            case .GetFavouriteItems(let userId, let count, let from):
                let url: String = NSString(format: APIRouters.getFavouriteItems as NSString, userId, count, from) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .AddItemInquiry(let itemId, let params):
                let url: String = NSString(format: APIRouters.addItemInquiry as NSString, itemId) as String
                return (url, params, .post)
                
            case .AddItemReview(let itemId, let params):
                let url: String = NSString(format: APIRouters.addItemReview as NSString, itemId) as String
                return (url, params, .post)
                
            case .AddAppUser(let params):
                return (APIRouters.addAppUser, params, .post)
                
            case .ResetPassword(let params):
                return (APIRouters.resetPassword, params, .post)
                
            case .UpdateAppUser(let userId, let params):
                let url: String = NSString(format: APIRouters.updateAppUser as NSString, userId) as String
                return (url, params, .put)

			case .UpdateSubscription(let params):
				let url: String = APIRouters.updateSubscription
				return (url, params, .post)

            case .GetShopByID(let shopID):
                let url: String = NSString(format: APIRouters.getShopByID as NSString, shopID) as String
                return (url,["params":"no" as AnyObject], .get)
                
            case .AddItemLike(let itemId, let params):
                let url: String = NSString(format: APIRouters.addItemLike as NSString, itemId) as String
                return (url, params, .post)
                
            case .IsLikedItem(let itemId, let params):
                let url: String = NSString(format: APIRouters.isLikedItem as NSString, itemId) as String
                return (url, params, .post)
                
            case .IsFavouritedItem(let itemId, let params) :
                let url: String = NSString(format: APIRouters.isFavouritedItem as NSString, itemId) as String
                return (url, params, .post)
                
            case .AddItemFavourite(let itemId, let params) :
                let url: String = NSString(format: APIRouters.addItemFavourite as NSString, itemId) as String
                return (url, params, .post)
                
            case .AddItemTouch(let itemId, let params) :
                let url: String = NSString(format: APIRouters.addItemTouch as NSString, itemId) as String
                return (url, params, .post)
                
            case .GetNewsFeedByShopId(let cityId):
                let url: String = NSString(format: APIRouters.getNewsFeedByShopId as NSString, cityId) as String
                return (url,["params":"no" as AnyObject], .get)
          
            case .GetRewardsFeedByShopId(let cityId):
                let url: String = NSString(format: APIRouters.getRewardsFeedByShopId as NSString, cityId) as String
                return (url,["params":"no" as AnyObject], .get)
                
            case .SearchByID(let cityId, let params) :
                let url: String = NSString(format: APIRouters.searchByID as NSString, cityId) as String
                return (url, params, .post)
                
            case .RegitsterPushNoti(let params):
                return (APIRouters.registerPushNoti, params, .post)
                
            case .AddItemRating(let itemId, let params):
                let url: String = NSString(format: APIRouters.addItemRating as NSString, itemId) as String
                return (url, params, .post)
                
            case .SubmitTransaction(let params):
                //print(params)
                return (APIRouters.submitTransaction, params, .post)
                
            case .UserTransactionHistory(let userId):
                let url: String = NSString(format: APIRouters.userTransactionHistory as NSString, userId) as String
                return (url,["params":"no" as AnyObject], .get)
                
            case .ShopSearchByLocation(let mile, let lat, let long) :
                let url: String = NSString(format: APIRouters.shopSearchByLocation as NSString, mile, lat, long) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .CouponSearch(let shopId,let params) :
                let url: String = NSString(format: APIRouters.couponSearch as NSString, shopId) as String
                return (url, params, .post)
                
            case .SearchByKeyword(let params) :
                return (APIRouters.searchByKeyword, params, .post)
                
            case .ReservationSubmit(let shopId, let params):
                let url: String = NSString(format: APIRouters.reservationSubmit as NSString, shopId) as String
                return (url, params, .post)
                
            case .ReservationHistory(let userId):
                let url: String = NSString(format: APIRouters.reservationHistory as NSString, userId) as String
                
                return (url,["params":"no" as AnyObject], .get)
                
            case .GetAbout :
                return (APIRouters.getAbout, ["params":"no" as AnyObject], .get)
            case .GetPoints(let userId) :
                let url: String = NSString(format:configs.pointsUrl as NSString, userId) as String
                return (url,["params":"no" as AnyObject], .get)
             
            case .GetFeatured:
                return (APIRouters.getFeatured,  ["params":"no" as AnyObject], .get)

            case .GetCoupon:
                return (APIRouters.getCoupon, ["params": "no" as AnyObject], .get)
                
            case .GetRewardFeedByShopId(let shopId):
                let url: String = NSString(format: APIRouters.getRewardsFeedByShopId as NSString, shopId) as String
                return (url,["params":"no" as AnyObject], .get)
          
            case .GetRequestType:
                return (APIRouters.getRequestType, ["params": "no" as AnyObject], .get)
            
            case .AddNotification(let params) :
                return (APIRouters.addNotification, params, .post)

			case .GetAnnouncements:
				return (APIRouters.getAnnouncements, ["params":"no" as AnyObject], .get)
			case .GetTickers:
				return (APIRouters.getTickers, ["params":"no" as AnyObject], .get)
			case .GetCuppings:
				return (APIRouters.getCuppings, ["params":"no" as AnyObject], .get)
                
            case .GetHeighlights:
                return (APIRouters.getHeighlights, ["params":"no" as AnyObject], .get)
                
			case .GetAuthenticationToken:
				return (APIRouters.getAuthenticationToken, ["api_key":"ZXlKMGVYQWlPaUpLVjFRaUxDSmhiR2NpT2lKSVV6VXhNaUo5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RnMk15d2libUZ0WlNJNkltbHVhWFJwWVd3aWZRLmFhMjBsMG9GWm83MU40S1BXeDMyX2tvNkgxMm5DYmg5c1Y2SUhQdlNrMVctUk5ZVUhsN04zWVlrT09NVnExeWFIOW1oMmFIalZaaTBGazRyT09XSWpB" as AnyObject], .get)

			case .GetGrindTypes:
                return (APIRouters.getGrindTypes, ["params":"no" as AnyObject], .get)

			case .SaveAccept(let params):
				let url: String = APIRouters.saveAccept
				return (url, params, .post)
            }
        }()
        
        var url : URL!
        
        switch self {
        case .GetFeatured:
            url = try APIRouters.newBaseURLString.asURL()
        case .GetAuthenticationToken:
            url = try APIRouters.basePaymentURLString.asURL()
        default:
            url = try APIRouters.baseURLString.asURL()
        }
        
        //For Offline Cache
        let cachePolicy: NSURLRequest.CachePolicy = Reachability.isConnectedToNetwork() ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad
        let timeout = 1
        let apiUrl =  url.appendingPathComponent(path)
        //print(apiUrl)
        var urlRequest = URLRequest(url:apiUrl, cachePolicy: cachePolicy, timeoutInterval: TimeInterval(timeout))
        urlRequest.addValue("private", forHTTPHeaderField: "Cache-Control")
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = TimeInterval(configs.timeoutInterval)
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}

func UploadImage(url: String, userID: Int, image : UIImageView, completionHandler: @escaping (String, String, String) -> Void) {
    
    //DispatchQueue.main.async {
    let myUrl = NSURL(string: APIRouters.baseURLString + url);
    
    let request = NSMutableURLRequest(url:myUrl! as URL);
    request.httpMethod = "POST";
    
    
    let param = [
        "platformName"  : "ios",
        "userId"    : "\(userID)"
    ]
    
    let boundary = generateBoundaryString()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let imageData = image.image!.jpegData(compressionQuality: 1)
    
    if(imageData==nil)  {
        DispatchQueue.main.async {
            completionHandler(STATUS.fail, "", language.imageIsNull)
        }
        return;
    }
    
    request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "pic", imageDataKey: imageData! as NSData, boundary: boundary) as Data
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            //print("error=\(String(describing: error))")
            DispatchQueue.main.async {
                completionHandler(STATUS.fail, "", language.networkError)
            }
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            //print("statusCode should be 200, but is \(httpStatus.statusCode)")
            //print("response = \(String(describing: response))")
            
            DispatchQueue.main.async {
                completionHandler(STATUS.fail, "", language.tryAgainToConnect)
            }
            
            return
            
        }
        
        // You can //print out response object
        //print("******* response = \(String(describing: response))")
        
        // //print out reponse body
        let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        //print("****** response data = \(responseString!)")
        
        do {
            
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
            // Normal String
            guard let status3 = json?["status"] as? String,
                let data3 = json?["data"] else {
                    
                    //let rRtn : [[String: AnyObject]] = []
                    DispatchQueue.main.async {
                        completionHandler(STATUS.fail, "", language.somethingWrong)
                    }
                    return
            }
            
            
            if status3 == "success" {
                DispatchQueue.main.async {
                    completionHandler(STATUS.success, data3 as! String, "Success")
                }
            }else {
                DispatchQueue.main.async {
                    completionHandler(STATUS.fail, data3 as! String , "Fail")
                }
            }
            
            
        }catch
        {
            DispatchQueue.main.async {
                completionHandler(STATUS.fail, "", language.somethingWrong)
            }
            return
            
        }
        
    }
    task.resume()
    //}
    
}

func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
    let body = NSMutableData();
    
    if parameters != nil {
        for (key, value) in parameters! {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
    }
    
    let filename = "user-profile.jpg"
    let mimetype = "image/jpg"
    
    body.appendString(string: "--\(boundary)\r\n")
    body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
    body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
    body.append(imageDataKey as Data)
    body.appendString(string: "\r\n")
    
    body.appendString(string: "--\(boundary)--\r\n")
    
    return body
}

func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

struct  STATUS {
    static let success : String = "success"
    static let fail : String = "fail"
}

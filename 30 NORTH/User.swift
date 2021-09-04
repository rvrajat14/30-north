//
//  User.swift
//  Restaurateur
//
//  Created by Panacea-soft on 16/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class User: NSObject, ResponseObjectSerializable {
    var id: String?
    var username: String?
    var password: String?
    var email: String?
    var aboutMe: String?
    var deliveryAddress: String?
    var billingAddress: String?
    var phone: String?
	var birth_date:String?
	var is_phone_verified: String?
    var profilePhoto: String?
    var isBanned: String?
    var status: String?
    var added: String?
    var updated: String?
	var district_id: String?

    init(userData: NSDictionary) {
        super.init()
        self.setData(userData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        super.init()
		let userDefaults = UserDefaults.standard

		//Districts
		if let districts = (representation as AnyObject).value(forKeyPath: "districts") as? [NSDictionary] {
			do {
				let districtsData = try NSKeyedArchiver.archivedData(withRootObject: districts, requiringSecureCoding: false)
				userDefaults.set(districtsData, forKey: "Districts")
			} catch {
				print("Archiving error")
			}
		} else {
			userDefaults.removeObject(forKey: "Districts")
		}

		//Loyalty
		if let loyaltyTier = (representation as AnyObject).value(forKeyPath: "loyalty_tier") as? String {
			do {
				let loyaltyTierData = try NSKeyedArchiver.archivedData(withRootObject: loyaltyTier, requiringSecureCoding: false)
				userDefaults.set(loyaltyTierData, forKey: "LoyaltyTier")
			} catch {
				print("Archiving error")
			}
		} else {
			userDefaults.removeObject(forKey: "LoyaltyTier")
		}

		//Subscriptions count
		if let subscriptions = (representation as AnyObject).value(forKeyPath: "subscriptions") as? NSNumber {
			userDefaults.setValue(subscriptions, forKey: "Subscriptions")
		} else {
			userDefaults.removeObject(forKey: "Subscriptions")
		}

		//Orders count
		if let orders = (representation as AnyObject).value(forKeyPath: "orders") as? NSNumber {
			userDefaults.setValue(orders, forKey: "Orders")
		} else {
			userDefaults.removeObject(forKey: "Orders")
		}

        if let userData = (representation as AnyObject).value(forKeyPath: "data") as? NSDictionary {
            self.setData(userData)
        } else {
            return nil
        }
    }
    
    func setData(_ userData: NSDictionary) {
        self.id       = userData["id"] as? String
        self.username = userData["username"] as? String
        self.password = userData["password"] as? String
        self.email    = userData["email"] as? String
        self.aboutMe  = userData["about_me"] as? String
        self.profilePhoto = userData["profile_photo"] as? String
        self.isBanned = userData["is_banned"] as? String
        self.status   = userData["status"] as? String
        self.added    = userData["added"] as? String
        self.updated  = userData["updated"] as? String
        self.deliveryAddress = userData["delivery_address"] as? String
        self.billingAddress  = userData["billing_address"] as? String
        self.phone = userData["phone"] as? String
		self.birth_date = userData["birth_date"] as? String
		self.is_phone_verified = userData["is_phone_verified"] as? String
		self.district_id = userData["district_id"] as? String
    }
}

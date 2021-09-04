//
//  SettingsViewController.swift
//  30 NORTH
//
//  Created by Apple on 4/6/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

enum SettingsScreen: Int{
    case my_orders, my_subscriptions, edit_profile, announcementsList, get_in_touch, outlets, our_story, login, logout
}

class SettingsViewController: UIViewController {

	@IBOutlet weak var settingsTableView: UITableView! {
		didSet{
			settingsTableView.backgroundColor = UIColor.clear
			settingsTableView.delegate = self
			settingsTableView.dataSource = self
		}
	}
    
    var contentArray = ["MY ORDERS", "MY SUBSCRIPTIONS", "MY PROFILE","ANNOUNCEMENTS", "GET IN TOUCH", "OUTLETS", "OUR STORY", "SIGN IN", "SIGN OUT"]
    var imageArray = ["my-orders", "my-orders", "account", "contact", "outlets", "about", "login", "Logout-Lite"]
    var profileImage: UIImage? = nil
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
        let loadedImage = Common.instance.loadImageFromPath(imagePath)
        profileImage = loadedImage

        settingsTableView.reloadData()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateNavigationStuff()
		self.showCartButton()
   }

   func updateNavigationStuff() {
	   self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	   //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor: UIColor.white]
   }

    func hideOrShowList(index: Int) -> CGFloat{
     
        if(Common.instance.isUserLogin()) {

			let userDefaults = UserDefaults.standard
			if index == SettingsScreen.my_subscriptions.rawValue, let subscriptions = userDefaults.value(forKey: "Subscriptions") as? NSNumber, subscriptions.intValue == 0 {
				return 0
			}
			if index == SettingsScreen.my_orders.rawValue, let orders = userDefaults.value(forKey: "Orders") as? NSNumber, orders.intValue == 0 {
				return 0
			}
            if index == SettingsScreen.login.rawValue {
                return 0
            }
        }else{
			if index == SettingsScreen.my_orders.rawValue || index == SettingsScreen.my_subscriptions.rawValue || index == SettingsScreen.logout.rawValue || index == SettingsScreen.edit_profile.rawValue{
                return 0
            }
        }
        return 70
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return hideOrShowList(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell

        cell.titleLabel.text = contentArray[indexPath.row]
	
		cell.selectionStyle = .none
		cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {

        case SettingsScreen.my_orders.rawValue:
            let shopProfileViewController = self.storyboard?.instantiateViewController(identifier: "TransactionHistory") as! TransactionHistoryTableViewController
            self.navigationController?.pushViewController(shopProfileViewController, animated: true)
            break

		case SettingsScreen.my_subscriptions.rawValue:
		   let mySubscriptionsVC = self.storyboard?.instantiateViewController(identifier: "MySubscriptionsViewController") as! MySubscriptionsViewController
		   self.navigationController?.pushViewController(mySubscriptionsVC, animated: true)
		   break
        case SettingsScreen.edit_profile.rawValue:
            let shopProfileViewController = self.storyboard?.instantiateViewController(identifier: "ComponentUserProfileEdit") as! UserProfileEditViewController
            self.navigationController?.pushViewController(shopProfileViewController, animated: true)
            break
        case SettingsScreen.announcementsList.rawValue:
                       let announcementsListViewController = self.storyboard?.instantiateViewController(identifier: "AnnouncementsListViewController") as! AnnouncementsListViewController
                       self.navigationController?.pushViewController(announcementsListViewController, animated: true)
                       break
        case SettingsScreen.get_in_touch.rawValue:
            
            let inquiryEntryViewController = self.storyboard?.instantiateViewController(identifier: "InquiryViewController") as! InquiryEntryViewController
            self.navigationController?.pushViewController(inquiryEntryViewController, animated: true)

            break
        case SettingsScreen.outlets.rawValue:
            let outletsViewController = self.storyboard?.instantiateViewController(identifier: "OutletsViewController") as! OutletsViewController
            self.navigationController?.pushViewController(outletsViewController, animated: true)
            break
        case SettingsScreen.our_story.rawValue:
            let aboutViewController = self.storyboard?.instantiateViewController(identifier: "AboutViewController") as! AboutViewController
            self.navigationController?.pushViewController(aboutViewController, animated: true)
            break
            case SettingsScreen.login.rawValue:
                let aboutViewController = self.storyboard?.instantiateViewController(identifier: "ComponentLogin") as! LoginViewController
                self.navigationController?.pushViewController(aboutViewController, animated: true)

//                performSegue(withIdentifier: "toLogin", sender: self)
                break
            case SettingsScreen.logout.rawValue:
                appDelegate.selectedOutletByUser = nil
                updatePlist()
                
                // Delete the profile image from local
                let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
                Common.instance.deleteImageFromPath(imagePath)
                UserDefaults.standard.removeObject(forKey: "rewardPoints")
                UserDefaults.standard.removeObject(forKey: "userID")
                UserDefaults.standard.removeObject(forKey: "Subscriptions")
                UserDefaults.standard.removeObject(forKey: "Orders")

                tableView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "KRefreshHome"), object: nil, userInfo: nil)
                self.tabBarController?.selectedIndex = 0
            break

        default:
            break
        }
    }
    func updatePlist() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let dict: NSMutableDictionary = [:]
        
        dict.setObject("", forKey: "_login_user_id" as NSString)
        dict.setObject("", forKey: "_login_user_username" as NSString)
        dict.setObject("", forKey: "_login_user_email" as NSString)
        dict.setObject("", forKey: "_login_user_about_me" as NSString)
        dict.setObject("", forKey: "_login_user_profile_photo" as NSString)
        dict.setObject("", forKey: "_is_phone_verified" as NSString)
        dict.setObject("", forKey: "_login_user_delivery_address" as NSString)
        dict.setObject("", forKey: "_login_user_district_id" as NSString)

        dict.write(toFile: plistPath, atomically: false)
    }
}

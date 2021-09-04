//
//  MenuListController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 2/9/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit

class MenuListController: UITableViewController {
    
    var userLoggedIn : Bool = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var homeCell: UITableViewCell!
    @IBOutlet weak var profileCell: UITableViewCell!
    @IBOutlet weak var myFavCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var transactionHistoryCell: UITableViewCell!
    @IBOutlet weak var reservationHistoryCell: UITableViewCell!
    @IBOutlet weak var menuCell: UITableViewCell!
    @IBOutlet weak var brewingCell: UITableViewCell!
    @IBOutlet weak var reservationCell: UITableViewCell!
    @IBOutlet weak var northMusicCell: UITableViewCell!
    
    @IBOutlet weak var coffeeGuideCell: UITableViewCell!
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var favourite: UILabel!
    @IBOutlet weak var logout: UILabel!
    @IBOutlet weak var transactionHistory: UILabel!
    @IBOutlet weak var reservationHistory: UILabel!
    @IBOutlet weak var reservation: UILabel!
    @IBOutlet weak var brewingLabel: UILabel!
    @IBOutlet weak var coffeguide: UILabel!
    @IBOutlet weak var northMusic: UILabel!
    
    enum Menu : Int {
        case home, order, profile, our_story, reservation, favorite_items, order_history, reservation_history, brewing_methods, coffee_guide, north_music, outlets, get_in_touch, logout
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        if(Common.instance.isUserLogin()) {
            self.userLoggedIn = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        home.text = language.homeMenu
        brewingLabel.text = language.brewingMenu
        coffeguide.text = language.coffeeGuide
        profile.text = language.ProfileMenu
        favourite.text = language.favouriteMenu
        logout.text = userLoggedIn ? language.logoutMenu : language.LoginTitle
        transactionHistory.text = language.transactionHistory
        reservation.text = language.reservationPageTitle
        reservationHistory.text = language.reservationHistory
        northMusic.text = language.northMusic
    }
    
    func hideOrShowMenuItem(index: Int) -> CGFloat{
        
        if index == Menu.reservation.rawValue && is_Reservation{
            return 0
        }else if index == Menu.profile.rawValue && is_Profile{
            return 0
        }else if index == Menu.our_story.rawValue && is_Our_story{
            return 0
        }else if index == Menu.reservation.rawValue && is_Reservation{
            return 0
        }else if index == Menu.favorite_items.rawValue && is_Favorite_items{
            return 0
        }else if index == Menu.order_history.rawValue && is_Order_history{
            return 0
        }else if index == Menu.reservation_history.rawValue && is_Reservation_history{
            return 0
        }else if index == Menu.brewing_methods.rawValue && is_Brewing_methods{
            return 0
        }else if index == Menu.coffee_guide.rawValue && is_Coffee_guide{
            return 0
        }else if index == Menu.north_music.rawValue && is_North_music{
            return 0
        }else if index == Menu.order_history.rawValue && is_Order_history{
            return 0
        }else if index == Menu.reservation_history.rawValue && is_Reservation_history{
            return 0
        }else if index == Menu.outlets.rawValue && is_Outlets{
            return 0
        }else if index == Menu.get_in_touch.rawValue && is_Get_in_touch{
            return 0
        }else if index == Menu.logout.rawValue && is_Logout{
            return 0
        }
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       //print(indexPath.row)
        
        return hideOrShowMenuItem(index: indexPath.row)
        
//        if  indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 5 || indexPath.row == 6 {
//            return 0
//        }
//        if !userLoggedIn && (indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7) {
//            return 0
//        }
//        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        levelIndex = 0
       //print(indexPath.row)
      if((indexPath as NSIndexPath).row == 13){
            self.revealViewController().revealToggle(nil)
            let rowToSelect:IndexPath = IndexPath(row: 0, section: 0);
            self.tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: UITableView.ScrollPosition.none);
            if userLoggedIn {
            self.userLoggedIn = false
            performSegue(withIdentifier: "HomeNavigation", sender: self)
            updatePlist()
            // Delete the profile image from local
            let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
            Common.instance.deleteImageFromPath(imagePath)
                UserDefaults.standard.removeObject(forKey: "rewardPoints")
            } else {
                performSegue(withIdentifier: "toLogin", sender: self)

//                if let UserLoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController {
//                    UserLoginViewController.fromWhere = "menu"
//                    let navController = UINavigationController(rootViewController: UserLoginViewController)
//                    let backItem = UIBarButtonItem()
//                    backItem.title = ""
//                    navController.setViewControllers([UserLoginViewController], animated:true)
//                    navController.navigationItem.backBarButtonItem = backItem
//                    self.revealViewController().setFront(navController, animated: true)
//                }
            }
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
		dict.setObject("", forKey: "_login_user_district_id" as NSString)

        dict.write(toFile: plistPath, atomically: false)
        
    }
}

//
//  Constants.swift
//  30 NORTH
//
//  Created by SOWJI on 04/02/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import Foundation
import UIKit

var realDelegate: AppDelegate?;
//Disabling spotify due to Apple uiwebview use
//var spotifyPlayer : SPTAudioStreamingController?

var settingsDetailModel : SettingsDetail? = nil
var cats = [Categories]()
var levelIndex = 0
var shopModel : ShopModel? = nil
var categoryArray = [Categories]()
var itemDetail : ItemModel!
var CoffeeCases: [String] = []
/*    Menu Screen Hide or Show    */

var is_Profile = false
var is_Our_story = false
var is_Reservation = true
var is_Favorite_items = true
var is_Order_history = true
var is_Reservation_history = true
var is_Brewing_methods = false
var is_Coffee_guide = false
var is_North_music = false
var is_Outlets = false
var is_Get_in_touch = false
var is_Logout = false

/*    Order Sliding Bar     */
var is_menu = false
var is_featured = false
var is_previous = false
var is_favorites = false
var is_offers = false

//Defining global variables to set yield values
var YIELD : Int = 0
var YIELD2 : Int = 0
var YIELD12P5 : Int = 0
var YIELDRM1 : Int = 0
var YIELDRM2 : Int = 0

var appDelegate: AppDelegate {
    if Thread.isMainThread{
        return UIApplication.shared.delegate as! AppDelegate;
    }
    let dg = DispatchGroup();
    dg.enter()
    DispatchQueue.main.async{
        realDelegate = UIApplication.shared.delegate as? AppDelegate;
        dg.leave();
    }
    dg.wait();
    return realDelegate!;
}

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
var globalRevealViewController : SWRevealViewController?

 func setNavbarImage() -> UIView {
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 50))
	logoContainer.backgroundColor = UIColor.clear
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 50))
	imageView.backgroundColor = .clear
    imageView.contentMode = .scaleAspectFit
    let image = UIImage(named: "App-Launch-Icon-RT.png")
    imageView.image = image
    logoContainer.addSubview(imageView)
    return logoContainer
}


func navigateToPlayList() {
    
    if let playlistViewController = mainStoryboard.instantiateViewController(withIdentifier: "PlaylistViewController") as? PlaylistViewController, let revealController_ = globalRevealViewController  {
        let navigationController = UINavigationController(rootViewController: playlistViewController)
        revealController_.pushFrontViewController(navigationController, animated: true)
    }
}

func changePlaceholderColor(textfield: UITextField, placeholderText: String){
    textfield.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

}
func EmptyMessage(message:String, tableview: UITableView) {
    let rect = CGRect(x: 0,y :0, width: tableview.bounds.size.width, height: tableview.bounds.size.height)
    let messageLabel = UILabel(frame: rect)
    messageLabel.text = message
    messageLabel.textColor = UIColor.lightGray
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    messageLabel.font = UIFont(name: "OpenSans", size: 18)
    messageLabel.sizeToFit()

    tableview.backgroundView = messageLabel;
    tableview.separatorStyle = .none;
}

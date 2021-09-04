//
//  AppDelegate.swift
//  Restaurateur
//
//  Created by Panacea-soft on 11/19/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
import SwiftEntryKit
import Firebase
import GoogleMaps
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
	var tickers:[Ticker]?
    var window: UIWindow?
    var selectedOutletByUser : Outlet? = nil  // This is the outlet chosen by user on order tab for making orders
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(alertTintColor: UIColor.gold)
        siren.rulesManager = RulesManager(majorUpdateRules: .critical,
        minorUpdateRules: .critical,
        patchUpdateRules: .critical,
        revisionUpdateRules: .critical)
        siren.wail()

		UINavigationBar.appearance().barTintColor = UIColor.clear
		UINavigationBar.appearance().isOpaque = false
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gold, NSAttributedString.Key.font: UIFont(name: AppFontName.bold, size: 20)!]
        registerForPushNotifications(application: application)
        
        //registerSpotifyServices()

        GMSServices.provideAPIKey(configs.GMAPIKey)
        tabBarSelectedColor()
        doSettingsAPI()
		FirebaseApp.configure()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.loadAnnouncementsData()
			self.loadTickerData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
         if let tabBarController : UITabBarController = self.getTabbarController() {
                  let vc = tabBarController.viewControllers![1]
                  print ("\(String(describing: vc.description))")
                  if vc.isKind(of: SelectedShopViewController.classForCoder()) {
                      let new : SelectedShopViewController = vc as! SelectedShopViewController
                      let _ = new.view // This will call view did load for selectedshopviewcontroller.
                  }
              }
        }
        return true
    }

    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    func tabBarSelectedColor(){
        UINavigationBar.appearance().tintColor = UIColor.white
        
		UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gold], for:.selected)
        UITabBar.appearance().backgroundColor = .black
        UITabBar.appearance().tintColor = UIColor.gold
        UITabBar.appearance().barTintColor = .black
    }
    
    func doSettingsAPI()  {
       //print("need to laod from API")
        
//                  _ = EZLoadingActivity.show("Loading...", disableUI: true)
        let url =  APIRouters.baseURLString + "/settings/get"
        //"http://lvngs.com/index.php/rest/settings/get"
        Alamofire.request(url).responseJSON { (response) in
//                          _ = EZLoadingActivity.hide()
            DispatchQueue.main.async {
                
                switch response.result {
                case .success:
                    let jsonData = response.data
                    do{
                        let settings: Settings = try JSONDecoder().decode(Settings.self, from: jsonData!)
						print("settings : ",settings)
                        
                        if settings.status == "success"{
                            settingsDetailModel = settings.data
                        }
                        
                    }catch {
                       //print("Error: \(error)")
                        self.doSettingsAPI()
//                                                self.showAlert()
                    }
                    
                case .failure(let error):
                   //print(error)
                    self.doSettingsAPI()
//                                      self.showAlert()
                }
            }
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "", message: "Please check your internet connection and try again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertAction.Style.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }
            
        else{ //If user is not on iOS 10 use the old methods we've been using
            let notificationTypes : UIUserNotificationType = [.alert, .badge, .sound]
            let notificationSettings : UIUserNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            })
            
        }
    }
    /*
    func registerSpotifyServices() {
        
        let auth = SPTAuth.defaultInstance()
        auth.clientID = SpotifyService.shared.CLIENT_ID
        auth.requestedScopes = [SPTAuthStreamingScope]
        auth.redirectURL = URL(string: SpotifyService.shared.REDIRECT_URI)
        auth.sessionUserDefaultsKey = SpotifyService.shared.SESSIONUSERDEFAULTSKEY
    }
     */
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
		application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var deviceID : String = UIDevice.current.identifierForVendor!.uuidString
        let devicePlatform : String = "IOS"
        var deviceTokenKey : String = ""
        
        /*
         for i in 0..<deviceToken.count {
         deviceTokenKey = deviceTokenKey + String(format: "%02.2hhx", arguments: [deviceToken[i]])
         }*/
        
        
        //deviceTokenKey = String(format: "%@", deviceToken as CVarArg)
        deviceTokenKey = deviceToken.map { String(format: "%02x", $0)
        }.joined()

        // Save values in USUserDefaults
        let prefs = UserDefaults.standard
        
        prefs.set(deviceID, forKey:  notiKey.deviceIDKey)
        prefs.set(deviceToken, forKey: notiKey.deviceTokenKey)
        prefs.set(devicePlatform, forKey: notiKey.devicePlatform)
        
        // Remove All Space, >, <
        deviceTokenKey = deviceTokenKey.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        deviceTokenKey = deviceTokenKey.replacingOccurrences(of: ">", with: "", options: NSString.CompareOptions.literal, range: nil)
        deviceTokenKey = deviceTokenKey.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        deviceID = deviceID.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        
       //print("Device ID Key : " + deviceID)
       //print("Device Token Key : " + deviceTokenKey)
       //print("Device Platforma : " + devicePlatform)
        
        let isRegister = prefs.string(forKey: notiKey.isRegister)
        
        if(isRegister != "YES"){
            if(deviceID != "" && deviceTokenKey != "" && devicePlatform != "") {
                
                let params: [String: AnyObject] = [
                    "reg_id"    :  deviceTokenKey as AnyObject,
                    "device_id" :  deviceID as AnyObject,
                    "os_type"   :  devicePlatform as AnyObject,
                    "platformName": "ios" as AnyObject
                ]
                
                /*TOFIX*/
                _ =  Alamofire.request(APIRouters.RegitsterPushNoti(params)).responseObject {
                    (response: DataResponse<StdResponse>) in
                   //print(response)
                    if response.result.isSuccess {
                        if let res = response.result.value {
                           //print("Success \(res.intData)")
                            prefs.set("YES", forKey: notiKey.isRegister)
                        }
                    } else {
                       //print("Fail \(response)")
                    }
                }
            }
        }else{
            // Already registered.
           //print("Already Registered")
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       //print(error.localizedDescription)
    }
    
    /*
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
       //print("URL", url)
        
        let auth = SPTAuth.defaultInstance()
        
        if auth.canHandle(url) {
            
            auth.handleAuthCallback(withTriggeredAuthURL: url) { (error, session) in
                if error != nil {
                   //print("*** Auth error: %@", error)
                }else {
                    auth.session = session
                    SpotifyService.shared.saveRefreshTokenResponse(refreshTokenResponse: session)
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("sessionUpdated"), object: self)
            }

            return true
        }

        return false
    }
 */
    
    
     //old code
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            var _ : NSDictionary = userInfo as NSDictionary
            if let info = userInfo["aps"] as? Dictionary<String, AnyObject>
                {
                if let alertMsg = info["alert"] as? String {
                let prefs = UserDefaults.standard
                let terminate = prefs.string(forKey: "TERMINATE");
                if terminate != nil {
                // Set to tmp storage
                //let prefs = NSUserDefaults.standardUserDefaults()
                prefs.set(alertMsg, forKey: notiKey.notiMessageKey)
                }else {
                let alert = UIAlertController(title: "", message: info["alert"] as! String?, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertAction.Style.default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                }
            }
     
     }
    
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
       //print("User Info = ",notification.request.content.userInfo)
        if let info =  notification.request.content.userInfo["aps"] as? Dictionary<String, AnyObject>
        {
            
            if let alertMsg = info["alert"] as? String {
            let prefs = UserDefaults.standard
            let terminate = prefs.string(forKey: "TERMINATE");
            if terminate != nil {
               //print( "terminate is not null.")
                // Set to tmp storage
                prefs.set(alertMsg, forKey: notiKey.notiMessageKey)
                completionHandler([.alert, .badge, .sound])
            }else {
                let alert = UIAlertController(title: "", message: info["alert"] as! String?, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertAction.Style.default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            }
        }
    }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let info =  response.notification.request.content.userInfo["aps"] as? Dictionary<String, AnyObject> {
            if let alertMsg = info["alert"] as? String {
            let prefs = UserDefaults.standard
            let terminate = prefs.string(forKey: "TERMINATE");
            if terminate != nil {
                // Set to tmp storage
                prefs.set(alertMsg, forKey: notiKey.notiMessageKey)
                completionHandler()
            } else {

				if let text = info["alert"] as? String {
					_ = SweetAlert().showAlert("", subTitle: text , style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Cancel", buttonColor: UIColor.colorFromRGB(0xAEDEF4), otherButtonTitle: language.btnOK, action: { (isOk) in
						if !isOk {
							print("OK pressed")
						}
					})
				} else {
					print("Notification payload is invalid!")
				}

                /*let alert = UIAlertController(title: "", message: info["alert"] as! String?, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertAction.Style.default, handler: nil))
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)*/
            }
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //print("did enter background")
        self.window?.rootViewController?.hideCustomPopUp()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
		self.loadAnnouncementsData()
        //print("enter to fore ground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //print("did become active")
        UserDefaults.standard.removeObject(forKey: "TERMINATE")
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.set("Y", forKey:  "TERMINATE");
        UserDefaults.standard.removeObject(forKey: "registrationAlert")
        print ("terminate")
    }
}

extension AppDelegate {
	func showTickerAlert(ticker:Ticker) {
		if let title = ticker.title {
			_ = SweetAlert().showAlert("", subTitle:title, style:AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "OK", action: {[unowned self] (isOk) in
				if let tabBarController = self.getTabbarController() {
					tabBarController.selectedViewController?.navigationController?.popToRootViewController(animated: true)

					switch ticker.action_screen {
					case "home":
						tabBarController.selectedIndex = 0
					case "order":
						tabBarController.selectedIndex = 1
					case "subscribe":
						tabBarController.selectedIndex = 2
					case "coffeeology":
						tabBarController.selectedIndex = 3
					case "more":
						tabBarController.selectedIndex = 4
					default:
						break
					}
				}
			})
		}
	}

	@objc func showTickerAlert(_ gesture:UITapGestureRecognizer) {

		if let tickerID = gesture.view?.layer.value(forKey: "TickerID") as? String {
			let aTicker = self.tickers?.first(where: { (ticker) -> Bool in
				return ticker.id == tickerID
			})
			if let ticker = aTicker, let index = self.tickers?.index(of: ticker) {
				self.showTickerAlert(ticker: ticker)
				self.tickers?.remove(at: index)
			}
		}
		if let tickers = self.tickers, tickers.count > 0 {
			self.showTicker(data: tickers)
		} else {
			self.window?.viewWithTag(1001)?.removeFromSuperview()
			self.tickers = nil
		}
	}

	func saveTicker(ticker:Ticker) {
		let defaults = UserDefaults.standard
		defaults.synchronize()
		if var tickerIDs = defaults.value(forKey: "TickerID") as? [String] {
			if let aID = ticker.id, !tickerIDs.contains(aID) {
				tickerIDs.append(aID)
				defaults.set(tickerIDs, forKey: "TickerID")
			}
		} else {
			defaults.set([ticker.id], forKey: "TickerID")
		}
	}

	@objc func closeTicker(_ sender: UIButton) {
		self.window?.viewWithTag(1001)?.removeFromSuperview()

		if let tickerID = sender.superview?.layer.value(forKey: "TickerID") as? String {
			let aTicker = self.tickers?.first(where: { (ticker) -> Bool in
				return ticker.id == tickerID
			})
			if let ticker = aTicker, let index = self.tickers?.index(of: ticker) {
				self.tickers?.remove(at: index)
			}
		}
		if let tickers = self.tickers, tickers.count > 0 {
			self.showTicker(data: tickers)
		}
	}

	func showTicker(data:[Ticker]) {
		self.tickers = data

		if let ticker = self.tickers?.first {
			let closeAction = #selector(closeTicker(_:))
			let action = #selector(showTickerAlert(_:))
			self.saveTicker(ticker: ticker)
			self.window?.showTickerToast(ticker: ticker, font: UIFont(name: AppFontName.regular, size: 18)!, action:action, closeAction: closeAction)
		}
	}

	func showAnnouncements(data:[Announcement]) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let announcementsVC = storyboard.instantiateViewController(withIdentifier: "AnnouncementsViewController") as? AnnouncementsViewController
		//Pass data to Outlet Popup
		announcementsVC?.announcements = data
		announcementsVC?.modalPresentationStyle = .fullScreen
		self.window?.rootViewController?.present(announcementsVC!, animated: true, completion: {
			print("Done")
		})
		//Completion handler
		announcementsVC?.didSelectAnnouncement = { [unowned self] (announcement:Announcement) in

			if let tabBarController = self.getTabbarController() {
				tabBarController.selectedViewController?.navigationController?.popToRootViewController(animated: true)

				switch announcement.action_screen {
				case "home":
					tabBarController.selectedIndex = 0
				case "order":
					tabBarController.selectedIndex = 1
				case "subscribe":
					tabBarController.selectedIndex = 2
				case "coffeeology":
					tabBarController.selectedIndex = 3
				case "more":
					tabBarController.selectedIndex = 4
				default:
					break
				}
			}
		}
/*
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let announcementsVC = storyboard.instantiateViewController(withIdentifier: "AnnouncementsViewController") as? AnnouncementsViewController
		//Pass data to Outlet Popup
		announcementsVC?.announcements = data

		var attributes: EKAttributes {
            var attributes = EKAttributes.centerFloat
            attributes.displayDuration = .infinity
			attributes.screenBackground = .color(color: EKColor(UIColor(white: 0.5, alpha: 0.2)))
            attributes.entryBackground = .clear
            attributes.screenInteraction = .forward
            attributes.entryInteraction = .absorbTouches

			attributes.roundCorners = .all(radius: 8)
			attributes.border = .value(color: .white, width: 0)

            attributes.scroll = .enabled(swipeable: false, pullbackAnimation: EKAttributes.Scroll.PullbackAnimation.easeOut)
			attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 0.6))
            attributes.positionConstraints.size = .init(width: .ratio(value: 1), height: .ratio(value: 1))
            attributes.statusBar = .inferred

            attributes.entranceAnimation = .init(fade: .init(from: 0.5, to: 1, duration: 0.3))
			attributes.exitAnimation = .init(fade: .init(from: 1, to: 0.5, duration: 0.3))
			attributes.popBehavior = .overridden

            return attributes
        }

		self.window?.rootViewController?.showPopup(vc: announcementsVC!, width: 1, height: 1, popupAttributes: attributes)

		*/
	}

	func loadAnnouncementsData() {

		_ = Alamofire.request(APIRouters.GetAnnouncements).responseCollection(completionHandler: { (response: DataResponse<[Announcement]>) in
			DispatchQueue.main.async {
                switch response.result {
                case .success:
                    if let announcements:[Announcement] = response.result.value {
						//Check for new announcements
						let defaults = UserDefaults.standard
						if let oldAnnouncements = defaults.value(forKey: "AnnouncementID") as? [String] {
							let newAnnouncements =  announcements.filter { (announcement) -> Bool in
								return !oldAnnouncements.contains(announcement.id!)
							}
							if newAnnouncements.count > 0 {
								self.showAnnouncements(data: newAnnouncements)
							}
						} else {
							//All announcements are new
                            if(announcements.count > 0)
                            {
							self.showAnnouncements(data: announcements)
                            }
						}
                    } else {
						print("No Announcements to show")
					}
                case .failure(let error):
					print("Error: \(error.localizedDescription)")
				}
            }
		})
    }


	func loadTickerData() {

		_ = Alamofire.request(APIRouters.GetTickers).responseCollection(completionHandler: { (response: DataResponse<[Ticker]>) in
			DispatchQueue.main.async {
                switch response.result {
                case .success:
                    if let tickers:[Ticker] = response.result.value {
						//Check for new announcements
						let defaults = UserDefaults.standard
						if let oldTicker = defaults.value(forKey: "TickerID") as? [String] {
							let newTickers =  tickers.filter { (ticker) -> Bool in
								return !oldTicker.contains(ticker.id!)
							}
							if newTickers.count > 0 {
								self.showTicker(data: newTickers)
							}
						} else {
							//All announcements are new
							self.showTicker(data: tickers)
						}
                    } else {
						print("No Announcements to show")
					}
                case .failure(let error):
					print("Error: \(error.localizedDescription)")
				}
            }
		})
    }

	func getTabbarController() -> UITabBarController? {
		if let rootVC = self.window?.rootViewController as? SWRevealViewController, let navigationVC = rootVC.frontViewController as? UINavigationController {
			for vc in navigationVC.viewControllers {
				if vc is UITabBarController{
					return vc as? UITabBarController
				}
			}
		}
		return nil
	}
}



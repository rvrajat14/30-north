//
//  RewardsViewController.swift
//  30 NORTH
//
//  Created by SOWJI on 17/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire

class RewardsViewController: UIViewController {
    
    
    @IBOutlet weak var gapBetweenBottomLabelAndButtons: NSLayoutConstraint!

    
	var hasAlreadyLaunched : Bool = UserDefaults.standard.bool(forKey: "hasAlreadyLaunchedRewards")

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "Rewards")
		}
	}

	@IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var scannerButton: UIButton!{
       didSet {
            scannerButton.layer.cornerRadius = 3.0
            scannerButton.layer.borderWidth = 1.0
            scannerButton.layer.borderColor = UIColor.homeLineViewGrey.cgColor
            scannerButton.clipsToBounds = true
            scannerButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 18)
            scannerButton.setTitleColor(UIColor.gold, for: .normal)
            scannerButton.backgroundColor = UIColor.black
        }
    }
	@IBOutlet weak var seeRewardsButton: UIButton! {
		didSet {
			seeRewardsButton.layer.cornerRadius = 3.0
			seeRewardsButton.layer.borderWidth = 1.0
			seeRewardsButton.layer.borderColor = UIColor.homeLineViewGrey.cgColor
			seeRewardsButton.clipsToBounds = true
			seeRewardsButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 18)
			seeRewardsButton.setTitleColor(UIColor.gold, for: .normal)
			seeRewardsButton.backgroundColor = UIColor.black
		}
	}
	@IBOutlet weak var rewardTierButton: UIButton! {
		didSet {
			rewardTierButton.layer.cornerRadius = 3.0
			rewardTierButton.layer.borderWidth = 1.0
			rewardTierButton.layer.borderColor = UIColor.homeLineViewGrey.cgColor
			rewardTierButton.clipsToBounds = true
			rewardTierButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 18)
			rewardTierButton.setTitleColor(UIColor.gold, for: .normal)
			rewardTierButton.backgroundColor = UIColor.black
		}
	}
	@IBOutlet weak var rewardsImage: UIImageView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var filledRewardsStack: UIStackView!
    @IBOutlet weak var stackHeightConstraint: NSLayoutConstraint!

    var rewardCatalogs = [Catalog]()
    var rewardPoints: UInt64 = 200
    var isredeemed = 0
    var isFromHome = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        if self.isredeemed == 0 && self.rewardPoints == 0 {
            self.addRewards(rewardPoints: "200")
        } else{
            GetPoints()
        }
        self.loadUI()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.showCartButton(button: infoBarButtonItem())
	}

	func infoBarButtonItem() -> UIBarButtonItem {
		// Create the info button
		let infoButton = UIButton(type: .infoLight)
		// You will need to configure the target action for the button itself, not the bar button itemr
		infoButton.addTarget(self, action: #selector(openOverlay), for: .touchUpInside)
		// Create a bar button item using the info button as its custom view
		let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
		return infoBarButtonItem
	}

	func overlayData() -> NSDictionary {
		let data1 = ["image":"1", "title":"SIGN UP", "detail":"This is where it all begins. When you sign up, not only will you earn rewards for every pound you spend, you'll always be in the know about the latest and the greatest that 30 NORTH Rewards has to offer. Get Caffeinated, Get Rewarded", "note": ""]
		let data2 = ["image":"1", "title":"EARN", "detail":"Every time you make a purchase at 30 NORTH you will be rewarded. Keep earning points and work your way up to Silver and Gold and enjoy the many benefits our rewards program has to offer. We've always got exciting rewards in the pipeline!", "note": ""]
		let data3 = ["image":"1", "title":"REDEEM", "detail":"Once you've earned enough points, choose one of our many exciting rewards as our way of thanking you for your loyalty. 30 NORTH Rewards is always evolving to give you the best possible return on enjoying the greatest cup of coffee Egypt has to offer", "note": "This is a test"]

		let data:[String : Any] = ["title":"WELCOME", "description":"30 NORTH Rewards is your gateway to a world of exclusive offers and unparalleled rewards. Sign up today and you'll get rewarded for everything from buying a cup of coffee to simply celebrating your birthday. We value your loyalty and 30 NORTH Rewards is our way of thanking you.", "data":[data1, data2, data3]]

		return data as NSDictionary
	}

	@objc func openOverlay() {
		let overlayVC = OverlayViewController(nibName: "OverlayViewController", bundle: nil)
		overlayVC.modalPresentationStyle = .fullScreen
		self.present(overlayVC, animated: true) {

			self.hasAlreadyLaunched = true
			UserDefaults.standard.set(true, forKey: "hasAlreadyLaunchedRewards")

			overlayVC.data = self.overlayData()
		}
	}

    func GetPoints() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        let id = UserDefaults.standard.integer(forKey: "userID") 
        Alamofire.request(configs.pointsUrl+"\(id)").responseJSON {  response  in
            _ = EZLoadingActivity.hide()

			//Open Overlay when API returns response
			if (self.hasAlreadyLaunched != true) {
				self.openOverlay()
			}

            if let data = response.result.value {
                if let resultDictionary = data as? [String : Any]{
                   //print(resultDictionary)
                    if let pointsArray = resultDictionary["points"] as? [[String : Any]]{
                        if pointsArray.count > 0{
                            let points = pointsArray[0]
                            if let pointsBalance = points["points_balance"] as? UInt64{
                                self.rewardPoints = UInt64(pointsBalance)
                                
                                if(Common.instance.isUserLogin()) {
                                //        if self.rewardCatalogs.count > 0 {
									var points = self.rewardPoints
									if self.rewardPoints >  4200 {
										points = self.rewardPoints % 4200
										let pt = 4200 - points
//										self.pointsLabel.text =  "You have \(pt) points. Earn \(pt + 500) to fill your cup"
                                        self.pointsLabel.text =  "This cup has \(pt) points. Earn \(4200 - pt) more points to fill it"
									} else {
//										self.pointsLabel.text =  "You have \(self.rewardPoints) points. Earn \(self.rewardPoints) to fill your cup"
                                        self.pointsLabel.text =  "This cup has \(self.rewardPoints) points. Earn \(4200 - self.rewardPoints) more points to fill it"
									}
                                }
                               //print("reward points : \(pointsBalance)")
//                                self.rewardLabel.text =  "\(self.rewardPoints)/4200*"
                            }
                        }
                    }
                }
                //self.pointsLabel.text = String(Int(4200 - self.rewardPoints)) + " points until your FREE drink"
                self.loadUI()
                UserDefaults.standard.set(self.rewardPoints, forKey: "rewardPoints")
                UserDefaults.standard.set(id, forKey: "userID")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func loadUI () {
        self.navItem.titleView = setNavbarImage()
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]

		UIView.animate(withDuration: 0.2) {
            self.filledRewardsStack.removeAllArrangedSubviews()
            var points = self.rewardPoints
            if self.rewardPoints >  4200 {
                
                let filledRewards =  self.rewardPoints / 4200
                points = self.rewardPoints % 4200
                for _ in stride(from: 1, through:filledRewards, by: 1) {
                    let imageView = UIImageView()
                    imageView.backgroundColor = UIColor.clear
                    imageView.image = UIImage(named: "20")
                    imageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
                    imageView.clipsToBounds = true
                    imageView.contentMode = .scaleAspectFit
                    self.filledRewardsStack.addArrangedSubview(imageView)
                    self.filledRewardsStack.translatesAutoresizingMaskIntoConstraints = false
                }
                
                self.rewardLabel.text =  "\(points)"
//                self.rewardLabel.text =  "\(self.rewardPoints)"
                self.stackHeightConstraint.constant = 120
                let pt = 4200 - points
                self.pointsLabel.text =  "This cup has \(pt) points. Earn \(4200 - pt) more points to fill it"
            } else {
                self.rewardLabel.text =  "\(self.rewardPoints)/4200*"
                self.stackHeightConstraint.constant = 0
                self.pointsLabel.text =  "This cup has \(self.rewardPoints) points. Earn \(4200 - self.rewardPoints) more points to fill it"

            }

            /*
            if self.rewardCatalogs.count > 0 {
                var filteredCat = self.rewardCatalogs.filter({ (item) -> Bool in
                    let points1 = Int(item.points!)
                    return points1! > points
                })
                filteredCat = filteredCat.sorted(by: { (item1, item2) -> Bool in
                    let points1 = Int(item1.points!)
                    let points2 = Int(item2.points!)
                    return points1!  < points2!
                })
                let catalogPont = Int(filteredCat[0].points!)
                self.pointsLabel.text = (catalogPont! - points).description + " points to claim your FREE reward"
            }*/
            
            switch points {
            case 0...199 :
                self.rewardsImage.image = UIImage(named: "1")
            case 200...400 :
                self.rewardsImage.image = UIImage(named: "2")
            case 401...600 :
                self.rewardsImage.image = UIImage(named: "3")
            case 601...800 :
                self.rewardsImage.image = UIImage(named: "4")
            case 801...1000 :
                self.rewardsImage.image = UIImage(named: "5")
            case 1001...1200 :
                self.rewardsImage.image = UIImage(named: "6")
            case 1201...1400 :
                self.rewardsImage.image = UIImage(named: "7")
            case 1401...1600 :
                self.rewardsImage.image = UIImage(named: "8")
            case 1601...1800 :
                self.rewardsImage.image = UIImage(named: "9")
            case 1801...2000 :
                self.rewardsImage.image = UIImage(named: "10")
            case 2001...2200 :
                self.rewardsImage.image = UIImage(named: "11")
            case 2201...2400 :
                self.rewardsImage.image = UIImage(named: "12")
            case 2401...2600 :
                self.rewardsImage.image = UIImage(named: "13")
            case 2601...2800 :
                self.rewardsImage.image = UIImage(named: "14")
            case 2801...3000 :
                self.rewardsImage.image = UIImage(named: "15")
            case 3001...3200 :
                self.rewardsImage.image = UIImage(named: "16")
            case 3201...3400 :
                self.rewardsImage.image = UIImage(named: "17")
            case 3401...3600 :
                self.rewardsImage.image = UIImage(named: "18")
            case 3601...3800 :
                self.rewardsImage.image = UIImage(named: "19")
            case 3801...4000 :
                self.rewardsImage.image = UIImage(named: "20")
//            case 4001...4200 :
//                self.rewardsImage.image = UIImage(named: "21")
            default:
                self.rewardsImage.image = UIImage(named: "20")
            }
        }
        
              if Common.instance.isUserLogin() {
                
                gapBetweenBottomLabelAndButtons.constant = 50
                
                  scannerButton.isHidden = false
                  rewardLabel.isHidden = true
                  
//                  pointsLabel.text = "4200 pts to your FREE drink"
              }else{
                gapBetweenBottomLabelAndButtons.constant = 15

                  scannerButton.isHidden = true
                  rewardLabel.isHidden = true
                  pointsLabel.text = "Sign up to earn great rewards"
              }
        
        //Hiding scan button for now.
        gapBetweenBottomLabelAndButtons.constant = 15
        scannerButton.isHidden = true


              
    }
    @IBAction func navigate(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func getReward(_ sender: Any) {
//        if Common.instance.isUserLogin() {
            self.performSegue(withIdentifier: "catalog", sender: self)
//        }else{
//            let rewardsCatalogVC = self.storyboard?.instantiateViewController(withIdentifier: "RewardsCatalogVC") as! RewardsCatalogVC
//            rewardsCatalogVC.rewardCatalogs = rewardCatalogs
//            rewardsCatalogVC.rewardsDelegate = self
//            self.navigationController?.pushViewController(rewardsCatalogVC, animated: true)
//        }
    }

	@IBAction func rewardTierAction(_ sender: Any) {
		let rewardTierVC = RewardTierViewController(nibName: "RewardTierViewController", bundle: nil)
		let nav = UINavigationController(rootViewController: rewardTierVC)
		nav.modalPresentationStyle = .fullScreen
		self.present(nav, animated: true) {
			print("Presented")
		}
	}
}

extension RewardsViewController : RewardPointsDelegate {
    func rewardpointsUpdated() {
        self.GetPoints()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "catalog" {
//           //print("catagl : ", self.rewardCatalogs)
            let vc = segue.destination as! RewardsCatalogVC
//            if Common.instance.isUserLogin() {
//            vc.rewardCatalogs = self.rewardCatalogs.filter({ (item) -> Bool in
//                let points1 = Int(item.points!)
////               //print("points1 \(points1) rewardPoints \(self.rewardPoints)")
//
//                return points1! <= self.rewardPoints
//            })
//            }else{
                vc.rewardCatalogs = rewardCatalogs
//            }
            vc.rewardPoints = rewardPoints
            vc.rewardsDelegate = self
        }
    }
    
    @IBAction func scanAction(_ sender: Any) {
        let scannerVC = ScannerVC(nibName: "ScannerVC", bundle: nil)
        scannerVC.rewardsDelegate = self
        scannerVC.isFromRewards = true
        self.navigationController!.pushViewController(scannerVC, animated: true)
        
        //        scannerVC.modalPresentationStyle = .overCurrentContext
        //        scannerVC.modalTransitionStyle = .crossDissolve
        
    }
    func addRewards(rewardPoints : String) {
        self.view.endEditing(true)
        if let points = Int(rewardPoints) {
            if let id = UserDefaults.standard.value(forKey: "userID") as? Int{
                
                let url = APIRouters.pointsURLString + "\(id)&points=\(points)&type=1"
               //print(url)
                //            let url = "http://lvngs.com/api/do_points?user_id=\(id)&points=\(points)&type=1"
                Alamofire.request(url).responseJSON {  response  in
                    if let result = response.result.value {
                        let data = result as! [String : Any]
                       //print(data)
                        if data["code"] as! Int == 200 {
                            self.GetPoints()
                            _ = SweetAlert().showAlert(language.rewardsTitle,subTitle:language.rewardsWelcomMessage ,style:AlertStyle.customImag(imageFile: "Logo"))
                        }
                    }
                }
            }
        }
    }
}

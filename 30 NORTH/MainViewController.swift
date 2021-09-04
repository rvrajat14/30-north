//
//  MainViewController.swift
//  30 NORTH
//
//  Created by SOWJI on 17/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireMapper
import TGPControls

class MainViewController: BaseViewController {
    
//	@IBOutlet weak var rewardsTableView: UITableView! {
//		didSet {
//			rewardsTableView.backgroundColor = .clear
//			rewardsTableView.isScrollEnabled = true
//			rewardsTableView.delegate = self
//			rewardsTableView.dataSource = self
//			rewardsTableView.tableFooterView = UIView()
//		}
//	}
	@IBOutlet weak var lineView:UIView! {
		didSet {
			lineView.backgroundColor = UIColor.homeLineViewGrey
		}
	}
	@IBOutlet weak var topView: UIView!{
		didSet {
			topView.backgroundColor = .black
		}
	}
	@IBOutlet weak var imageView:UIView!
	@IBOutlet weak var titleLabel: UILabel!{
		didSet {
			titleLabel.textAlignment = .left
			titleLabel.textColor = UIColor.white
			titleLabel.backgroundColor = UIColor.clear
            titleLabel.font = UIFont(name: AppFontName.nexaBlack, size: 20)
			print("Font: \(titleLabel.font)")
		}
	}
    @IBOutlet weak var pointsLabel: UILabel!{
		didSet {
			pointsLabel.backgroundColor = .clear
		}
	}
	@IBOutlet weak var signinButton: UIButton! {
		didSet {
			signinButton.layer.cornerRadius = 5.0
			signinButton.layer.borderColor = UIColor.white.cgColor
			signinButton.layer.borderWidth = 0.0
			signinButton.clipsToBounds = true

			signinButton.backgroundColor = .white
			signinButton.setTitle("Sign In", for: .normal)
			signinButton.setTitleColor(UIColor.black, for: .normal)
		}
	}
	@IBOutlet weak var rewardsView: UIView! {
		didSet {
			rewardsView.backgroundColor = .clear
		}
	}
	@IBOutlet weak var rewardsLabel: UILabel! {
		didSet {
			rewardsLabel.backgroundColor = .clear
		}
	}

	@IBOutlet weak var detailsButton: UIButton! {
		didSet {
			detailsButton.layer.cornerRadius = 5.0
			detailsButton.layer.borderColor = UIColor.gold.cgColor
			detailsButton.layer.borderWidth = 0.0
			detailsButton.clipsToBounds = true

			detailsButton.backgroundColor = .white
			detailsButton.setTitle("REWARDS", for: .normal)
			detailsButton.setTitleColor(UIColor.black, for: .normal)
		}
	}

	@IBOutlet weak var rewardsButton: UIButton! {
		didSet {
			rewardsButton.layer.cornerRadius = 3.0
            rewardsButton.layer.borderColor = UIColor.homeLineViewGrey.cgColor
			rewardsButton.layer.borderWidth = 1.0
			rewardsButton.clipsToBounds = true

			rewardsButton.backgroundColor = .black
			rewardsButton.setTitle("REWARDS", for: .normal)
			rewardsButton.setTitleColor(UIColor.gold, for: .normal)
		}
	}
//    @IBOutlet weak var greetingView: UIView!

	@IBOutlet weak var pointsView: UIView! {
		didSet {
			pointsView.backgroundColor = .clear
		}
	}
    @IBOutlet weak var sliderView: UIView!{
		didSet {
			sliderView.backgroundColor = .clear
		}
	}
    
    @IBOutlet weak var detailView: UIView!{
		didSet {
			detailView.backgroundColor = .clear
		}
	}
//    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! // default = 320

    @IBOutlet weak var discreteSlider: TGPDiscreteSlider!
    @IBOutlet weak var camelsSlider: TGPCamelLabels!

    var rewardPoints : UInt64 = 0
    var loginUserId: Int = 0
    var isredeemed = -1
    var rewardCatalogs = [Catalog]()
    var filteredCatalogs = [Catalog]()
    var rewards = [NewsFeedModel]()
    var feeds = [NewsFeedModel]()
    var refreshControl = UIRefreshControl()
    var scrollIndex = -1

	lazy var loyaltyText:String = {
		guard let loyaltyTierData = UserDefaults.standard.object(forKey: "LoyaltyTier") as? NSData, let loyaltyTier = NSKeyedUnarchiver.unarchiveObject(with: loyaltyTierData as Data) as? String else {
			return ""
		}
		return loyaltyTier
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
       
        NotificationCenter.default.addObserver(self, selector: #selector(bindUserInfo), name: NSNotification.Name(rawValue: "KRefreshHome"), object: nil)

		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "MoreButtonAction"), object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
			guard let info = notification.userInfo, let sender = info["sender"] as? UIButton else {
				return
			}
			let newsFeed = self.feeds[sender.tag]
			if newsFeed.newsType == "1"{
				self.moveToDetail(index: sender.tag)
			}else if newsFeed.newsType == "2"{
				self.moveToItemDetail(index: sender.tag)
			}else if newsFeed.newsType == "3"{
			}else{
			}
		}

        self.loadUI()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if UserDefaults.standard.integer(forKey: "rewardPoints") >= 0 {
			UIView.animate(withDuration: 0.2) {
			  self.rewardPoints = UInt64(UserDefaults.standard.integer(forKey: "rewardPoints"))
			  self.setPointsLabel()
			}
		}
	}

    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.showCartButton()
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()

        discreteSlider.minimumValue = 0
        discreteSlider.incrementValue = 500
        
        camelsSlider.roundCorners(.allCorners, radius: 5)
        camelsSlider.tickCount = 9
        camelsSlider.names = ["", "1000","2000","3000",""]
        camelsSlider.tintColor = .white

		//let userdID = self.isUserLoggedIn()
		/*let topViewHeightConstraint = self.greetingView.constraints.first { (constraint) -> Bool in
			return constraint.identifier == "GreetingViewHeight"
		}*/
		/*if userdID > 0 {
			topViewHeightConstraint?.constant = 25.0
		} else {
			topViewHeightConstraint?.constant = 45.0
		}*/
    }

    func loadUI() {

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        //rewardsTableView.addSubview(refreshControl)

//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            menuButton.tintColor = UIColor.white
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        }
//        self.rewardsviewHeightConstraint.constant = 0
//        self.rewardsView.isHidden = true
//        self.rewardsCollectionView!.dataSource = self
//        rewardsCollectionView?.delegate = self
//        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top:10,left:15,bottom:10,right:15)
//        layout.minimumInteritemSpacing = 10
//        layout.minimumLineSpacing = 25
//        self.rewardsCollectionView!.isPrefetchingEnabled = false
//        layout.scrollDirection = .horizontal
//        self.rewardsCollectionView!.collectionViewLayout = layout
//        self.rewardsCollectionView!.backgroundColor = .black
//        self.view.addSubview(self.rewardsCollectionView!)
        
        self.getFeedAPI()
        self.bindUserInfo()
        
    }

    @objc func reloadTableViewWithDelay(){
        //rewardsTableView.reloadData()
    }

    @objc func autoSwipeRewardTableCell() {
        var indexpath: IndexPath
        scrollIndex = scrollIndex + 1
        if scrollIndex < rewards.count{
            indexpath = IndexPath(row: scrollIndex, section: 0)
            UIView.animate(withDuration: 2.0, delay: 2.0, options: .transitionCurlUp, animations: {
            }) { (success) in
                
            }
        }else{
            scrollIndex = 0
            indexpath = IndexPath(row: scrollIndex, section: 0)
        }
    }

    
    @objc func refresh(sender:AnyObject) {
        self.getFeedAPI()
    }
    
    func moveToItemDetail(index: Int){
        
        let newsFeed = self.feeds[index]
        
        weak var itemDetailPage = self.storyboard?.instantiateViewController(withIdentifier: "ItemDetail") as? ItemDetailViewController
        itemDetailPage!.selectedItemId = Int(newsFeed.newsItemId)!
        self.navigationController?.pushViewController(itemDetailPage!, animated: true)
//        itemDetailPage!.selectedItemId = Int(index)!
//        itemDetailPage!.selectedShopId = selectedShopId
//        itemDetailPage!.selectedAttributeStr = itemCell!.selectedAttribute
//        itemDetailPage!.selectedAttributeIdsStr = itemCell!.selectedAttributeIds
//        itemDetailPage!.selectedShopArrayIndex = selectedShopArrayIndex
//        itemDetailPage!.refreshLikeCountsDelegate = nil
//        itemDetailPage!.refreshReviewCountsDelegate = nil
//        itemDetailPage!.basketTotalAmountUpdateDelegate = self
//        itemDetailPage!.isEditMode = true
        
    }
    
    @IBAction func onDetail(_ sender: UIButton) {
        let newsFeed = self.feeds[sender.tag]
        
        if newsFeed.newsType == "1"{
            moveToDetail(index: sender.tag)
        }else if newsFeed.newsType == "2"{
            moveToItemDetail(index: sender.tag)
        }else if newsFeed.newsType == "3"{
            
            
        }else{
            
            
        }
    }
    
    @IBAction func joinNow(_ sender: Any) {
        weak var UserRegViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as? RegisterViewController
        UserRegViewController?.fromWhere = ""
        self.navigationController?.pushViewController(UserRegViewController!, animated: true)
    }
    @IBAction func showRewardsDetils(_ sender: UIButton) {
        
        let rewardsVC = self.storyboard?.instantiateViewController(withIdentifier: "Rewards") as! RewardsViewController
        rewardsVC.rewardPoints = UInt64(self.rewardPoints)
        rewardsVC.isFromHome = true
        rewardsVC.isredeemed = self.isredeemed
        rewardsVC.rewardCatalogs = self.rewardCatalogs
        self.navigationController?.pushViewController(rewardsVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRewardsScreen" {
            if let vc = segue.destination as? RewardsViewController{
                vc.rewardPoints = UInt64(self.rewardPoints)
                vc.isFromHome = true
                vc.isredeemed = self.isredeemed
                vc.rewardCatalogs = self.rewardCatalogs
            }
        }
    }

    func GetPoints() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        _ = Alamofire.request(configs.pointsUrl+"\(self.loginUserId)").responseObject {
            (response: DataResponse<Points>) in
            _ = EZLoadingActivity.hide()
            if let data : Points = response.result.value {
                self.rewardPoints = UInt64(data.points ?? 0)
                self.setPointsLabel()
                self.isredeemed = data.isRedeemed ?? -1
                UserDefaults.standard.set(self.rewardPoints, forKey: "rewardPoints")
                UserDefaults.standard.set(self.loginUserId, forKey: "userID")
                UserDefaults.standard.synchronize()
            }            
        }
    }
    
    @IBAction func signinAction(_ sender: Any) {
        weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
        UserLoginViewController?.fromWhere = ""
        self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
    }

    @objc func bindUserInfo() {

        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: plistPath)) {
            if let bundlePath = Bundle.main.path(forResource: "LoginUserInfo", ofType: "plist") {
                
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: plistPath)
                } catch{
                    
                }
                
                
            } else {
                //print("LoginUserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
            
        } else {
            //print("LoginUserInfo.plist already exits at path.")
        }
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        
        if let dict = myDict {
           loginUserId = Common.instance.getLoginUserId(dict: dict)

            if(loginUserId != 0) {
                self.GetPoints()
//                rewardsTableTopConstraint.constant = -30
//                rewardsTableView.isHidden = false
//                self.rewardsView.isHidden = false
//                rewardsTableView.isHidden = false
                self.signinButton.isHidden = true
//                self.signinStack.isHidden = true
                //self.btnJoinnow.isHidden = true
				var name = ""
				if let firstName = dict.object(forKey: "_login_user_username") as? String {
					name += firstName
				}
				if let lastName = dict.object(forKey: "_login_user_lastname") as? String {
					name += " " + lastName
				}
                //self.titleLabel.text = getLocaleString() + name
                self.titleLabel.text = "Hi " + name
                
                pointsView.isHidden = false
                sliderView.isHidden = false
				detailView.isHidden = true
//                pointsViewHeight.constant = 30
//                sliderViewHeight.constant = 60
                
                pointsLabel.text = "4200 pts to your FREE drink"
            } else {
//                rewardsTableTopConstraint.constant = 10
//                self.rewardsView.isHidden = true
//                rewardsTableView.isHidden = true
                self.signinButton.isHidden = false
//                self.signinStack.isHidden = false
                //self.btnJoinnow.isHidden = false
                self.titleLabel.text = "- Beans, Brews & Tales -"//"It's a great day for Coffee"
                
                pointsView.isHidden = true
                sliderView.isHidden = true
				detailView.isHidden = false
//                pointsViewHeight.constant = 0
//                sliderViewHeight.constant = 0
                
                pointsLabel.text = "Sign up to earn rewards"
            }
            
        } else {
           //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
			self.titleLabel.text = "- Beans, Brews & Tales -"//"It's a great day for Coffee"
        }
    }

    func getLocaleString() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let min = Calendar.current.component(.hour, from: Date())
        
        if  0..<12 ~= hour { return "GOOD MORNING, " }
        else if (12..<16 ~= hour) {  return "GOOD AFTERNOON, "}
        else if (17 == hour) && (min < 31){  return "GOOD AFTERNOON, "}
        else if (17 == hour) && (min > 30){  return "GOOD EVENING, "}
        else if (18..<22 ~= hour) {  return "GOOD EVENING, " }
        else if (hour == 23) && (min <= 59) { return "GOOD EVENING, " }
        else { return "GOOD EVENING, " }
    }
  
}

//MARK:- TableView Delegate
extension MainViewController {
	/*
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feeds.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardTableViewCell", for: indexPath) as! RewardTableViewCell
        
        cell.rewardImage.layoutIfNeeded()
        cell.rewardImage.loadImage(urlString: (configs.imageUrl + self.feeds[indexPath.row].newsFeedImage)) { (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
            }else {
               //print("Error in loading image" + msg)
            }
        }
        cell.detailButton.tag = indexPath.row
        cell.rewardTitle.text = self.feeds[indexPath.row].newsFeedTitle
//        cell.rewardDesc.text = self.feeds[indexPath.row].newsFeedDesc
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        cell.rewardImage.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
        
        let rewardDesc = self.feeds[indexPath.row].newsFeedDesc
        cell.rewardDesc.text = rewardDesc
        cell.rewardDesc.addTrailing(with: "... ", moreText: "Readmore")
        if self.feeds[indexPath.row].newsType == "1"{
            if self.feeds[indexPath.row].hasDetail == "1"{
                cell.detailButton.setTitle("MORE", for: .normal)
                cell.detailButton.isHidden = false
            }else{
                cell.detailButton.isHidden = true
            }
        }else if self.feeds[indexPath.row].newsType == "2"{
            cell.detailButton.setTitle("Order", for: .normal)
        }else if self.feeds[indexPath.row].newsType == "3"{
            cell.detailButton.setTitle("Listen", for: .normal)
        }else{
            cell.detailButton.setTitle("Watch", for: .normal)
        }

		cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
*/
 func moveToDetail(index: Int) {
		let feed = self.feeds[index]
		let imageURL = configs.imageUrl +  feed.newsFeedImages[0].path!
		let title = feed.newsFeedTitle
		let description = feed.newsFeedDesc

		self.showPopup(title: title, description: description, imagePath:imageURL)

        /*
		weak var feedDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetail") as? NewsFeedDetailViewController
        feedDetailViewController?.feedTitle = self.feeds[index].newsFeedTitle
        feedDetailViewController?.feedDesc = self.feeds[index].newsFeedDesc
        feedDetailViewController?.feedImages = self.feeds[index].newsFeedImages
        self.navigationController?.pushViewController(feedDetailViewController!, animated: true)
		*/
    }

    func fetchCatalog() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        if self.rewardCatalogs.count < 1 {

            let url =  APIRouters.baseURLString + "/rewards/get"
            _ = Alamofire.request(url).responseCollection {
                (response: DataResponse<[Catalog]>) in
                            _ = EZLoadingActivity.hide()
                if response.result.isSuccess {
                    if let cats : [Catalog] = response.result.value {
                        self.rewardCatalogs = cats
                        if self.rewardCatalogs.count > 0 {
                            self.setPointsLabel()
                            return
                        }
                    }
                }
                self.fetchCatalog()
            }
        }
    }

    func setPointsLabel() {

        if(loginUserId != 0) {
            var points = self.rewardPoints
            if self.rewardPoints >  4200 {
                self.rewardsLabel.text =  "YOU HAVE \(points) POINTS"
                self.rewardsLabel.font = UIFont(name: AppFontName.regular, size: 16)
                points = self.rewardPoints % 4200
                let pt = 4200 - points
                self.discreteSlider.value = CGFloat(pt)
                //self.pointsLabel.text =  "Earn \(pt + 500) to fill your next rewards cup"
                //self.pointsLabel.text =  "Earn \(pt + 500) to collect another rewards cup"
            }else {
                self.rewardsLabel.text =  "\(self.rewardPoints)/4200*"
                self.discreteSlider.value = CGFloat(self.rewardPoints)
                //self.pointsLabel.text =  "You have \(self.rewardPoints) points. Earn \(self.rewardPoints + 500) to fill your cup"
            }
			self.pointsLabel.font = UIFont(name: AppFontName.regular, size: 16)
			self.pointsLabel.text = self.loyaltyText
			if self.loyaltyText.lowercased().contains("gold") {
				self.pointsLabel.textColor = UIColor.goldTier
			} else if self.loyaltyText.lowercased().contains("sliver") {
				self.pointsLabel.textColor = UIColor.silver
			} else if self.loyaltyText.lowercased().contains("bronze") {
				self.pointsLabel.textColor = UIColor.bronze
			} else {
				self.pointsLabel.textColor = UIColor.white
			}

            pointsView.isHidden = false
            sliderView.isHidden = false
        }else{
            pointsLabel.text = "Sign up to earn rewards"
            pointsView.isHidden = true
            sliderView.isHidden = true
        }
    }
}

extension MainViewController {

	func setImageScroller() {

		let v = CCLoopCollectionView(frame: imageView.bounds.insetBy(dx: 0, dy: 0))
        v.contentAry = self.feeds
        
        v.enableAutoScroll = true
        v.timeInterval = 10.0

        v.currentPageControlColor = UIColor.red
        v.pageControlTintColor = UIColor.white

        imageView.addSubview(v)
	}

    func getFeedAPI(){
        self.feeds.removeAll()

        let url = APIRouters.GetNewsFeedByShopId(1)

        Alamofire.request(url).responseCollection {
            (response: DataResponse<[NewsFeed]>) in
            if response.result.isSuccess {
                if let newsFeeds: [NewsFeed] = response.result.value {
                    for newsFeed in newsFeeds {
                        let oneFeed = NewsFeedModel(newsFeed: newsFeed)
                        self.feeds.append(oneFeed)
                    }
					self.setImageScroller()
                    self.view.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    self.fetchCatalog()
                } else {
                   //print(response)
                }
            }else{
                self.getFeedAPI()
            }
        }
        refreshControl.endRefreshing()
    }
    /*
    func getRewardsAndNewsFeed() {
//                if let _ = settingsDetailModel{
//
//                }else{
//                    appDelegate.doSettingsAPI()
//                }

       //print("feed url : ", APIRouters.GetRewardsFeedByShopId(1))
        Alamofire.request(APIRouters.GetRewardsFeedByShopId(1)).responseObject { (response: DataResponse<Rewards>) in
            if response.result.isSuccess {
                
                /*******     RewardsFeed   *********/
                
            if let rewardFeeds = response.result.value?.data?.rewardfeeds{
//               //print("RewardsFeeds", rewardFeeds)
                for newsFeed in rewardFeeds {
//                    let oneFeed = NewsFeedModel(newsFeed: newsFeed)
//                    let oneFeed = NewsFeedModel(newsFeedId: newsFeed.id!, newsFeedTitle: newsFeed.title!, newsFeedDesc: newsFeed.desc!, newsFeedAdded: newsFeed.added!, newsFeedImage: "",NewsFeedImages: newsFeed.images)
                    
                    var newsFeedImage = ""
                    var newsFeedImages = [Image]()
                    
                    if let newFeedImageArray = newsFeed.images, newFeedImageArray.count > 0 {
                        newsFeedImage = newFeedImageArray[0].path ?? ""
                        let newsFeedImageModel = newFeedImageArray[0]
                        
                        let imageModel = Image(imageData: newsFeedImageModel)
                        newsFeedImages.append(imageModel)
                        
                    }
                    
                    let oneFeed = NewsFeedModel(newsFeedId: newsFeed.id ?? "", newsFeedTitle: newsFeed.title ?? "", newsFeedDesc: newsFeed.desc ?? "", newsFeedAdded: newsFeed.added ?? "", newsFeedImage: newsFeedImage, NewsFeedImages: newsFeedImages, newsFeed.images ?? [Images](), newsType: newsFeed.type ?? "", newsItemId: newsFeed.itemId ?? "", newsShopId: newsFeed.shopId ?? "")
                    self.rewards.append(oneFeed)
                }
//                self.rewardsCollectionView.reloadData()
//                self.rewardsCollectionView.reloadData()
            }
                
                /*******     NewsFeed   *********/
                
                if let rewardFeeds = response.result.value?.data?.feeds{
                   //print("Feeds : ", rewardFeeds)
                    for newsFeed in rewardFeeds {
                  
                        var newsFeedImage = ""
                        var newsFeedImages = [Image]()
                        
                        if let newFeedImageArray = newsFeed.images, newFeedImageArray.count > 0 {
                            newsFeedImage = newFeedImageArray[0].path ?? ""
                            let newsFeedImageModel = newFeedImageArray[0]
                            
                            let imageModel = Image(imageData: newsFeedImageModel)
                            newsFeedImages.append(imageModel)
                            
                        }
                        
                        let oneFeed = NewsFeedModel(newsFeedId: newsFeed.id ?? "", newsFeedTitle: newsFeed.title ?? "", newsFeedDesc: newsFeed.desc ?? "", newsFeedAdded: newsFeed.added ?? "", newsFeedImage: newsFeedImage, NewsFeedImages: newsFeedImages, newsFeed.images ?? [Images](), newsType: newsFeed.type ?? "", newsItemId: newsFeed.itemId ?? "", newsShopId: newsFeed.shopId ?? "")
                        self.feeds.append(oneFeed)
                    }
                    self.view.layoutIfNeeded()
                    self.rewardsTableView.reloadData()
                    self.view.layoutIfNeeded()
                }

                self.tableViewHeightConstraint.constant = self.rewardsTableView.contentSize.height
                self.fetchCatalog()

            }else{
                self.getRewardsAndNewsFeed()
            }
        }
        refreshControl.endRefreshing()
    }*/
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    ///*
    //MARK:- CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewards.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width + 40, height: 150)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeRewardsFeedCollectionViewCell", for: indexPath) as! HomeRewardsFeedCollectionViewCell
        cell.rewardImage.loadImage(urlString: (configs.imageUrl + self.rewards[indexPath.row].newsFeedImage)) { (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
            }else {
               //print("Error in loading image" + msg)
            }
        }
            cell.rewardTitle.text = self.rewards[indexPath.row].newsFeedTitle
            let rewardDesc = self.rewards[indexPath.row].newsFeedDesc
            cell.rewardDesc.text = rewardDesc
            cell.rewardDesc.addTrailing(with: "... ", moreText: "Readmore")
    
             cell.rewardImage.roundCorners(corners: [.topLeft, .bottomLeft], radius: 8.0)

        return  cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        weak var feedDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetail") as? NewsFeedDetailViewController
        feedDetailViewController?.feedTitle = self.rewards[indexPath.row].newsFeedTitle
        feedDetailViewController?.feedDesc = self.rewards[indexPath.row].newsFeedDesc
        feedDetailViewController?.feedImages = self.rewards[indexPath.row].newsFeedImages
        self.navigationController?.pushViewController(feedDetailViewController!, animated: true)
    }
   
 //   */
}


extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String) {

        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        if lengthForVisibleString > 50 && self.text!.contains(moreText) == false{
            let readmoreFont = UIFont(name: "NexaLight", size: 12.0)
            let readmoreFontColor = UIColor.black
            let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
            let readMoreLength: Int = (readMoreText.count + 5)
            let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
            let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
            let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: readmoreFont!, NSAttributedString.Key.foregroundColor: readmoreFontColor])
            answerAttributed.append(readMoreAttributed)
            self.attributedText = answerAttributed
        }
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}

extension UIImageView{
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension MainViewController: TGPControlsTicksProtocol{
    func tgpTicksDistanceChanged(ticksDistance: CGFloat, sender: AnyObject) {
        
    }
    
    func tgpValueChanged(value: UInt) {
        
    }
    
        
}

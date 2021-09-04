//
//  ReviewsListTableViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 13/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

@objc protocol ReviewListRefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviews: [AnyObject])
}

class ReviewsListTableViewController: UITableViewController {
    
    var reviews = [ReviewModel]()
    var selectedItemId:Int = 0
//    var selectedShopId:Int = 1
    weak var itemDetailRefreshReviewCountsDelegate : ItemDetailRefreshReviewCountsDelegate!
    weak var itemDetailLoginUserIdDelegate: ItemDetailLoginUserIdDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        tableView.estimatedRowHeight = 101
        tableView.rowHeight = UITableView.automaticDimension
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ReviewsListTableViewController.onAddReview(_:)))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableView = nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        
        weak var review = reviews[(indexPath as NSIndexPath).row]
        cell.configure(review!.reviewUserName,
                       reviewMessageText:review!.reviewMessage,
                       reviewAdded: review!.reviewAdded,
                       reviewUserImageURL: review!.reviewUserImageURL
        )
        
        var imageURL = ""
        if review!.reviewUserImageURL == "" {
            imageURL = configs.imageUrl + "default_user_profile.png"
        } else {
            imageURL = configs.imageUrl + review!.reviewUserImageURL
        }
        
        cell.userImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
                
            }else {
               //print("Error in loading image" + msg)
            }
        }
        
        cell.userName.alpha = 0
        cell.reviewMessage.alpha = 0
        cell.userImage.alpha = 0
        
        cell.userName.alpha = 1.0
        cell.reviewMessage.alpha = 1.0
        cell.userImage.alpha = 1.0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    @objc func onAddReview(_ sender: AnyObject) {
        if(Common.instance.isUserLogin()) {
            weak var reviewFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewEntryViewController") as? ReviewEntryViewController
            reviewFormViewController?.selectedItemId = selectedItemId
            reviewFormViewController?.reviewListRefreshReviewCountsDelegate = self
//            reviewFormViewController?.selectedShopId = selectedShopId
            self.navigationController?.pushViewController(reviewFormViewController!, animated: true)
        } else {
            weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
            UserLoginViewController?.title = "Login"
            UserLoginViewController?.reviewListRefreshReviewCountsDelegate = self
            //UserLoginViewController?.itemDetailLoginUserIdDelegate = self
            UserLoginViewController?.itemDetailLoginUserIdDelegate = self.itemDetailLoginUserIdDelegate
//            UserLoginViewController?.selectedShopId = selectedShopId
            UserLoginViewController?.selectedItemId = selectedItemId
            UserLoginViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
        }
        updateBackButton()
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.reviewListPageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
}

extension ReviewsListTableViewController : ReviewListRefreshReviewCountsDelegate {
    func updateReviewCounts(_ reviews: [AnyObject]){
        
        if reviews.count > 0 {
            
            self.reviews = [ReviewModel]()
            self.tableView.reloadData()
            for review in reviews as! [ReviewModel] {
                self.reviews.append(review)
            }
            self.tableView.reloadData()
            self.itemDetailRefreshReviewCountsDelegate.updateReviewCounts(self.reviews.count)
        }
        
    }
}


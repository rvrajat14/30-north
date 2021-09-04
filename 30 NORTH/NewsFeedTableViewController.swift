//
//  NewsFeedViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 22/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class NewsFeedTableViewController : UITableViewController {
    
    var selectedShopId = 1
    var feeds = [NewsFeedModel]()
    var itemImages = [ImageModel]()
    var defaultValue: CGPoint!
    
    override func viewDidLoad(){
        loadNewsFeed()
        self.refreshControl?.addTarget(self, action: #selector(NewsFeedTableViewController.onTableViewRefresh(_:)), for: UIControl.Event.valueChanged)
        
        defaultValue = tableView?.frame.origin
        animateTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        let feed = feeds[(indexPath as NSIndexPath).row]
        cell.configure(feed.newsFeedTitle, desc: feed.newsFeedDesc, added: feed.newsFeedAdded, imageName: feed.newsFeedImage, feedImgs: feed.newsFeedImages)
        
        let imageURL = configs.imageUrl + feed.newsFeedImage
        
        cell.feedCoverImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
                
            }else {
               //print("Error in loading image" + msg)
            }
        }
        
        cell.feedCoverImage.alpha = 0
        cell.feedTitle.alpha = 0
        cell.feedDesc.alpha = 0
        cell.feedAdded.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            cell.feedCoverImage.alpha = 1.0
            cell.feedTitle.alpha = 1.0
            cell.feedDesc.alpha = 1.0
            cell.feedAdded.alpha = 1.0
        }, completion: nil)
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FeedCell
        let feedDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetail") as? NewsFeedDetailViewController
        self.navigationController?.pushViewController(feedDetailViewController!, animated: true)
        feedDetailViewController?.feedTitle = cell.feedTitle.text
        feedDetailViewController?.feedDesc = cell.feedDesc.text
        feedDetailViewController?.feedImages = cell.feedImages
        updateBackButton()
    }
    
    @objc func onTableViewRefresh(_ sender:AnyObject)
    {
        self.feeds.removeAll()
        loadNewsFeed()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func loadNewsFeed() {
    
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        Alamofire.request(APIRouters.GetNewsFeedByShopId(selectedShopId)).responseCollection {
            (response: DataResponse<[NewsFeed]>) in
            
            _ = EZLoadingActivity.hide()
            
            if response.result.isSuccess {
                if let newsFeeds: [NewsFeed] = response.result.value {
                    
                    for newsFeed in newsFeeds {
                        let oneFeed = NewsFeedModel(newsFeed: newsFeed)
                        self.feeds.append(oneFeed)
                    }
                    self.tableView.reloadData()
                    
                } else {
                   //print(response)
                }
            }
            
            
        }
        
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.feedListPageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    func animateTableView() {
        
        moveOffScreen()
        
        UIView.animate(withDuration: 1) {
                        self.tableView?.frame.origin = self.defaultValue
        }
    }
    
    fileprivate func moveOffScreen() {
        tableView?.frame.origin = CGPoint(x: (tableView?.frame.origin.x)!,
                                          y: (tableView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
}

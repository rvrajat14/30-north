//
//  AutoImageScrollView.swift
//  30 NORTH
//
//  Created by SOWJI on 02/02/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class AutoImageScrollView: UIView,UIScrollViewDelegate {

    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var newsScrollView: UIScrollView!

	@IBOutlet weak var titleBGView: UIView! {
		didSet {
			titleBGView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
		}
	}

    @IBOutlet weak var titleName: UILabel!

    @IBOutlet weak var pageControl: UIPageControl!
    
    var parentView : UIViewController! = nil
    
    var feeds = [NewsFeedModel]()
    
    
    
    func configure(selectedShopId : Int, parentView : UIViewController,isFromMain : Bool) {
        
        // load image and set to header image view
        
//        if data.backgroundImage != "" {
//            let coverImageName = data.backgroundImage as String
//            let coverImageURL = configs.imageUrl + coverImageName
//            
//            self.headerImageView.loadImage(urlString: coverImageURL) {  (status, url, image, msg) in
//                if(status == STATUS.success) {
//                   //print(url + " is loaded successfully.")
//                    
//                }else {
//                   //print("Error in loading image" + msg)
//                }
//            }
//            
//        }
        
        self.parentView = parentView
        
        // for news //self.headerImageView.frame.width
        self.newsScrollView.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width , height:self.headerImageView.frame.height)
        let scrollViewWidth:CGFloat = self.newsScrollView.frame.width
        let scrollViewHeight:CGFloat = self.newsScrollView.frame.height
        
    
        var img = [UIImageView]()
        var ii : Int = 0
        self.feeds.removeAll()
        var url : APIRouters?
        if isFromMain == true {
            url = APIRouters.GetRewardsFeedByShopId(1)
            //url = APIRouters.GetNewsFeedByShopId(selectedShopId)
        } else {
            //url = APIRouters.GetNewsFeedByShopId(1)
            url = APIRouters.GetHeighlights

        }
        
        Alamofire.request(url!).responseCollection {
            (response: DataResponse<[NewsFeed]>) in
            if response.result.isSuccess {
                if let newsFeeds: [NewsFeed] = response.result.value {
                    
                    for newsFeed in newsFeeds {
                        let oneFeed = NewsFeedModel(newsFeed: newsFeed)
                        self.feeds.append(oneFeed)
                        
                        if ii != 0 {
                            img.append(UIImageView(frame: CGRect(x:scrollViewWidth * (CGFloat(ii)), y:0,width:scrollViewWidth, height:scrollViewHeight)))
                        }
                        else {
                            img.append(UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight)))
                        }
                        
                        //img[ii].image = UIImage(named: "ProfileBackground")
                        let imageURL = configs.imageUrl + oneFeed.newsFeedImage
                       //print("Image URL is : " + imageURL)
                        img[ii].loadImage(urlString: imageURL) {  (status, url, image, msg) in
                            if(status == STATUS.success) {
                               //print(url + " is loaded successfully.")
                                
                            }else {
                               //print("Error in loading image" + msg)
                            }
                        }
                        img[ii].contentMode = UIView.ContentMode.scaleAspectFill
                        self.newsScrollView.addSubview(img[ii])
                        
                        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(img:)))
                        img[ii].isUserInteractionEnabled = true
                        img[ii].addGestureRecognizer(tapGestureRecognizer)
                        
                        ii = ii + 1
                        
                        
                        
                    }
                    
                    self.newsScrollView.contentSize = CGSize(width:self.newsScrollView.frame.width * CGFloat(ii), height:self.newsScrollView.frame.height)
                    self.newsScrollView.delegate = self
                    self.pageControl.currentPage = 0
                    if self.feeds.count > 0 {
                    self.titleName.text = self.feeds[0].newsFeedTitle
                    }
                    self.pageControl.numberOfPages = self.feeds.count
                    // _ = EZLoadingActivity.hide()
                    let _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
                    
                } else {
                   //print(response)
                }
            }
        }
    }
    
    
    @objc func handleTimer() {
        var page = Int(newsScrollView.contentOffset.x / self.newsScrollView.frame.width)
        
        if ( page + 1 < self.feeds.count)
        {
            page += 1
            pageControl.currentPage = page
            self.titleName.text = self.feeds[page].newsFeedTitle

        }
        else
        {
            page = 0;
            pageControl.currentPage = page
//            self.titleName.text = self.feeds[page]?.newsFeedTitle

        }
        self.changePage()
    }
    
    @objc func changePage() {
        let width = self.newsScrollView.frame.width * CGFloat(pageControl.currentPage)
        self.newsScrollView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
    }
    @objc func imageTapped(img: AnyObject)
    {
       //print("selected index is \(self.pageControl.currentPage)")
        
        // Disabling tap on top sliders for Orders main page.
        let vc = self.parentView
        print ("\(String(describing: vc?.description))")
        if vc!.isKind(of: SelectedShopViewController.classForCoder()) {
            return
        }
        
        let feedDetailViewController = self.parentView.storyboard?.instantiateViewController(withIdentifier: "FeedDetail") as? NewsFeedDetailViewController
        self.parentView.navigationController?.pushViewController(feedDetailViewController!, animated: true)
        feedDetailViewController?.feedTitle = self.feeds[self.pageControl.currentPage].newsFeedTitle
        feedDetailViewController?.feedDesc = self.feeds[self.pageControl.currentPage].newsFeedDesc
        feedDetailViewController?.feedImages = self.feeds[self.pageControl.currentPage].newsFeedImages
        if let pv = parentView as? SelectedShopViewController? {
            pv?.updateBackButton()
        }
        
    }
    
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        /*
         // Change the text accordingly
         if Int(currentPage) == 0{
         textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
         }else if Int(currentPage) == 1{
         textView.text = "I write mobile tutorials mainly targeting iOS"
         }else if Int(currentPage) == 2{
         textView.text = "And sometimes I write games tutorials about Unity"
         }else{
         textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
         // Show the "Let's Start" button in the last slide (with a fade in animation)
         UIView.animate(withDuration: 1.0, animations: { () -> Void in
         self.startButton.alpha = 1.0
         })
         }*/
    }

}

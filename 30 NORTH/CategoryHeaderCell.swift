//
//  CategoryHeaderCell.swift
//  Restaurateur
//
//  Created by Thet Paing Soe on 3/25/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class CategoryHeaderCell : UITableViewCell, UIScrollViewDelegate  {
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var newsScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var parentView : UIViewController! = nil
    
    var feeds = [NewsFeedModel]()
    
    func configure(_ data: ShopModel?, selectedShopId : Int, parentView : UIViewController) {
        // load image and set to header image view
        
        if let image = shopModel?.backgroundImage {
            let coverImageName = image
            let coverImageURL = configs.imageUrl + coverImageName
            
            self.headerImageView.loadImage(urlString: coverImageURL) {  (status, url, image, msg) in
                if(status == STATUS.success) {
                   //print(url + " is loaded successfully.")
                    
                }else {
                   //print("Error in loading image" + msg)
                }
            }
            
        }
        
        self.parentView = parentView
        
        // for news //self.headerImageView.frame.width
        self.newsScrollView.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width , height:self.headerImageView.frame.height)
        let scrollViewWidth:CGFloat = self.newsScrollView.frame.width
        let scrollViewHeight:CGFloat = self.newsScrollView.frame.height
        
        //2
        /*textView.textAlignment = .center
         textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
         textView.textColor = .black
         self.startButton.layer.cornerRadius = 4.0
         //3*/
        
        /*let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "ProfileBackground")
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "Cover-Image")
        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "AppIcon")
        let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgFour.image = UIImage(named: "ProfileBackground")
        
        self.newsScrollView.addSubview(imgOne)
        self.newsScrollView.addSubview(imgTwo)
        self.newsScrollView.addSubview(imgThree)
        self.newsScrollView.addSubview(imgFour)*/
        //4
        
       
        var img = [UIImageView]()
        var ii : Int = 0
        self.feeds.removeAll()

        //_ = EZLoadingActivity.show("Loading...", disableUI: true)
        Alamofire.request(APIRouters.GetNewsFeedByShopId(1)).responseCollection {
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
                    
                    self.pageControl.numberOfPages = self.feeds.count
                   // _ = EZLoadingActivity.hide()
                    let _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)

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
        }
        else
        {
            page = 0;
            pageControl.currentPage = page
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
        
        let feedDetailViewController = self.parentView.storyboard?.instantiateViewController(withIdentifier: "FeedDetail") as? NewsFeedDetailViewController
        self.parentView.navigationController?.pushViewController(feedDetailViewController!, animated: true)
        feedDetailViewController?.feedTitle = self.feeds[self.pageControl.currentPage].newsFeedTitle
        feedDetailViewController?.feedDesc = self.feeds[self.pageControl.currentPage].newsFeedDesc
        feedDetailViewController?.feedImages = self.feeds[self.pageControl.currentPage].newsFeedImages
        if let pv = parentView as! SelectedShopViewController? {
            pv.updateBackButton()
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

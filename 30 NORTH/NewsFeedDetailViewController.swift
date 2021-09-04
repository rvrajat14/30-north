//
//  NewsFeedDetailViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 23/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class NewsFeedDetailViewController: UIViewController {
    
    var feedTitle: String!
    var feedDesc: String!
    var feedImages = [Image30North]()
    var itemImages = [ImageModel]()
    
    @IBOutlet weak var feedCoverImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UITextView!
    
    @IBOutlet var contentView: UIView!
    var defaultValue: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        
        newsDescription.sizeToFit()
        
        newsTitle.text = feedTitle
        newsDescription.text = feedDesc
        
        let imageURL = configs.imageUrl +  feedImages[0].path!
        
        feedCoverImage.image = nil
        
        self.feedCoverImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
                
            }else {
               //print("Error in loading image" + msg)
            }
        }
        
        if(feedImages.count > 0) {
            for image in feedImages {
                let oneImage = ImageModel(image: image)
                self.itemImages.append(oneImage)
                
            }
            ImageViewTapRegister()
        }
        updateBackButton()
        
        feedCoverImage.alpha = 0
        //        newsTitle.alpha = 0
        newsDescription.alpha = 0
        defaultValue = contentView?.frame.origin
        animateContentView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    func ImageViewTapRegister() {
        let feedImageTap = UITapGestureRecognizer(target: self, action: #selector(NewsFeedDetailViewController.feedImageTapped(_:)))
        feedImageTap.numberOfTapsRequired = 1
        feedImageTap.numberOfTouchesRequired = 1
        self.feedCoverImage.addGestureRecognizer(feedImageTap)
        self.feedCoverImage.isUserInteractionEnabled = true
    }
    
    @objc func feedImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizer.State.ended){
            let imgSliderViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSlider") as? ImageSliderViewController
            self.navigationController?.pushViewController(imgSliderViewController!, animated: true)
            imgSliderViewController?.itemImages = self.itemImages
            updateBackButton()
        }
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.feedDetailPageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]        
    }
    
    func animateContentView() {
        
        moveOffScreen()
        
            self.contentView?.frame.origin = self.defaultValue
            self.feedCoverImage.alpha = 1.0
            self.newsTitle.alpha = 1.0
            self.newsDescription.alpha = 1.0
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
}

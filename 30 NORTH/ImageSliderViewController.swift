//
//  ImageSliderViewController.swift
//  Restaurateur
//
//  Created by Panacea-Soft on 19/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire

class ImageSliderViewController : UIViewController, UIPageViewControllerDataSource {
    
    var itemImages = [ImageModel]()
    weak var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        setupPageControl()
   }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.sliderPageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
   func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        pageController.dataSource = self
    
        if itemImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChild(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParent: self)
    }
    
    func setupPageControl() {
        
        let pageControlAppearance  = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        pageControlAppearance.pageIndicatorTintColor = UIColor.gray
        pageControlAppearance.currentPageIndicatorTintColor = UIColor.white
        pageControlAppearance.backgroundColor = UIColor.darkGray
        //let appearance = UIPageControl.appearance()
        //appearance.pageIndicatorTintColor = UIColor.gray
        //appearance.currentPageIndicatorTintColor = UIColor.red
        //appearance.backgroundColor = UIColor.darkGray
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageImageController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageImageController
        
        if itemController.itemIndex+1 < itemImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    func getItemController(_ itemIndex: Int) -> PageImageController? {
        if itemIndex < itemImages.count {
            let pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ItemImageController") as! PageImageController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = itemImages[itemIndex].imageCoverName
            pageItemController.imageDesc = itemImages[itemIndex].imageDesc
            return pageItemController
        }
        
        return nil
    }
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return itemImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    

    
}

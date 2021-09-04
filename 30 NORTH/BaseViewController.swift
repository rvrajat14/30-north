//
//  BaseViewController.swift
//  30 NORTH
//
//  Created by SOWJI on 05/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        self.updateNavigationStuff()
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
    }

}

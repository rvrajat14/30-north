//
//  CoffeGuide.swift
//  30 NORTH
//
//  Created by SOWJI on 02/04/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class CoffeGuide: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    var pageIndex : Int = 0
    var guideData : ([String],[String])? = nil

     override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        self.label.text = self.guideData!.0[pageIndex]
        self.image.image = UIImage(named:          self.guideData!.1[pageIndex])
        // Do any additional setup after loading the view.
    }
}

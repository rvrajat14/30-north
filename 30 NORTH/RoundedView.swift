
//
//  RoundedView.swift
//  30 NORTH
//
//  Created by SOWJI on 20/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class RoundedView: UIView {

//     Only override draw() if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
      self.layer.cornerRadius = 10.0
      self.clipsToBounds = true
    }
}

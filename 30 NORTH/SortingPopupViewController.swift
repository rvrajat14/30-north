//
//  SortingPopupViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 5/4/17.
//  Copyright © 2017 Panacea-soft. All rights reserved.
//

import Foundation


class SortingPopupViewController: UIViewController, SSRadioButtonControllerDelegate {
    
    @IBOutlet weak var btnClose: UIButton!
    
    var selectedBtnText : String = ""
    
    var sortDelegate : SortDelegate? = nil
    
    var radioButtonController: SSRadioButtonsController?
    
    @IBOutlet weak var btnNameAsc: UIButton!
    
    @IBOutlet weak var btnNameDesc: UIButton!
    
    @IBOutlet weak var btnDateAsc: UIButton!
    
    @IBOutlet weak var btnDateDesc: UIButton!
    
    @IBOutlet weak var btnLikeAsc: UIButton!
    
    @IBOutlet weak var btnLikeDesc: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        showAnimate()
        
        radioButtonController = SSRadioButtonsController(buttons: btnNameAsc, btnNameDesc, btnDateAsc,btnDateDesc,btnLikeAsc,btnLikeDesc)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
    }
    
    
    @IBAction func clickCloseButton(_ sender: Any) {
        removeAnimate()
        self.view.removeFromSuperview()
    }
    
    
    
    @IBAction func clickSortButton(_ sender: Any) {
        sortDelegate?.sortMsg(selectedBtnText)
        removeAnimate()
        self.view.removeFromSuperview()
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    func didSelectButton(selectedButton: UIButton?)
    {
        selectedBtnText = (selectedButton?.titleLabel?.text)!
       //print(selectedBtnText)
    }
    
}


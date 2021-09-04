//
//  SearchPopUpViewController.swift
//  Restaurateur
//
//  Created by Thet Paing Soe on 11/25/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

class SearchPopUpViewController : UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnClose: UIButton!
    
    var searchDelegate : SearchDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        // show animation
        showAnimate()
        
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func onClickCloseButton(_ sender: Any) {
        
        // show animation
        removeAnimate()
        
        // show navi items
        self.searchDelegate?.closePopup()
        
        self.view.removeFromSuperview()
    }
    
    @IBAction func onClickSearchButton(_ sender: Any) {
//        searchDelegate?.searchMsg(txtSearch.text!)
        
        // show animation
        removeAnimate()
        
        self.view.removeFromSuperview()
        let resultViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResult") as? SearchResultViewController
        self.navigationController?.pushViewController(resultViewController!, animated: true)
        resultViewController?.selectedCityId = 1
        resultViewController?.searchKeyword = txtSearch.text
//        updateBackButton()
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

}



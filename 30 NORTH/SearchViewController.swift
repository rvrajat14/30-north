//
//  SearchViewController.swift
//  Restaurateur
//
//  Created by Panacea-soft on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController  {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    //    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchKeyword: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    var defaultValue: CGPoint!
    @IBOutlet var contentView: UIView!
    
    @IBAction func doSearch(_ sender: AnyObject) {
        
        // Dismiss the keyboard
        self.dismissKeyboard()
        
        let resultViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResult") as? SearchResultViewController
        self.navigationController?.pushViewController(resultViewController!, animated: true)
        resultViewController?.selectedCityId = 1
        resultViewController?.searchKeyword = searchKeyword.text
        updateBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        self.hideKeyboardWhenTappedAround()
        
        btnSearch.backgroundColor = Common.instance.colorWithHexString(configs.btnColorCode)
        
//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())        }
        
        self.searchKeyword.delegate = self;
        searchKeyword.alpha = 0
        btnSearch.alpha = 0
        
        defaultValue = contentView?.frame.origin
        animateContentView()
        
        btnSearch.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    func numberOfComponents(in shopPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shopModel!.name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = shopModel!.name
        pickerLabel.font = UIFont(name: customFont.normalFontName , size: CGFloat(customFont.pickerFontSize)) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.searchPageTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]
   }
    
    func animateContentView() {
        
        moveOffScreen()
        
            self.contentView?.frame.origin = self.defaultValue
            self.searchKeyword.alpha = 1.0
            self.btnSearch.alpha = 1.0
    }
    
    fileprivate func moveOffScreen() {
        contentView?.frame.origin = CGPoint(x: (contentView?.frame.origin.x)!,
                                            y: (contentView?.frame.origin.y)! + UIScreen.main.bounds.size.height)
    }
    
}

//MARK: UITextField Delegate
extension SearchViewController : UITextFieldDelegate {
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        self.view.frame.origin.y -= 165
    //       //print("TextField -165")
    //        
    //    }
    //    
    //    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //        self.view.frame.origin.y += 165
    //       //print("TextField +165")
    //        return true
    //    }
}

//
//  ChoiceViewController.swift
//  30 NORTH
//
//  Created by admin on 06/09/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

protocol ChoiceViewControllerDelegate: class {
    func passChoiceValue(_ isSelect: Bool, shopId: Int, index: Int)
}

class ChoiceViewController: UIViewController {
    
    var contentArray = [String]()
    var selectedIndex = 0
//    var shopsData = [ShopModel]()
    var delegate: ChoiceViewControllerDelegate?
    
    @IBOutlet weak var attributeTableHeight: NSLayoutConstraint!
    @IBOutlet weak var choiceTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
	override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

//        self.shopsData = ShopsListModel.sharedManager.shops
//        contentArray = shopModel.map{$0.name }
        
        contentArray = [shopModel!.name]
        choiceTableView.delegate = self
        choiceTableView.dataSource = self
        
        if contentArray.count > 3{
            attributeTableHeight.constant = CGFloat(4 * 60) + 20
        }else{
            attributeTableHeight.constant = CGFloat(contentArray.count * 60) + 20
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }

    }
    
    func removeView(){
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @IBAction func onSelect(_ sender: UIButton) {
        removeView()
//        delegate?.passChoiceValue(true, shopId: Int(self.shopsData[selectedIndex].id)!, index: selectedIndex)
    }
    
    @IBAction func onClose(_ sender: Any) {
        removeView()
    }
    @IBAction func onRowClick(_ sender: UIButton) {
        selectedIndex = sender.tag
        choiceTableView.reloadData()
    }
}

extension ChoiceViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttributesListTableViewCell") as! AttributesListTableViewCell
        cell.titleButton.tag = indexPath.row;
        cell.titleButton.setTitle(contentArray[indexPath.row], for: .normal)
        
        if selectedIndex == indexPath.row{
            cell.plusImage.image = UIImage(named: "ic_radio_check")
        }else{
            cell.plusImage.image = UIImage(named: "ic_radio_uncheck")
        }
        return cell

    }
    
    
    
}


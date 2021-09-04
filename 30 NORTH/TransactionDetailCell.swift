//
//  TransactionDetailCell.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 31/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class TransactionDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var transactionItemName: UILabel!
    @IBOutlet weak var transactionItemNameValue: UILabel!
    @IBOutlet weak var transactionItemPrice: UILabel!
    @IBOutlet weak var transactionItemPriceValue: UILabel!
    @IBOutlet weak var transactionItemQty: UILabel!
    @IBOutlet weak var transactionItemQtyValue: UILabel!
    
    func configure(_ name: String, price: String, qty: String, attribute: String) {
        
        self.backgroundColor = UIColor.black
        
        if(attribute == "") {
            transactionItemName.text = language.transactionItemName
            transactionItemNameValue.text = name
        } else {
            transactionItemName.text = language.transactionItemName
            transactionItemNameValue.text = name + "(" + attribute + ")"
        }
        transactionItemName.textColor = UIColor.gold
        transactionItemNameValue.textColor = .white

        transactionItemPrice.text = language.price
        transactionItemPrice.textColor = UIColor.gold

        transactionItemPriceValue.text = price
        transactionItemPriceValue.textColor = .white

        
        transactionItemQty.textColor = UIColor.gold
        transactionItemQtyValue.textColor = .white
        transactionItemQty.text = language.qty
        transactionItemQtyValue.text = qty
    }
    
}

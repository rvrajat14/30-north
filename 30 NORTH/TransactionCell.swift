//
//  TransactionCell.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 31/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

class TransactionCell: UITableViewCell {

    @IBOutlet weak var innerView: UIView! {
        didSet {
            innerView.layer.cornerRadius = 3.0
            innerView.clipsToBounds = true
            innerView.backgroundColor = UIColor.black
        }
    }

    @IBOutlet weak var transIcon: UIImageView! {
        didSet {
            transIcon.contentMode = .scaleAspectFit
            transIcon.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var giftIcon: UIImageView! {
           didSet {
               giftIcon.contentMode = .scaleAspectFit
               giftIcon.backgroundColor = UIColor.clear
           }
       }

    @IBOutlet weak var transactionNo: UILabel! {
        didSet {
            transactionNo.font = UIFont(name: AppFontName.bold, size: 18)
            transactionNo.textColor = .white
        }
    }

    @IBOutlet weak var totalAmount: UILabel!{
        didSet {
            totalAmount.font = UIFont(name: AppFontName.regular, size: 16)
            totalAmount.textColor = .white
        }
    }

    @IBOutlet weak var paymentStatus: UILabel!{
        didSet {
            paymentStatus.font = UIFont(name: AppFontName.regular, size: 16)
            paymentStatus.textColor = .white
        }
    }

    @IBOutlet weak var transactionStatus: UILabel!{
        didSet {
            transactionStatus.font = UIFont(name: AppFontName.regular, size: 16)
            transactionStatus.textColor = .white
        }
    }

    @IBOutlet weak var pointsEarnedLabel: UILabel!{
       didSet {
           pointsEarnedLabel.font = UIFont(name: AppFontName.regular, size: 16)
           pointsEarnedLabel.textColor = .white
       }
   }

    @IBOutlet weak var detailsButton: UIButton! {
        didSet {
            detailsButton.setTitle("Details", for: .normal)
            detailsButton.setTitleColor(.white, for: .normal)
            detailsButton.backgroundColor = UIColor.gold
            detailsButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

            detailsButton.layer.cornerRadius = 3.0
            detailsButton.clipsToBounds = true
        }
    }

    @IBOutlet weak var payNowButton: UIButton! {
        didSet {
            payNowButton.setTitle("Pay Now", for: .normal)
            payNowButton.setTitleColor(.black, for: .normal)
            payNowButton.backgroundColor = UIColor.white
            payNowButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

			payNowButton.isHidden = true

            payNowButton.layer.cornerRadius = 3.0
            payNowButton.clipsToBounds = true
        }
    }

    @IBOutlet weak var locationButton: UIButton! {
        didSet {
            detailsButton.layer.cornerRadius = 3.0
            detailsButton.clipsToBounds = true
        }
    }

    func configure(_ transNo: String, paymentMethod: String, transStatus: String, total: String) {
        transactionNo.text = language.transactionNo + transNo.trim()
        if(paymentMethod == "cod"){
                paymentStatus.text = language.transactionPayment +  "Delivery"
            }else if(paymentMethod == "poc"){
                paymentStatus.text = language.transactionPayment +  "Pickup"
            }else if(paymentMethod == "epayment"){
                paymentStatus.text = language.transactionPayment +  "Epayment"
            }else{
                paymentStatus.text = language.transactionPayment +  paymentMethod
            }
        transactionStatus.text = language.transactionStatus +  transStatus
        totalAmount.text = language.transactionTotal + total
    }
}


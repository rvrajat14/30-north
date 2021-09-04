//
//  TableviewCells.swift
//  30 NORTH
//
//  Created by SOWJI on 18/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//
import Foundation
import Alamofire


class CatalogCell : UITableViewCell {


    @IBOutlet var innerView: UIView!{
		didSet {
			innerView.layer.cornerRadius = 3.0
			innerView.layer.borderColor = UIColor.darkGray.cgColor
			innerView.layer.borderWidth = 0.5
			innerView.backgroundColor = .black
			innerView.clipsToBounds = true
		}
	}

	@IBOutlet var TitleLabel: UILabel! {
		didSet {
			TitleLabel.textColor = UIColor.gold
			TitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		}
	}

	@IBOutlet var titleBGView: UIView! {
		didSet {
			titleBGView.backgroundColor = UIColor.black
		}
	}

	@IBOutlet var redeemButton: UIButton! {
		didSet {
			redeemButton.layer.cornerRadius = 3.0
			redeemButton.layer.borderWidth = 1.0
			redeemButton.layer.borderColor = UIColor.homeLineViewGrey.cgColor
			redeemButton.clipsToBounds = true
			redeemButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 18)
			redeemButton.setTitleColor(UIColor.gold, for: .normal)
			redeemButton.backgroundColor = UIColor.black
		}
	}

	@IBOutlet var catlogImage: UIImageView! {
		didSet {
            catlogImage.layer.borderColor = UIColor.darkGray.cgColor
            catlogImage.layer.borderWidth = 0.0
			catlogImage.layer.cornerRadius = 3.0

            //Scale aspect fit so that pattern behind the image can be seen.
			catlogImage.contentMode = .scaleAspectFill
			catlogImage.clipsToBounds = true
			catlogImage.backgroundColor = .clear
		}
	}

	@IBOutlet weak var descriptionLabel: UILabel! {
		didSet {
			descriptionLabel.textColor = .white
			descriptionLabel.font = UIFont(name: AppFontName.regular, size: 14)
		}
	}
    
}


class brewCell : UITableViewCell {


    @IBOutlet var innerView: UIView!{
        didSet {
            innerView.backgroundColor = .black
        }
    }

   
   
    @IBOutlet var tile1Btn: UIButton! {
           didSet {
            tile1Btn.setTitle("", for: .normal)
           }
       }
    @IBOutlet var tile2Btn: UIButton! {
              didSet {
                 tile2Btn.setTitle("", for: .normal)

              }
          }
    @IBOutlet var tile3Btn: UIButton! {
              didSet {
                 tile3Btn.setTitle("", for: .normal)

              }
          }
    
    @IBOutlet var tile1ImgView: UIImageView! {
           didSet {
            tile1ImgView.contentMode = .scaleAspectFill
        }}
    @IBOutlet var tile2ImgView: UIImageView! {
           didSet {
            tile2ImgView.contentMode = .scaleAspectFill

        }}
    @IBOutlet var tile3ImgView: UIImageView! {
           didSet {
            tile3ImgView.contentMode = .scaleAspectFill

        }}
    
    @IBOutlet var tile1Label: UILabel! {
           didSet {
        }}
    @IBOutlet var tile2Label: UILabel! {
           didSet {
        }}
    @IBOutlet var tile3Label: UILabel! {
           didSet {
        }}
 
    
}


class groundTypeCell : UICollectionViewCell {


    @IBOutlet var innerView: UIView!{
        didSet {
            innerView.backgroundColor = .black
        }
    }
    
    @IBOutlet var ImgView: UIImageView! {
           didSet {
            ImgView.contentMode = .scaleAspectFill
        }}
   
    
    @IBOutlet var tileLabel: UILabel! {
           didSet {
        }}
  
}

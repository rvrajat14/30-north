//
//  CuratedTypeViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 10/06/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class CuratedTypeViewController: UIViewController {
    var allSectionsClosed : Bool = true
    var sectionOpened:Int = 0
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var singleOriginData:[[String:String]] = {
        let pointsperspend = ["name": "Each time you brew a 30 NORTH single-origin coffee, you’re guaranteed the purest expression of that bean's origin. Our Single Origin Series Subscription lets you explore the finest flavors from across the coffee belt, roasted by hand and delivered at your convenience"]
        return [pointsperspend]
    }()
    var seasonalBlendsData:[[String:String]] = {
        let pointsperspend = ["name": "Our master coffee roasters work hard to develop new creations blends that are sure to hit the right spot. There's always something in the pipeline and we always look forward to those tasting sessions. 30 NORTH seasonal blends promise to deliver a unique coffee experience throughout the year"]
              return [pointsperspend]
        
    }()
    
    var nowBrewingData:[[String:String]] = {
         let pointsperspend = ["name": "Our Now Brewing Series lets you enjoy the monthly recommended picks chosen by our master roasters. We profile a different coffee each month and our baristas focus on the best ways to brew it to extract the deepest expression of flavor its origin has to offer"]
              return [pointsperspend]
    }()

	var didSelect: ((_ type:String) -> Void)? = nil
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.rowHeight = 100
            tableView.layer.cornerRadius = 3.0
            tableView.clipsToBounds = true
            let nib = UINib(nibName: "CuratedTypesCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "CuratedTypesCell")
         
        }
    }

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "Subscription")
		}
	}

	@IBOutlet weak var imageView: UIImageView! {
		didSet {
			imageView.image = UIImage(named: "greyMocha")
			imageView.contentMode = .scaleAspectFit
			imageView.clipsToBounds = true
		}
	}
	@IBOutlet weak var descriptionLabel: UILabel! {
		didSet {
			descriptionLabel.text = "Tell us what you'd like to get with your subscription. We have always got something exciting brewing and you could just opt for the blend of the season"
			descriptionLabel.textColor = .white
			descriptionLabel.numberOfLines = 0
			descriptionLabel.font = UIFont(name: AppFontName.regular, size: 16)
			descriptionLabel.textAlignment = .center
		}
	}

	@IBOutlet weak var lineView: UIView! {
		didSet {
			lineView.backgroundColor = UIColor.black
			lineView.clipsToBounds = true
		}
	}
	@IBOutlet weak var leftView: UIView! {
		didSet {
			leftView.backgroundColor = UIColor.clear
		}
	}
	@IBOutlet weak var centerView: UIView!{
		didSet {
			centerView.backgroundColor = UIColor.clear
		}
	}
	@IBOutlet weak var rightView: UIView!{
		didSet {
			rightView.backgroundColor = UIColor.clear
		}
	}

	@IBOutlet weak var leftTextLabel: UILabel!{
		didSet {
			leftTextLabel.text = ""
			leftTextLabel.textColor = .white
			leftTextLabel.numberOfLines = 15
			leftTextLabel.font = UIFont(name: AppFontName.regular, size: 14)
			leftTextLabel.minimumScaleFactor = 0.5
			leftTextLabel.adjustsFontSizeToFitWidth = true
			leftTextLabel.textAlignment = .center
		}
	}
	@IBOutlet weak var centerTextLabel: UILabel!{
		didSet {
			centerTextLabel.text = ""
			centerTextLabel.textColor = .white
			centerTextLabel.numberOfLines = 15
			centerTextLabel.font = UIFont(name: AppFontName.regular, size: 14)
			centerTextLabel.minimumScaleFactor = 0.5
			centerTextLabel.adjustsFontSizeToFitWidth = true
			centerTextLabel.textAlignment = .center
		}
	}
	@IBOutlet weak var rightTextLabel: UILabel!{
		didSet {
			rightTextLabel.text = ""
			rightTextLabel.textColor = .white
			rightTextLabel.numberOfLines = 15
			rightTextLabel.font = UIFont(name: AppFontName.regular, size: 14)
			rightTextLabel.minimumScaleFactor = 0.5
			rightTextLabel.adjustsFontSizeToFitWidth = true
			rightTextLabel.textAlignment = .center
		}
	}
	@IBOutlet weak var leftButton: UIButton!{
		didSet {
			leftButton.layer.cornerRadius = 3.0
			leftButton.clipsToBounds = true
		}
	}
	@IBOutlet weak var centerButton: UIButton!{
		didSet {
			centerButton.layer.cornerRadius = 3.0
			centerButton.clipsToBounds = true
		}
	}
	@IBOutlet weak var rightButton: UIButton! {
		didSet {
			rightButton.layer.cornerRadius = 3.0
			rightButton.clipsToBounds = true
		}
	}

	@IBOutlet weak var proceedButton: UIButton! {
		didSet {
			proceedButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 20)
			proceedButton.layer.cornerRadius = 3.0
			proceedButton.clipsToBounds = true
			proceedButton.setTitle("PROCEED", for: .normal)
			proceedButton.setTitleColor(.black, for: .normal)
			proceedButton.backgroundColor = .white
		}
	}

	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		configureView()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}

	func configureView() {
		self.view.backgroundColor = UIColor.mainViewBackground
		self.centerButton.sendActions(for: .touchUpInside)
        
        //Adjusting height of table according to the size of the device screen.
        let screenBounds = UIScreen.main.bounds
                 var height:CGFloat = 200
                 if screenBounds.height <= 667 {
                     height = 225
                 } else if screenBounds.height <= 736 {
                     height = 250
                 } else if screenBounds.height <= 812 {
                     height = 300
                 } else {
                     height = 325
                 }
                 self.tableViewHeight.constant = height
	}
    
    func indexPaths(for section:Int) -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            if(section == 0)
            {
            for row in 0..<self.singleOriginData.count {
                indexPaths.append(IndexPath(row: row, section: section))
            }
            }else if(section == 1){
                for row in 0..<self.seasonalBlendsData.count {
                           indexPaths.append(IndexPath(row: row, section: section))
                       }
            }else if(section == 2){
                for row in 0..<self.nowBrewingData.count {
                           indexPaths.append(IndexPath(row: row, section: section))
                       }
            }
            return indexPaths
        }

        @objc func openSection(_ sender:UITapGestureRecognizer) {
            guard let section = sender.view?.tag else {
                return
            }
            
            var allClosedAndThenOpening : Bool = false
            
            tableView.beginUpdates()
            let oldSection = self.sectionOpened
            self.sectionOpened = (section - 1)
            
            //If uesr is tapping same section again - switch from true to false and vicer versa
            if(self.sectionOpened == oldSection){
                if(allSectionsClosed == true){
                    allSectionsClosed = false
                }else{
                    allSectionsClosed = true
                }
            }else{
                
                if(allSectionsClosed == true){
                    allClosedAndThenOpening = true  // Important to know this, since we do not want to delete rows if all sections were closed.
                }
                allSectionsClosed = false
            }
            
            if(self.sectionOpened == oldSection && allSectionsClosed == true){
                self.tableView.deleteRows(at: indexPaths(for: oldSection), with: .none)
            }
            
            if(allSectionsClosed == false){
                
            }
            
            
            if(self.sectionOpened != oldSection && allClosedAndThenOpening == false){
                self.tableView.deleteRows(at: indexPaths(for: oldSection), with: .none)
            }
            
            
    //        if (oldSection != -1 && (self.sectionOpened != oldSection) && allSectionsClosed == false) {
    //            self.tableView.deleteRows(at: indexPaths(for: oldSection), with: .none)
    //        }
            
            if(self.sectionOpened != oldSection){
                self.tableView.insertRows(at: indexPaths(for: sectionOpened), with: .none)
            }
            
            if(self.sectionOpened == oldSection && allSectionsClosed == false){
                self.tableView.insertRows(at: indexPaths(for: sectionOpened), with: .none)
            }
            
            tableView.endUpdates()
        }

	@IBAction func leftButtonAction(_ sender: UIButton) {
		sender.isEnabled = false
		centerButton.isEnabled = true
		rightButton.isEnabled = true
	}
	@IBAction func centerButtonAction(_ sender: UIButton) {
		sender.isEnabled = false
		leftButton.isEnabled = true
		rightButton.isEnabled = true
	}
	@IBAction func rightButtonAction(_ sender: UIButton) {
		sender.isEnabled = false
		centerButton.isEnabled = true
		leftButton.isEnabled = true
	}

	@IBAction func proceedAction(_ sender: UIButton) {
		if let handler = self.didSelect {
			var type = ""
			if self.leftButton.isEnabled == false {
				type = "Single Origins"
			} else if self.centerButton.isEnabled == false {
				type = "Seasonal Blends"
			} else if self.rightButton.isEnabled == false {
				type = "Now Brewing"
			}
			handler(type)
		}
	}
}
extension CuratedTypeViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
      
        
        if self.sectionOpened == section {
            
            if(section == 0){
                if(allSectionsClosed == true){
                          return 0
                }else{
                    return self.singleOriginData.count
                }
                
            }else if(section == 1){
                if(allSectionsClosed == true){
                    return 0
                }else{
                return self.seasonalBlendsData.count
                }
            }else{
                if(allSectionsClosed == true){
                                    return 0
                              }else{
                return self.nowBrewingData.count
                }
            }
            
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerViewParent = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 55))

        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        headerView.layer.cornerRadius = 3.0
        headerView.clipsToBounds = true

        let imgView = UIImageView()
        imgView.frame = CGRect.init(x: 10, y: 10, width: 30, height: 30)
        imgView.image = UIImage.init(named: "filter")
        headerView.addSubview(imgView)

        
        let label = UILabel()
        label.frame = CGRect.init(x: 50, y: 14, width: 280, height: 30)
        label.font = UIFont(name: AppFontName.nexaBlack, size: 18)
        label.textColor = UIColor.black

        if section == 0 {
            label.text = "SINGLE ORIGIN SERIES"
            //headerView.backgroundColor = UIColor.bronze
        } else if section == 1 {
            label.text = "SEASONAL BLENDS SERIES"
            //headerView.backgroundColor = UIColor.silver
        }else {
            label.text = "NOW BREWING SERIES"
            //headerView.backgroundColor = UIColor.gold
        }
        
        headerView.backgroundColor = UIColor.north30Grey


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openSection(_:)))
        headerView.addGestureRecognizer(tapGesture)
        headerView.tag = section + 1

        headerView.addSubview(label)
        
        headerViewParent.addSubview(headerView)
        
        return headerViewParent
        //return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CuratedTypesCell", for: indexPath) as? CuratedTypesCell

        
        var data : [String:String]
        if(indexPath.section == 0){
            data = self.singleOriginData[indexPath.row]
        }else if(indexPath.section == 1){
            data = self.seasonalBlendsData[indexPath.row]
        }else{
            data = self.nowBrewingData[indexPath.row]
        }

        cell?.titleLabel.text = data["name"]
        cell?.backgroundColor = .white
        cell?.selectionStyle = .none

        return cell!
    }
}

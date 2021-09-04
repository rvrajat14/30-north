//
//  RewardTierViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 12/06/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class RewardTierViewController: UIViewController {
    
    var allSectionsClosed : Bool = false
    
	var bronzeTiers:[[String:String]] = {
        let pointsperspend = ["name": "Points for every LE spent","bronze":"2 pts","silver":"0","gold":"0"]
        let signup = ["name": "Sign up Reward","bronze":"0","silver":"0","gold":"0"]
		let birthday = ["name": "Birthday Reward","bronze":"0","silver":"0","gold":"0"]
		let drink = ["name": "Customize your drink","bronze":"200 pts","silver":"0","gold":"0"]
		let upsize = ["name": "Upsize your coffee","bronze":"200 pts","silver":"0","gold":"0"]
		let coffee = ["name": "Free Coffee","bronze":"500 pts","silver":"0","gold":"0"]
		let getOne = ["name": "Buy one get one free","bronze":"700 pts","silver":"0","gold":"0"]
		let freeDessert = ["name": "Free dessert with next coffee","bronze":"1000 pts","silver":"0","gold":"0"]

		return [pointsperspend, signup, birthday, drink, upsize, coffee, getOne, freeDessert]
	}()
    var silverTiers:[[String:String]] = {
        let qualification = ["name": "Points to qualify","bronze":"0","silver":"4000 pts","gold":"0"]
        let pointsperspend = ["name": "Points for every LE spent","bronze":"0","silver":"2.5 pts","gold":"0"]
        let pointstokeep = ["name": "Points to stay at Silver","bronze":"0","silver":"500 pts/year","gold":"0"]
        let extrarewards = ["name": "Earn 4 pts per LE spent once a week","bronze":"0","silver":"0","gold":"0"]
        let signup = ["name": "Sign up Reward","bronze":"0","silver":"0","gold":"0"]
        let birthday = ["name": "Birthday Reward","bronze":"0","silver":"0","gold":"0"]
        let drink = ["name": "Customize your drink","bronze":"0","silver":"200 pts","gold":"0"]
        let upsize = ["name": "Upsize your coffee","bronze":"0","silver":"200 pts","gold":"0"]
        let coffee = ["name": "Free Coffee","bronze":"0","silver":"500 pts","gold":"0"]
        let getOne = ["name": "Buy one get one free","bronze":"0","silver":"700 pts","gold":"0"]
        let freeDessert = ["name": "Free dessert with next coffee","bronze":"0","silver":"1000 pts","gold":"0"]
        let signatureBlend = ["name": "250 gm bag of signature blend","bronze":"0","silver":"0","gold":"0"]
        let mochaPot = ["name": "Mocha Pot","bronze":"0","silver":"1200 pts","gold":"0"]
        let breakfast25 = ["name": "25% off breakfast","bronze":"0","silver":"2000 pts","gold":"0"]
        let breakfast50 = ["name": "50% off breakfast","bronze":"0","silver":"3000 pts","gold":"0"]
        return [qualification, pointstokeep, extrarewards, pointsperspend, signup, birthday, drink, upsize, coffee, getOne, freeDessert, signatureBlend, mochaPot, breakfast25, breakfast50]
        
    }()
    
    var goldenTiers:[[String:String]] = {
       
        let qualification = ["name": "Points to qualify","bronze":"0","silver":"0","gold":"6000 pts"]
        let pointsperspend = ["name": "Points for every LE spent","bronze":"0","silver":"0","gold":"4 pts"]
        let pointstokeep = ["name": "Points to stay at Gold","bronze":"0","silver":"0","gold":"1000 pts / year"]
        let extrarewards = ["name": "Earn 6 pts per LE spent twice a week","bronze":"0","silver":"0","gold":"0"]
        let signup = ["name": "Sign up Reward","bronze":"0","silver":"0","gold":"0"]
        let birthday = ["name": "Birthday Reward","bronze":"0","silver":"0","gold":"0"]
        let drink = ["name": "Customize your drink","bronze":"0","silver":"0","gold":"200 pts"]
        let upsize = ["name": "Upsize your coffee","bronze":"0","silver":"0","gold":"200 pts"]
        let coffee = ["name": "Free Coffee","bronze":"0","silver":"0","gold":"500 pts"]
        let getOne = ["name": "Buy one get one free","bronze":"0","silver":"0","gold":"700 pts"]
        let freeDessert = ["name": "Free dessert with next coffee","bronze":"0","silver":"0","gold":"1000 pts"]
        let signatureBlend = ["name": "250 gm bag of signature blend","bronze":"0","silver":"0","gold":"1000 points"]
        let mochaPot = ["name": "Mocha Pot","bronze":"0","silver":"0","gold":"1200 pts"]
        let breakfast25 = ["name": "25% off breakfast","bronze":"0","silver":"0","gold":"2000 pts"]
        let breakfast50 = ["name": "50% off breakfast","bronze":"0","silver":"0","gold":"3000 pts"]
        let freebreakfast = ["name": "Free Breakfast","bronze":"0","silver":"0","gold":"4000 pts"]
        let freebreakfast2 = ["name": "Free Breakfast for 2","bronze":"0","silver":"0","gold":"6000 pts"]
        return [pointsperspend, pointstokeep, extrarewards, qualification, signup, birthday, drink, upsize, coffee, getOne, freeDessert, signatureBlend, mochaPot, breakfast25, breakfast50]
    }()
    
    
    
    
	var sectionOpened:Int = 0

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "Reward Tiers")
		}
	}

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self

			tableView.backgroundColor = .clear
			tableView.separatorStyle = .none
			tableView.rowHeight = 50
			tableView.layer.cornerRadius = 3.0
			tableView.clipsToBounds = true
			let nib = UINib(nibName: "RewardTierCell", bundle: nil)
			tableView.register(nib, forCellReuseIdentifier: "RewardTierCell")
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
		self.navigationItem.leftBarButtonItem = closeBarButtonItem()
	}

	func configureView() {
		self.view.backgroundColor = UIColor.mainViewBackground
	}

	func indexPaths(for section:Int) -> [IndexPath] {
		var indexPaths = [IndexPath]()
        
        if(section == 0)
        {
        for row in 0..<self.bronzeTiers.count {
            indexPaths.append(IndexPath(row: row, section: section))
        }
        }else if(section == 1){
            for row in 0..<self.silverTiers.count {
                       indexPaths.append(IndexPath(row: row, section: section))
                   }
        }else if(section == 2){
            for row in 0..<self.goldenTiers.count {
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
        
        
//		if (oldSection != -1 && (self.sectionOpened != oldSection) && allSectionsClosed == false) {
//			self.tableView.deleteRows(at: indexPaths(for: oldSection), with: .none)
//		}
        
        if(self.sectionOpened != oldSection){
            self.tableView.insertRows(at: indexPaths(for: sectionOpened), with: .none)
        }
        
        if(self.sectionOpened == oldSection && allSectionsClosed == false){
            self.tableView.insertRows(at: indexPaths(for: sectionOpened), with: .none)
        }
        
        
		tableView.endUpdates()
	}

	func closeBarButtonItem() -> UIBarButtonItem {
		// Create the info button
		let closeButton = UIButton(type: .custom)
		closeButton.setImage(UIImage(named: "close-gray"), for: .normal)
		closeButton.frame = CGRect(x: 20, y: 8, width: 30, height: 30)
		closeButton.backgroundColor = .clear
		// You will need to configure the target action for the button itself, not the bar button itemr
		closeButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
		// Create a bar button item using the info button as its custom view
		let infoBarButtonItem = UIBarButtonItem(customView: closeButton)
		return infoBarButtonItem
	}

	@objc func dismiss(_ sender:UIButton) {
		self.dismiss(animated: true) {
			print("Dismissed")
		}
	}

}


extension RewardTierViewController : UITableViewDelegate, UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
      
        
		if self.sectionOpened == section {
            
            if(section == 0){
                if(allSectionsClosed == true){
                          return 0
                }else{
                    return self.bronzeTiers.count
                }
                
            }else if(section == 1){
                if(allSectionsClosed == true){
                    return 0
                }else{
                return self.silverTiers.count
                }
            }else{
                if(allSectionsClosed == true){
                                    return 0
                              }else{
                return self.goldenTiers.count
                }
            }
            
		} else {
			return 0
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerViewParent = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))

        
		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        headerView.layer.cornerRadius = 3.0
        headerView.clipsToBounds = true

        let imgView = UIImageView()
        imgView.frame = CGRect.init(x: 10, y: 10, width: 30, height: 30)
        imgView.image = UIImage.init(named: "emptyCup")
        headerView.addSubview(imgView)

        
        
        
        let label = UILabel()
		label.frame = CGRect.init(x: 50, y: 14, width: 200, height: 30)
		label.font = UIFont(name: AppFontName.nexaBlack, size: 18)
        label.textColor = UIColor.black

		if section == 0 {
			label.text = "BRONZE"
			headerView.backgroundColor = UIColor.bronze
		} else if section == 1 {
			label.text = "SILVER"
			headerView.backgroundColor = UIColor.silver
		}else {
			label.text = "GOLD"
			headerView.backgroundColor = UIColor.gold
		}

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openSection(_:)))
		headerView.addGestureRecognizer(tapGesture)
		headerView.tag = section + 1

        headerView.addSubview(label)
        
        headerViewParent.addSubview(headerView)
        
        return headerViewParent
        //return headerView
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "RewardTierCell", for: indexPath) as? RewardTierCell

        
        var data : [String:String]
        if(indexPath.section == 0){
            data = self.bronzeTiers[indexPath.row]
        }else if(indexPath.section == 1){
            data = self.silverTiers[indexPath.row]
        }else{
            data = self.goldenTiers[indexPath.row]
        }
        
		

		var key = ""
		if indexPath.section == 0 {
			key = "bronze"
		} else if indexPath.section == 1 {
			key = "silver"
		} else if indexPath.section == 2 {
			key = "gold"
		}

		cell?.titleLabel.text = data["name"]

		cell?.detailLabel.text = nil
		cell?.detailLabel.isHidden = true
		cell?.cellImageView.isHidden = true

		if data[key] == "1" {
			cell?.cellImageView.isHidden = false
			cell?.cellImageView.image = UIImage(named: "1")
		} else if data[key] == "0" {
			cell?.cellImageView.isHidden = false
			cell?.cellImageView.image = UIImage(named: "")
		} else {
			cell?.detailLabel.isHidden = false
			cell?.detailLabel.text = data[key]
		}

		cell?.backgroundColor = .white
		cell?.selectionStyle = .none

		return cell!
	}
}

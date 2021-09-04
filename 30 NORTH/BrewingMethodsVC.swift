//
//  BrewingMethodsVC.swift
//  30 NORTH
//
//  Created by SOWJI on 24/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit

class BrewingMethodsVC: BaseViewController {
	var hasAlreadyLaunched : Bool = UserDefaults.standard.bool(forKey: "hasAlreadyLaunchedBrewingMethods")

    @IBOutlet weak var leftGapBetweenTiles: NSLayoutConstraint!
    @IBOutlet weak var rightGapBetweenTiles: NSLayoutConstraint!

    
	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "Brewing Techniques")
		}
	}

	@IBOutlet weak var brewTable: UITableView! {
		didSet {
			brewTable.backgroundColor = UIColor.clear
		}
	}

    @IBOutlet weak var menuButton: UIBarButtonItem!

    let titlesData = ["AERO PRESS","CHEMEX","COLD BREW","FRENCH PRESS","NITRO","POUR OVER","SYPHON","V60","VIETNAMESE","MOCHA POT","TURKISH","CLEVER"]
    let imagesData = ["aeropress","chemex","cold_brew","french_press","Nitro","pour_over","syphon","v60","vietnamese","mocha_pot","turkish","clever"]

    let aeropressIngredients = ["Ground Coffee", "Hot Water", "AeroPress", "Paper filter", "Cup", "Kitchen scale", "Spoon", "Kettle"]
    let chemexIngredients = ["Ground Coffee", "Hot Water", "Chemex Brewer", "Chemex filter", "Cup", "Kitchen scale", "Spoon", "Kettle"]
    let cold_brewIngredients = ["Coarsely ground coffee", "Cold Water", "Jar with lid", "Paper filter", "Cup or a large server", "Kitchen scale", "Spoon", "Fridge"]
    let french_pressIngredients = ["Coarsely ground coffee", "Hot Water", "French Press", "Cup or a large server", "Kitchen scale", "Spoon", "Kettle"]
    let nitroIngredients = ["Coarsely ground coffee", "Cold Water", "Nitro shaker", "N20 Cartridge", "Jar with lid", "Paper filter", "Cup or a large server", "Kitchen scale", "Spoon", "Fridge"]
    let pour_overIngredients = ["Ground Coffee", "Hot Water", "Pour Over brewer", "Paper filter", "Cup", "Kitchen scale", "Spoon", "Kettle"]
    let syphonIngredients = ["Ground Coffee", "Hot Water", "Siphon", "Burner / Heat source", "Cup", "Kitchen scale", "Spoon", "Kettle"]
    let v60Ingredients = ["Ground Coffee", "Hot Water", "V60 Brewer", "V60 Filter", "Cup", "Kitchen scale", "Spoon", "Kettle"]
    let vietnameseIngredients = ["Ground Coffee", "Hot Water", "Vietnamese Brewer", "Sweetened Condensed Milk", "Kitchen scale", "Spoon", "Kettle"]
    let mocha_potIngredients = ["Ground Coffee", "Hot Water", "Mocha Pot", "Cup", "Kitchen scale", "Spoon", "Kettle"]
    let turkishIngredients = ["Finely Ground Coffee", "Cold Water", "Kanaka / Ibrik", "Demitasse Cup", "Cardamom (Optional)", "Sugar (Optional)", "Spoon"]
    let cleverIngredients = ["Ground Coffee", "Hot Water", "Clever Brewer", "Paper Filter", "Cup", "Kitchen scale", "Spoon", "Kettle"]


    lazy var ingredientsData:[[String]] = {
        return [self.aeropressIngredients, self.chemexIngredients, self.cold_brewIngredients, self.french_pressIngredients, self.nitroIngredients, self.pour_overIngredients, self.syphonIngredients, self.v60Ingredients, self.vietnameseIngredients, self.mocha_potIngredients, self.turkishIngredients, self.cleverIngredients]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.black
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.rightBarButtonItem = infoBarButtonItem()
		if (self.hasAlreadyLaunched != true) {
			self.openOverlay()
		}
	}

    override func didReceiveMemoryWarning() { 
        super.didReceiveMemoryWarning()
    }

	func infoBarButtonItem() -> UIBarButtonItem {
		// Create the info button
		let infoButton = UIButton(type: .infoLight)
		// You will need to configure the target action for the button itself, not the bar button itemr
		infoButton.addTarget(self, action: #selector(openOverlay), for: .touchUpInside)
		// Create a bar button item using the info button as its custom view
		let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
		return infoBarButtonItem
	}

	func overlayData() -> NSDictionary {
		let data1 = ["image":"1", "title":"INGREDIENTS", "detail":"Our handy ingredient guide gives you a list of everything you'll need to brew that perfect cup of coffee before you get started. Have everything on hand and get right into it", "note": ""]
		let data2 = ["image":"1", "title":"BEST PRACTICE", "detail":"Each guide has a converter which tells you how much water you'll need based on the amount of coffee you're brewing. Timers with notification alerts will let you know when each step is complete", "note": ""]
		let data3 = ["image":"1", "title":"YOUR FEEDBACK", "detail":"We're always ready to listen. If you've developed your own recipe for making a great cup of coffee let us know using the Get In Touch form and we'll surely consider adding it", "note": ""]

		let data:[String : Any] = ["title":"BREWING TECHNIQUES OVERVIEW", "description":"These step by step guides will walk you through tried and tested techniques for brewing your perfect cup of coffee. French Press? Chemex? You'll find your favorite brewing method in our guide", "data":[data1, data2, data3]]

		return data as NSDictionary
	}

	@objc func openOverlay() {
		let overlayVC = OverlayViewController(nibName: "OverlayViewController", bundle: nil)
		overlayVC.modalPresentationStyle = .fullScreen
		self.present(overlayVC, animated: true) {

			self.hasAlreadyLaunched = true
			UserDefaults.standard.set(true, forKey: "hasAlreadyLaunchedBrewingMethods")

			overlayVC.data = self.overlayData()
		}
	}



    @objc func brewMetohdClicked(_ sender : UIButton) {
		let ingredient = self.ingredientsData[sender.tag]
		if ingredient == [""] {
			self.performSegue(withIdentifier: "segueBrewingPages", sender: sender.tag)
		} else {
			let biVC = BrewingIngredientsViewController(nibName: "BrewingIngredientsViewController", bundle: nil)
			biVC.method = self.titlesData[sender.tag]
			biVC.methodIndex = sender.tag
			biVC.ingredients = ingredient
			self.navigationController?.pushViewController(biVC, animated: true)
		}
	}
}

extension BrewingMethodsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.titlesData.count%3 == 0) {
            return self.titlesData.count/3
        } else {
            return self.titlesData.count/3 + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView()
        let cell = tableView.dequeueReusableCell(withIdentifier: "brewCell", for: indexPath) as! brewCell
        
        cell.selectionStyle = .none
        
        if((indexPath.row*3 + 1) <= titlesData.count){
            cell.tile1ImgView.image = UIImage(named: self.imagesData[indexPath.row*3])
            cell.tile1Label.text = self.titlesData[indexPath.row*3]
            cell.tile1Btn.addTarget(self, action: #selector(self.brewMetohdClicked(_:)), for: UIControl.Event.touchUpInside)
            cell.tile1Btn.tag = indexPath.row*3


        }else{
            cell.tile1ImgView.isHidden = true
            cell.tile1Label.isHidden = true
            cell.tile1Btn.isHidden = true

        }
        if((indexPath.row*3 + 2) <= titlesData.count){
        cell.tile2ImgView.image = UIImage(named: self.imagesData[indexPath.row*3 + 1])
            cell.tile2Label.text = self.titlesData[indexPath.row*3 + 1]
            cell.tile2Btn.addTarget(self, action: #selector(self.brewMetohdClicked(_:)), for: UIControl.Event.touchUpInside)
            cell.tile2Btn.tag = indexPath.row*3 + 1

        }else{
            cell.tile2ImgView.isHidden = true
            cell.tile2Label.isHidden = true
            cell.tile2Btn.isHidden = true

            
        }
        
        if((indexPath.row*3 + 3) <= titlesData.count){
            cell.tile3ImgView.image = UIImage(named: self.imagesData[indexPath.row*3 + 2])
            cell.tile3Label.text = self.titlesData[indexPath.row*3 + 2]
            cell.tile3Btn.addTarget(self, action: #selector(self.brewMetohdClicked(_:)), for: UIControl.Event.touchUpInside)
            cell.tile3Btn.tag = indexPath.row*3 + 2

        }else{
            cell.tile3ImgView.isHidden = true
            cell.tile3Label.isHidden = true
            cell.tile3Btn.isHidden = true
        }
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "segueBrewingPages", sender: indexPath.row)
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueBrewingPages" {
            let vc = segue.destination as! BrewingPagesVC
            vc.methodIndex = sender as! Int
            vc.navigationItem.title = self.titlesData[sender as! Int]
        }
    }
}

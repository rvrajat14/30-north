//
//  SubscriptionTypesViewController.swift
//  30 NORTH
//
//  Created by AnilKumar on 17/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//
import UIKit
import SwiftUI
import Alamofire


class SubscriptionTypesViewController: UIViewController {
	var hasAlreadyLaunched : Bool = UserDefaults.standard.bool(forKey: "hasAlreadyLaunchedSubscription")
	var notifObservers = [NSObjectProtocol]()
    var controller: SnackWizardController?
	let mappingsArray:[String] = ["Nutty/Chocolate:Cocoa:589,593", "Nutty/Chocolate: :582", "Nutty/Chocolate:Hazelnut:591" ,"Nutty/Chocolate:Chocolate:592,595,596", "Nutty/Chocolate:Almond:594", "Nutty/Chocolate:Honey:608", "Spicy/Complex:Cinnamon:597", "Spicy/Complex:Pepper:598", "Spicy/Complex:Vanilla:607", "Fruity/Floral:Orange:599", "Fruity/Floral:Apricot:600" ,"Fruity/Floral:Berries:601,604", "Fruity/Floral:Apple:602", "Fruity/Floral: :603", "Fruity/Floral:Pomegranate:605", "Fruity/Floral:Floral:612", "Bright/Citrus/Sweet:Lemon/Lime:590", "Bright/Citrus/Sweet:Brown Sugar:606", "Roasted:Burnt:609", "Roasted:Pipe Tobacco:610", "Herbal/Earthy:Fresh:611"]
    var selectedItems : [Dictionary<String,Any>] = []
	var subscriptionType = ""
	var firstLevel = "-"
	var secondLevel = "-"

	@IBOutlet weak var subHeaderText: UILabel!
    @IBOutlet weak var afficionadoBtn: UIButton!
    @IBOutlet weak var afficionadoLabel: UILabel!
    @IBOutlet weak var explorerLabel: UILabel!
    @IBOutlet weak var explorerBtn: UIButton!

	@IBOutlet weak var curatedBtn: UIButton!
    @IBOutlet weak var curatedLabel: UILabel!

    @IBAction func afficionadoAction(_ sender: Any) {
		self.showCoffeeFinder(withAnimation: true)
		self.subscriptionType = "1"
    }

    @IBAction func explorerAction(_ sender: Any) {
		self.showCoffeeFinder(withAnimation: true)
		self.subscriptionType = "2"
	}

	@IBAction func curatedAction(_ sender: Any) {
		let curatedVC = CuratedTypeViewController(nibName: "CuratedTypeViewController", bundle: nil)
		self.navigationController?.pushViewController(curatedVC, animated: true)
		curatedVC.didSelect = { [unowned self] (type:String) in
			print("CURATED: \(type)")
			self.subscriptionType = "3"
			self.showSubscriptionCoffeeFinderQuestion(curatedType:type)
        }
//		self.subscriptionType = "3"
//		self.showSubscriptionCoffeeFinderQuestion()
	}

    override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.firstLevel = "-"
        self.secondLevel = "-"
        self.selectedItems.removeAll()

		self.removeWheelObserbers()
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.rightBarButtonItem = infoBarButtonItem()
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
		if (self.hasAlreadyLaunched != true) {
			self.openOverlay()
		}
		self.fetchCoffeeMapping()
    }

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
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
		let data1 = ["image":"1", "title":"CHOOSE", "detail":"Let us help you discover something new with our Curated Subscriptions or build your own with our Noob and Aficionado Subscriptions", "note": ""]
		let data2 = ["image":"1", "title":"CUSTOMIZE", "detail":"Tell us how much you need, how often you need it and how you'd like it to be ground and we'll take care of everything", "note": ""]
		let data3 = ["image":"1", "title":"ENJOY", "detail":"Experience the freshest roasted\ncoffee delivered to your doorstep.\nFeel free to cancel anytime.", "note": ""]

		let data:[String : Any] = ["title":"SUBSCRIPTIONS", "description":"Our range of subscriptions caters to every need. Whether you're a coffee pro or just getting started and need help to unleash your inner barista, we'll keep you supplied at the comfort of your home", "data":[data1, data2, data3]]

		return data as NSDictionary
	}

	@objc func openOverlay() {
		let overlayVC = OverlayViewController(nibName: "OverlayViewController", bundle: nil)
		overlayVC.modalPresentationStyle = .fullScreen
		self.present(overlayVC, animated: true) {

			self.hasAlreadyLaunched = true
			UserDefaults.standard.set(true, forKey: "hasAlreadyLaunchedSubscription")

			overlayVC.data = self.overlayData()
		}
	}

	func fetchCoffeeMapping() {
		//_ = EZLoadingActivity.show("Loading...", disableUI: true)
		_ = Alamofire.request(APIRouters.GetCoffeeFinderCases).responseJSON { response in
				//_ = EZLoadingActivity.hide()
                switch response.result {
                 case .success(let data):
                     // First make sure you got back a dictionary if that's what you expect
                     guard let json = data as? [String : AnyObject] else {
                        print("Failed to get expected response from webserver.")
                        return
                     }

                     //Let's handle duplicate case first. This happens when we try to get order id again for same merchant order id
                     if json["status"] as? String == "success", let data = json["data"] as? [String] {
                        CoffeeCases = data
                    }
                case .failure(_): break
                }
		}
	}

	func setupWheelObserbers() {
		self.removeWheelObserbers()

		let goNotification = NSNotification.Name("clickedShowMatchesButton")
        let goObserver = NotificationCenter.default.addObserver(forName: goNotification, object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
			self.openCoffeeRecommendation(items: self.selectedItems, type: self.subscriptionType)
        }
		notifObservers.append(goObserver)

		let resetNotification = NSNotification.Name("clickedResetButton")
        let resetObserver = NotificationCenter.default.addObserver(forName: resetNotification, object: nil, queue: OperationQueue.main) { [unowned self] (notification) in

			self.selectedItems = []
			self.firstLevel = "-"
			self.secondLevel = "-"

            self.navigationController?.popViewController(animated: false)
            self.showCoffeeFinder(withAnimation: false)
        }
		notifObservers.append(resetObserver)

		let questionNotification = NSNotification.Name("clickedQuestionButton")
        let questionObserver = NotificationCenter.default.addObserver(forName: questionNotification, object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
			self.showSubscriptionCoffeeFinderQuestion()
        }
		notifObservers.append(questionObserver)
	}

	func removeWheelObserbers() {
		for observer in notifObservers {
			NotificationCenter.default.removeObserver(observer)
		}
		notifObservers.removeAll()
	}

	func showSubscriptionCoffeeFinderQuestion(curatedType:String = "") {
		controller = SnackWizardController(navigationController: navigationController!)
		controller?.startSubscriptionWizard(type: self.subscriptionType, completion: { (options, text) in
			/*var selectedItems:[[String:Any]] = []

			for coffeeId in coffeeIDs {
			   let Dict = ["level1": text, "level2":"","level3":"","item_id":Int(coffeeId) as Any]
			   selectedItems.append(Dict)
			}
			self.openCoffeeRecommendation(items: selectedItems, type:self.subscriptionType)*/

			var final = "\(self.firstLevel):\(self.secondLevel):\(options)"
			if curatedType != "" {
				final = "\(curatedType):\(self.firstLevel):\(self.secondLevel):\(options)"
				/*CoffeeCases.append("1:-:-:V60:-:-:687")
				CoffeeCases.append("2:-:-:V60:-:-:687")
				CoffeeCases.append("3:-:-:V60:-:-:687")*/
			}

			let coffeeObject = CoffeeCases.filter { (option) -> Bool in
				let optionComponents = option.components(separatedBy: ":")
                let optionWithoutIDs = optionComponents.dropLast().joined(separator: ":")
                let arrayFinal = final.components(separatedBy: ":")
                let strFinal = arrayFinal.last
                let arraySecond = optionWithoutIDs.components(separatedBy: ":")
                let strCompare = arraySecond.last
                return strFinal == strCompare
			}
			print("Final: \(final)")
			print("Option Mapped: \(coffeeObject)")

			guard coffeeObject.count > 0 else {
				_ = SweetAlert().showAlert("Sorry", subTitle: "No matching coffee found!", style: .customImag(imageFile: "Logo"))
				return
			}

			var selectedItems = [[String : Any]]()
			for object in coffeeObject {
				if let coffeeIds = object.components(separatedBy: ":").last {
					let allIds = coffeeIds.components(separatedBy: ",")
					for coffeeId in allIds {
						let dict = ["level1": text, "level2":"","level3":"","item_id":Int(coffeeId) as Any]
						selectedItems.append(dict)
					}
				}
			}
			self.openCoffeeRecommendation(items: selectedItems, type:self.subscriptionType)
		})
	}

	func openCoffeeRecommendation(items:[[String:Any]], type:String) {
		if items.count == 0 {
			return
		}
        let coffeeRecommendationVC = self.storyboard?.instantiateViewController(identifier: "CoffeeRecommendationViewController") as? CoffeeRecommendationViewController
        coffeeRecommendationVC?.selectedItems = items
		coffeeRecommendationVC?.subscriptionType = type
        self.navigationController?.pushViewController(coffeeRecommendationVC!, animated: true)
    }
}

extension SubscriptionTypesViewController {

    func showCoffeeFinder(withAnimation : Bool) {
		//let configuration = SunburstConfiguration(nodes: self.coffeeNodes(), calculationMode: .ordinalFromLeaves)
        let configuration = SunburstConfiguration(nodes: self.coffeeNodes(), calculationMode: .ordinalFromRoot)
      	let thickness:CGFloat = 120.0
		let screenBounds = UIScreen.main.bounds
		let innerRadius = ((screenBounds.width-16)/2) - thickness

        configuration.innerRadius = innerRadius
        configuration.expandedArcThickness = thickness
        configuration.maximumExpandedRingsShownCount = 1
        configuration.maximumRingsShownCount = 1
        configuration.minimumArcAngleShown = .group(ifLessThan: 100.0)
		let viewController = UIHostingController(rootView: RootView(configuration: configuration))
        viewController.view.backgroundColor = UIColor.mainViewBackground
        //viewController.navigationController!.navigationBar.topItem?.titleView = setNavbarImage()

        if(withAnimation == false){
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            transition.type = CATransitionType.fade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(viewController, animated: withAnimation)
        }else{
            self.navigationController?.pushViewController(viewController, animated: withAnimation)
        }
		self.setupWheelObserbers()

		let nodeChnageNotification = NSNotification.Name("didChangeNode")
		NotificationCenter.default.removeObserver(self, name: nodeChnageNotification, object: nil)
		NotificationCenter.default.addObserver(forName: nodeChnageNotification, object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
			if let selectedNode = notification.userInfo?["SelectedNode"] as? Node {

				if let focusedNode = notification.userInfo?["FocusedNode"] as? Node {
					self.firstLevel = focusedNode.name
				}
				self.secondLevel = selectedNode.name
				if(self.secondLevel == self.firstLevel){
					self.secondLevel = "-"
                }
                //Let's Get API IDs
                self.selectedItems.removeAll()
                for item in self.mappingsArray {
                    let brokenArray = item.components(separatedBy: ":")
					if(brokenArray[1] == self.secondLevel && self.firstLevel != self.secondLevel) {
                        let allIds = brokenArray[2].components(separatedBy: ",")
                        for coffeeId in allIds {
                            let Dict = ["level1": self.secondLevel, "level2":"","level3":"","item_id":Int(coffeeId) as Any]
                            self.selectedItems.append(Dict)
                        }
                    } else if(brokenArray[0] == self.firstLevel && self.secondLevel == "-") {
						let allIds = brokenArray[2].components(separatedBy: ",")
						for coffeeId in allIds {
						   let Dict = ["level1": self.firstLevel, "level2":"","level3":"","item_id":Int(coffeeId) as Any]
						   self.selectedItems.append(Dict)
						}
                    }
                }
			} else {
				print("No Node Selected")
			}
		}
	}

	func coffeeNodes() -> [Node] {
		let nodes = [
            Node(name: "Nutty/Chocolate", showName: true, image: UIImage(named: "nutty_60") , value: 11.11, backgroundColor: UIColor.wheelNuttyChocolate, children: [Node(name: "Cocoa", showName: true, image: UIImage(named: "cocoa_60") , value: 11.11, backgroundColor: UIColor.wheelCocoa), Node(name: "Hazelnut", showName: true, image: UIImage(named: "hazelnut_60")  , value: 11.11, backgroundColor: UIColor.wheelHazelnut), Node(name: "Chocolate", showName: true, image: UIImage(named: "chocolate_60") , value: 11.11, backgroundColor: UIColor.wheelChocolate), Node(name: "Almond", showName: true, image: UIImage(named: "almond_60") , value: 11.11, backgroundColor: UIColor.wheelAlmond), Node(name: "Honey", showName: true, image: UIImage(named: "honey_60") , value: 11.11, backgroundColor: UIColor.wheelHoney)]),

            Node(name: "Spicy/Complex", showName: true, image: UIImage(named: "spicy_60") , value: 11.11, backgroundColor: UIColor.wheelSpicyComplex, children: [Node(name: "Cinnamon", showName: true, image: UIImage(named: "cinnamon_60") , value: 11.11, backgroundColor: UIColor.wheelCinnamon), Node(name: "Pepper", showName: true, image: UIImage(named: "pepper_60") , value: 11.11, backgroundColor: UIColor.wheelPepper), Node(name: "Vanilla", showName: true, image: UIImage(named: "vanilla_60") , value: 11.11, backgroundColor: UIColor.wheelVanilla)]),

            Node(name: "Fruity/Floral", showName: true, image: UIImage(named: "fruity_60") , value: 11.11, backgroundColor: UIColor.wheelFruityFloral, children: [Node(name: "Orange", showName: true, image: UIImage(named: "orange_60") , value: 11.11, backgroundColor: UIColor.wheelOrange), Node(name: "Apricot", showName: true, image: UIImage(named: "apricot_60") , value: 11.11, backgroundColor: UIColor.wheelApricot), Node(name: "Berries", showName: true, image: UIImage(named: "berries_60") , value: 11.11, backgroundColor: UIColor.wheelBerries), Node(name: "Apple", showName: true, image: UIImage(named: "apple_60") , value: 11.11, backgroundColor: UIColor.wheelApple),  Node(name: "Pomegranate", showName: true, image: UIImage(named: "Pomegranate_60") , value: 11.11, backgroundColor: UIColor.wheelPomegranate),  Node(name: "Floral", showName: true, image: UIImage(named: "flower_60") , value: 11.11, backgroundColor: UIColor.wheelFloral)]),

            Node(name: "Bright/Citrus/Sweet", showName: true, image: UIImage(named: "citrus_60") , value: 11.11, backgroundColor: UIColor.wheelBrightCitrusSweet, children: [Node(name: "Lemon/Lime", showName: true, image: UIImage(named: "lemon_60") , value: 11.11, backgroundColor: UIColor.wheelLime), Node(name: "Brown Sugar", showName: true, image: UIImage(named: "sugar_60") , value: 11.11, backgroundColor: UIColor.wheelBrownSugar)]),

            Node(name: "Roasted", showName: true, image: UIImage(named: "floral_60") , value: 11.11, backgroundColor: UIColor.wheelRoasted, children: [Node(name: "Burnt", showName: true, image: UIImage(named: "burnt_60") , value: 11.11, backgroundColor: UIColor.wheelBurnt), Node(name: "Pipe Tobacco", showName: true, image: UIImage(named: "tobacco_60") , value: 11.11, backgroundColor: UIColor.wheelTobacco)]),

            Node(name: "Herbal/Earthy", showName: true, image: UIImage(named: "herby_60") , value: 11.11, backgroundColor: UIColor.wheelHerbal, children: [Node(name: "Fresh", showName: true, image: UIImage(named: "fresh_60") , value: 11.11, backgroundColor: UIColor.wheelFresh), Node(name: "Fresh", showName: true, image: UIImage(named: "fresh_60") , value: 11.11, backgroundColor: UIColor.wheelFresh)])
		]
		return nodes
	}
}

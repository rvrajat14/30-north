//
//  CoffeeViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 18/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import SwiftUI
import Alamofire

class CoffeeViewController: UIViewController {
	var controller: SnackWizardController?
	var mappingsArray : [String] = []

	var firstLevel = "-"
	var secondLevel = "-"
	var selectedItems : [Dictionary<String,Any>] = []
	var notifObservers = [NSObjectProtocol]()

    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var topGapForButtonVStack: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        // Do any additional setup after loading the view.
        mappingsArray.append("Nutty/Chocolate:Cocoa:589,593")
        mappingsArray.append("Nutty/Chocolate: :582")
        mappingsArray.append("Nutty/Chocolate:Hazelnut:591")
        mappingsArray.append("Nutty/Chocolate:Chocolate:592,595,596")
        mappingsArray.append("Nutty/Chocolate:Almond:594")
        mappingsArray.append("Nutty/Chocolate:Honey:608")
        mappingsArray.append("Spicy/Complex:Cinnamon:597")
        mappingsArray.append("Spicy/Complex:Pepper:598")
        mappingsArray.append("Spicy/Complex:Vanilla:607")
        mappingsArray.append("Fruity/Floral:Orange:599")
        mappingsArray.append("Fruity/Floral:Apricot:600")
        mappingsArray.append("Fruity/Floral:Berries:601,604")
        mappingsArray.append("Fruity/Floral:Apple:602")
        mappingsArray.append("Fruity/Floral: :603")
        mappingsArray.append("Fruity/Floral:Pomegranate:605")
        mappingsArray.append("Fruity/Floral:Floral:612")
        mappingsArray.append("Bright/Citrus/Sweet:Lemon/Lime:590")
        mappingsArray.append("Bright/Citrus/Sweet:Brown Sugar:606")
        mappingsArray.append("Roasted:Burnt:609")
        mappingsArray.append("Roasted:Pipe Tobacco:610")
        mappingsArray.append("Herbal/Earthy:Fresh:611")
    }

    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		self.removeWheelObserbers()
        self.firstLevel = "-"
        self.secondLevel = "-"
        self.selectedItems.removeAll()
        
        if UIScreen.main.bounds.height <= 667 {
            verticalStackView.spacing = 10
            topGapForButtonVStack.constant = 60.0
        } else {
            verticalStackView.spacing = 20
        }
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
		self.fetchCoffeeMapping()
		self.showCartButton()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

	deinit {
		self.removeWheelObserbers()
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
            self.openCoffeeRecommendation(items: self.selectedItems)
        }
		notifObservers.append(goObserver)

		let resetNotification = NSNotification.Name("clickedResetButton")
        let resetObserver = NotificationCenter.default.addObserver(forName: resetNotification, object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
            self.selectedItems.removeAll()
            self.firstLevel = "-"
            self.secondLevel = "-"
            self.navigationController?.popViewController(animated: false)
            self.showCoffeeFinder(withAnimation: false)
        }
		notifObservers.append(resetObserver)

		let questionNotification = NSNotification.Name("clickedQuestionButton")
        let questionObserver = NotificationCenter.default.addObserver(forName: questionNotification, object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
			self.showCoffeeFinderQuestion()
        }
		notifObservers.append(questionObserver)
	}

	func removeWheelObserbers() {
		for observer in notifObservers {
			NotificationCenter.default.removeObserver(observer)
		}
		notifObservers.removeAll()
	}

    @IBAction func coffeeologyAction(_ sender: Any) {
		//self.showCoffeeFinderQuestion()
		let brewingMethodsVC = self.storyboard?.instantiateViewController(identifier: "BrewingMethodsVC") as? BrewingMethodsVC
		self.navigationController?.pushViewController(brewingMethodsVC!, animated: true)
    }

	func coffeeFinder() {
		self.removeWheelObserbers()
        let subscriptionTypesViewController = self.storyboard?.instantiateViewController(identifier: "SubscriptionTypesViewController") as! SubscriptionTypesViewController
        self.navigationController?.pushViewController(subscriptionTypesViewController, animated: true)
	}
    
    @IBAction func onKnowYourGroundstart(_ sender: Any) {
        let knowYourGroundsViewController = self.storyboard?.instantiateViewController(identifier: "KnowYourGroundsViewController") as! KnowYourGroundsViewController
               self.navigationController?.pushViewController(knowYourGroundsViewController, animated: true)
    }
    
    @IBAction func onCoffeeWheelAction(_ sender: Any) {
        self.showCoffeeFinder(withAnimation: true)
        /*controller = SnackWizardController(navigationController: navigationController!)
        controller!.startWizard {
            self.navigationController?.popToRootViewController(animated: true)
            self.controller = nil
        }*/
    }

	func showCoffeeFinderQuestion() {
		controller = SnackWizardController(navigationController: navigationController!)
		controller?.startWizard(completion: { (options, text) in

			let final = "-:\(self.firstLevel):\(self.secondLevel):\(options)"
			let coffeeObject = CoffeeCases.filter { (option) -> Bool in

				let optionComponents = option.components(separatedBy: ":")
                let optionWithoutIDs = optionComponents.dropLast().joined(separator: ":")
                let arrayFinal = final.components(separatedBy: ":")
                let strFinal = arrayFinal.last
                let arraySecond = optionWithoutIDs.components(separatedBy: ":")
                let strCompare = arraySecond.last
                return strFinal == strCompare
//                return final == optionWithoutIDs
				
			}
			print("Final String From Coffee Finder: \(final)")
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
			self.openCoffeeRecommendation(items: selectedItems)

			/*self.selectedItems.removeAll()
			for coffeeId in coffeeIDs {
			   let Dict = ["level1": text, "level2":"","level3":"","item_id":Int(coffeeId) as Any]
			   self.selectedItems.append(Dict)
			}
			self.openCoffeeRecommendation(items: self.selectedItems)
			*/
		})
	}

    func showCoffeeFinder(withAnimation : Bool) {
        let configuration = SunburstConfiguration(nodes: self.coffeeNodes(), calculationMode: .ordinalFromRoot)
        var thickness:CGFloat = 100.0
        let screenBounds = UIScreen.main.bounds
        var innerRadius = ((screenBounds.width-16)/2) - thickness

        configuration.expandedArcThickness = thickness
        configuration.maximumExpandedRingsShownCount = 1
        configuration.maximumRingsShownCount = 1
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if(screenBounds.height <= 667){ // small devices like SE
                thickness = 90
                innerRadius = 60
            }else if(screenBounds.height == 736){ // 8 Plus case
                thickness = 100
                innerRadius = 80
            }
        }else{
            innerRadius = ((screenBounds.width-16)/2) - thickness - 150
            thickness = thickness + 60

        }
        configuration.innerRadius = innerRadius
        configuration.expandedArcThickness = thickness
        
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
                for item in self.mappingsArray{
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

    func openCoffeeRecommendation(items:[[String:Any]]) {
        if(selectedItems.count == 0) {
            return
        }
        
        let coffeeRecommendationVC = self.storyboard?.instantiateViewController(identifier: "CoffeeRecommendationViewController") as? CoffeeRecommendationViewController
        coffeeRecommendationVC?.selectedItems = items
        self.navigationController?.pushViewController(coffeeRecommendationVC!, animated: true)
    }
        
	func coffeeNodes() -> [Node] {
		let nodes = [
            Node(name: "Nutty/Chocolate", showName: true, image: UIImage(named: "nutty_60") , value: 1, backgroundColor: UIColor.wheelNuttyChocolate, children: [Node(name: "Cocoa", showName: true, image: UIImage(named: "cocoa_60") , value: 0.2, backgroundColor: UIColor.wheelCocoa), Node(name: "Hazelnut", showName: true, image: UIImage(named: "hazelnut_60")  , value: 0.2, backgroundColor: UIColor.wheelHazelnut), Node(name: "Chocolate", showName: true, image: UIImage(named: "chocolate_60") , value: 0.2, backgroundColor: UIColor.wheelChocolate), Node(name: "Almond", showName: true, image: UIImage(named: "almond_60") , value: 0.2, backgroundColor: UIColor.wheelAlmond), Node(name: "Honey", showName: true, image: UIImage(named: "honey_60") , value: 0.2, backgroundColor: UIColor.wheelHoney)]),

            Node(name: "Spicy/Complex", showName: true, image: UIImage(named: "spicy_60") , value: 1, backgroundColor: UIColor.wheelSpicyComplex, children: [Node(name: "Cinnamon", showName: true, image: UIImage(named: "cinnamon_60") , value: 0.33, backgroundColor: UIColor.wheelCinnamon), Node(name: "Pepper", showName: true, image: UIImage(named: "pepper_60") , value: 0.33, backgroundColor: UIColor.wheelPepper), Node(name: "Vanilla", showName: true, image: UIImage(named: "vanilla_60") , value: 0.33, backgroundColor: UIColor.wheelVanilla)]),

            Node(name: "Fruity/Floral", showName: true, image: UIImage(named: "fruity_60") , value: 1, backgroundColor: UIColor.wheelFruityFloral, children: [Node(name: "Orange", showName: true, image: UIImage(named: "orange_60") , value: 0.166, backgroundColor: UIColor.wheelOrange), Node(name: "Apricot", showName: true, image: UIImage(named: "apricot_60") , value: 0.166, backgroundColor: UIColor.wheelApricot), Node(name: "Berries", showName: true, image: UIImage(named: "berries_60") , value: 0.166, backgroundColor: UIColor.wheelBerries), Node(name: "Apple", showName: true, image: UIImage(named: "apple_60") , value: 0.166, backgroundColor: UIColor.wheelApple),  Node(name: "Pomegranate", showName: true, image: UIImage(named: "Pomegranate_60") , value: 0.166, backgroundColor: UIColor.wheelPomegranate),  Node(name: "Floral", showName: true, image: UIImage(named: "flower_60") , value: 0.166, backgroundColor: UIColor.wheelFloral)]),

            Node(name: "Bright/Citrus/Sweet", showName: true, image: UIImage(named: "citrus_60") , value: 1, backgroundColor: UIColor.wheelBrightCitrusSweet, children: [Node(name: "Lemon/ Lime", showName: true, image: UIImage(named: "lemon_60") , value: 0.5, backgroundColor: UIColor.wheelLime), Node(name: "Brown Sugar", showName: true, image: UIImage(named: "sugar_60") , value: 0.5, backgroundColor: UIColor.wheelBrownSugar)]),

            Node(name: "Roasted", showName: true, image: UIImage(named: "floral_60") , value: 1, backgroundColor: UIColor.wheelRoasted, children: [Node(name: "Burnt", showName: true, image: UIImage(named: "burnt_60") , value: 0.5, backgroundColor: UIColor.wheelBurnt), Node(name: "Pipe Tobacco", showName: true, image: UIImage(named: "tobacco_60") , value: 0.5, backgroundColor: UIColor.wheelTobacco)]),

            Node(name: "Herbal/Earthy", showName: true, image: UIImage(named: "herby_60") , value: 1, backgroundColor: UIColor.wheelHerbal, children: [Node(name: "Fresh", showName: true, image: UIImage(named: "fresh_60") , value: 1, backgroundColor: UIColor.wheelFresh),Node(name: "Fresh", showName: true, image: UIImage(named: "fresh_60") , value: 1, backgroundColor: UIColor.wheelFresh)])
		]

		return nodes
	}
}

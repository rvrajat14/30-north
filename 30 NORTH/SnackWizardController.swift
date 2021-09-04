//
//  SnackWizardController.swift
//  Wizard
//
//  Created by Warren Milward on 18/7/19.
//  Copyright © 2019 Inteweave. All rights reserved.
//

import UIKit

typealias SnackWizard = Wizard<CoffeeScreen, Event>

///
/// Sample wizard to enable the user to select a snack
///```
/// Flows are:
/// - choose snack
///   - icecream
///     - scoop
///     - soft serve
///       - choc dip
///       - sprinkles
///  - nuts
///```
///
/// This class is responsible for creating and showing view controllers
/// and for defining the screen navigation. For a real app the screen navigations would probably be
/// in its own file.
///
/// To add a screen, you would normally:
/// - code view controller, presenter and .xib
/// - add an identifier for the screen
/// - add the creation of the view controller to the factory
/// - add any new events raised by the screen
/// - add navigations for events going to the screen and handling the events from the screen
///
class SnackWizardController: EventDelegate {

    let navigationController: UINavigationController
    let wizard: SnackWizard
    let factory: SnackFactory
    var completion: ((String, String) -> Void)?
	var typeSubscription:String?
	var optionsSelected:[CoffeeScreen:String]? = nil

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        wizard = SnackWizard(screenNavigations: SnackWizardController.screenNavigations)
        factory = SnackFactory()
        factory.delegate = self
		optionsSelected = nil
    }

    ///
    /// Start the wizard
    ///
    /// - parameter completion: Completion block to be invoked when the wizard finishes or is cancelled.
    ///
	func startWizard(completion: @escaping (String, String) -> Void) {
        self.completion = completion
		let viewController = factory.viewForScreen(screen: CoffeeScreen.coffeeExperience)
		navigationController.pushViewController(viewController, animated: true)
    }

	func startSubscriptionWizard(type:String, completion: @escaping (String, String) -> Void) {
		self.typeSubscription = type
        self.completion = completion
		let viewController = factory.viewForScreen(screen: CoffeeScreen.brewingMethod)
		navigationController.pushViewController(viewController, animated: true)

		if self.optionsSelected == nil {
			if type == "1" {
				self.optionsSelected = [CoffeeScreen.coffeeExperience: "Could-be barista"]
				self.optionsSelected?[CoffeeScreen.preferredTaste] = "A new everyday coffee"
			} else if type == "2" {
				self.optionsSelected = [CoffeeScreen.coffeeExperience: "I just know I like it"]
				self.optionsSelected?[CoffeeScreen.preferredTaste] = "A sampling of different coffees"
			} else if type == "3" {
				self.optionsSelected = [CoffeeScreen.coffeeExperience: "-"]
				self.optionsSelected?[CoffeeScreen.preferredTaste] = "-"
				self.optionsSelected?[CoffeeScreen.beanGrind] = "-"
			}
		}
    }

	func subscriptionType() -> String {
		return self.typeSubscription ?? ""
	}

    ///
    /// The user has selected an action
    ///  Use the wizard to determine the next screen and instantiate it
    ///
    /// - parameter event: The event raised
    ///
	func event(_ event: Event, wasRaisedOnScreen screen: CoffeeScreen, selected:String) {
		if self.optionsSelected == nil {
			self.optionsSelected = [screen:selected]
		} else {
			self.optionsSelected?[screen] = selected
		}

		guard let selectedOptions = self.optionsSelected else {
			return
		}
		let coffeeExperience = selectedOptions[CoffeeScreen.coffeeExperience]
		let brewingMethod = selectedOptions[CoffeeScreen.brewingMethod]
		let preferredTaste = selectedOptions[CoffeeScreen.preferredTaste]
		let beanGrind = selectedOptions[CoffeeScreen.beanGrind]

		var selectedText:String = ""

		if let text = preferredTaste, text.contains("seasonal") {
			if let brewingMethod = brewingMethod {
				selectedText = text + " to brew in a " + brewingMethod
			}
		} else if let preferredTasteText = preferredTaste {
			selectedText = preferredTasteText + " to brew in a "

			if let text = brewingMethod, text.contains("V60") {
				selectedText.append(text)

				if let text = coffeeExperience, text.contains("barista") {
					if let text = beanGrind, text.contains("Africa") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Americas") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Indo Pacific") {
						selectedText.append(" from " + text)
					} else if let beanGrind = beanGrind {
						selectedText.append(" from " + beanGrind)
					}
				}
			} else if let text = brewingMethod, text.contains("Mocha Pot") {
				selectedText.append(text)

				if let text = coffeeExperience, text.contains("barista") {
					if let text = beanGrind, text.contains("Africa") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Americas") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Indo Pacific") {
						selectedText.append(" from " + text)
					} else if let beanGrind = beanGrind {
						selectedText.append(" from " + beanGrind)
					}
				}
			} else if let text = brewingMethod, text.contains("French Press") {
				selectedText.append(text)

				if let text = coffeeExperience, text.contains("barista") {
					if let text = beanGrind, text.contains("Africa") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Americas") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Indo Pacific") {
						selectedText.append(" from " + text)
					} else if let beanGrind = beanGrind {
						selectedText.append(" from " + beanGrind)
					}
				}
			} else if let text = brewingMethod, text.contains("Aero Press") {
				selectedText.append(text)

				if let text = coffeeExperience, text.contains("barista") {
					if let text = beanGrind, text.contains("Africa") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Americas") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Indo Pacific") {
						selectedText.append(" from " + text)
					} else if let beanGrind = beanGrind {
						selectedText.append(" from " + beanGrind)
					}
				}
			} else if let text = brewingMethod, text.contains("Espresso") {
				selectedText.append(text)

				if let text = coffeeExperience, text.contains("barista") {
					if let text = beanGrind, text.contains("Americas") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Indo Pacific") {
						selectedText.append(" from " + text)
					} else if let beanGrind = beanGrind {
						selectedText.append(" from " + beanGrind)
				   }
				}
			} else if let text = brewingMethod, text.contains("Chemex") {
				selectedText.append(text)

				if let text = coffeeExperience, text.contains("barista") {
					if let text = beanGrind, text.contains("Africa") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Americas") {
						selectedText.append(" from " + text)
					} else if let beanGrind = beanGrind {
						selectedText.append(" from " + beanGrind)
					}
				}
			} else if let text = brewingMethod, text.contains("Filter") {
				selectedText.append(text)

				if let text = coffeeExperience, text.contains("barista") {
					if let text = beanGrind, text.contains("Americas") {
						selectedText.append(" from " + text)
					} else if let text = beanGrind, text.contains("Indo Pacific") {
						selectedText.append(" from " + text)
					} else if let beanGrind = beanGrind {
						selectedText.append(" from " + beanGrind)
					}
				}
			}
		}
		if  event == .finish || self.typeSubscription == "3" || self.typeSubscription == "2" {
			self.optionsSelected = nil
			let options:String = "\(coffeeExperience ?? "-"):\(brewingMethod ?? "-"):\(preferredTaste  ?? "-"):\(beanGrind ?? "-")"
			completion?(options, self.typeSubscription == "3" ? brewingMethod ?? "" : selectedText)
        } else if let screenIdentifier = try? wizard.event(event: event, wasRaisedOnScreen: screen) {
			if self.typeSubscription == "1" {
				let viewController = factory.viewForScreen(screen: CoffeeScreen.beanGrind)
				navigationController.pushViewController(viewController, animated: true)
			} else {
				if self.typeSubscription == nil {
					if let text = preferredTaste, text.contains("seasonal") {
						self.optionsSelected = nil
						let options:String = "\(coffeeExperience ?? "-"):\(brewingMethod ?? "-"):\(preferredTaste  ?? "-"):\(beanGrind ?? "-")"
						completion?(options, selectedText)
					} else if let text = coffeeExperience, text.contains("barista") {
						if beanGrind != nil {
							self.optionsSelected = nil
							let options:String = "\(coffeeExperience ?? "-"):\(brewingMethod ?? "-"):\(preferredTaste  ?? "-"):\(beanGrind ?? "-")"
							completion?(options, selectedText)
						} else {
							let viewController = factory.viewForScreen(screen: screenIdentifier)
							navigationController.pushViewController(viewController, animated: true)
						}
					} else {
						if preferredTaste != nil {
							self.optionsSelected = nil
							let options:String = "\(coffeeExperience ?? "-"):\(brewingMethod ?? "-"):\(preferredTaste  ?? "-"):\(beanGrind ?? "-")"
							completion?(options, selectedText)
						} else {
							let viewController = factory.viewForScreen(screen: screenIdentifier)
							navigationController.pushViewController(viewController, animated: true)
						}
					}
				} else {
					let viewController = factory.viewForScreen(screen: screenIdentifier)
					navigationController.pushViewController(viewController, animated: true)
				}
			}
        }
    }
}

// MARK: - Screen Navigation

///
/// For a substantial UX flow, this will probably be in its own file
/// If there is a cancel button, each screen might also define an action for the finish event
///
extension SnackWizardController {
    static let screenNavigations = [
        // from screen, on event, navigate to screen
        ScreenNavigation(onScreen: CoffeeScreen.coffeeExperience,
                         when: Event.userDidChooseNew,
                         navigateTo: CoffeeScreen.brewingMethod),

        ScreenNavigation(onScreen: CoffeeScreen.brewingMethod,
                         when: Event.userDidChooseBrewingMethod,
                         navigateTo: CoffeeScreen.preferredTaste),

        /*ScreenNavigation(onScreen: CoffeeScreen.additions,
                         when: Event.userDidChooseAddition,
                         navigateTo: CoffeeScreen.preferredTaste),*/
                
        ScreenNavigation(onScreen: CoffeeScreen.preferredTaste,
                         when: Event.userDidChoosePreferredTaste,
                         navigateTo: CoffeeScreen.beanGrind),
        
    ]
}

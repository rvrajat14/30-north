//
//  SnacksViewPresenter.swift
//  Wizard
//
//  Created by Warren Milward on 19/7/19.
//  Copyright © 2019 Inteweave. All rights reserved.
//

import UIKit

protocol EventDelegate: AnyObject {
    ///
    /// Raise the user event
    ///
	func subscriptionType() -> String
	func event(_ event: Event, wasRaisedOnScreen: CoffeeScreen, selected: String)
}

///
/// View Presenter for the snacks screen
/// This is a template and we just change the contents
///
class SnacksViewPresenter {

    let screen: CoffeeScreen
    weak var eventDelegate: EventDelegate?

    ///
    /// Returns a newly created presenter initialised for the specified screen
    ///
    /// - parameter screen: The *ScreenName* of the screen to display
    /// - returns: The newly created presenter
    ///
    init(screen: CoffeeScreen) {
         self.screen = screen
    }

}

// MARK: - Snacks View content
extension SnacksViewPresenter {
    var label: String {
        return screen.contents.label
    }

	var options:[String] {
		return screen.contents.options
	}

	var images:[String] {
		return screen.contents.images
	}

	func subscriptionType()-> String {
		return eventDelegate?.subscriptionType() ?? ""
	}
	
	func selectedIndex(indexPath:IndexPath) {
		let optionSelected = self.options[indexPath.item]
		eventDelegate?.event(screen.contents.nextAction, wasRaisedOnScreen: screen, selected: optionSelected)
    }
}

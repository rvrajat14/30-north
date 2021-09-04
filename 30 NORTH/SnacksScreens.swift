//
//  SnackWizardScreens.swift
//  Wizard
//
//  Created by Warren Milward on 21/7/19.
//  Copyright © 2019 Inteweave. All rights reserved.
//

import Foundation

///
/// Use an enum for screens so that we have additional checking.
/// When using data from an external source (e.g. dynamic wizard) we will probably just use strings.
///
enum CoffeeScreen {
    case coffeeExperience
    case brewingMethod
    //case additions
    case preferredTaste
    case beanGrind

    var contents: ScreenContents {
        switch self {
        case .coffeeExperience:
            return CoffeeExperienceScreen()
        case .brewingMethod:
            return BrewingMethodScreen()
        /*case .additions:
            return AdditionsScreen()*/
        case .preferredTaste:
            return PreferredTasteScreen()
        case .beanGrind:
            return BeanTypeScreen()
        }
    }
}

// MARK: - Screen Contents
protocol ScreenContents {
    var label: String { get }
    var options: [String] { get }
	var images: [String] { get }
    var nextAction: Event { get }
    var completionEvent: Event { get }
}

struct CoffeeExperienceScreen: ScreenContents {
    var label = "How much of a coffee expert are you?"
    var options = ["Could-be barista", "I know my beans", "I just know I like it"]
    var images = ["finder_experience_01", "finder_experience_02", "finder_experience_03"]
    var nextAction = Event.userDidChooseNew
    var completionEvent = Event.finish
}

struct BrewingMethodScreen: ScreenContents {
    var label = "How do you prepare your coffee?"
    var options = ["Mocha Pot", "Filter", "French Press", "V60", "Aero Press", "Espresso", "Chemex", "Various"]
    var images = ["finder_mocha", "finder_filter", "finder_french", "finder_v60", "finder_aero", "finder_espresso", "finder_chemex", "finder_various"]
    var nextAction = Event.userDidChooseBrewingMethod
	var completionEvent = Event.finish
}

//struct AdditionsScreen: ScreenContents {
//    var label = "How much caffeine do you want?"
//    var options = ["Full caffeine", "Half-caffeine / Decaf"]
//    var images = ["coffee", "beans"]
//    var actionEvent = Event.userDidChooseAddition
//}

struct PreferredTasteScreen: ScreenContents {
    var label = "What are you looking for?"
	var options = ["A new everyday coffee", "Something seasonal", "A sampling of different coffees"]
    var images = ["finder_everyday", "finder_seasonal", "finder_sampling"]
    var nextAction = Event.userDidChoosePreferredTaste
	var completionEvent = Event.finish
}

struct BeanTypeScreen: ScreenContents {
    var label = "What origins inspire you?"
	var options = ["Americas", "Africa + Arabia", "Indo-Pacific", "I like world blends"]
    var images = ["finder_americas", "finder_africa", "finder_indo-pacific", "finder_world"]
    var nextAction = Event.finish
	var completionEvent = Event.finish
}

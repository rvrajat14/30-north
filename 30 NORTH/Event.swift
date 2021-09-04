//
//  Event.swift
//  Wizard
//
//  Created by Warren Milward on 26/7/19.
//  Copyright © 2019 Inteweave. All rights reserved.
//

import Foundation

///
/// The event names used.
/// Use an enum for so that we have additional checking.
/// When using data from an external source (e.g. dynamic wizard) we will probably just use strings.
/// For many wizards there are standard events used by many screens such as *next*, *cancel* or *finish*.
///
enum Event {
    case userDidChooseNew
    case userDidChooseIntermediate
    case userDidChooseAdvanced
    case userDidChooseNerd
    case userDidChooseAddition
    case userDidChooseBrewingMethod
    case userDidChooseRoastLevel
    case userDidChoosePreferredTaste
    case userDidChooseBeanGrind
    case finish
}

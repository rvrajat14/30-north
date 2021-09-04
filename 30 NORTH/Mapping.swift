//
//  Mapping.swift
//  30 NORTH
//
//  Created by Anil Kumar on 22/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation

struct Mapping {
	static var CoffeeFinderOptions = [
		Almond.options,
		Apricot.options,
		Berries.options,
		BrightCitrusSweet.options,
		BrownSugar.options,
		Burnt.options,
		Chocolate.options,
		Cinnamon.options,
		Cocoa.options,
		Floral.options,
		Fresh.options,
		FruityFloral.options,
		Hazelnut.options,
		HerbalEarthy.options,
		Honey.options,
		LemonLime.options,
		NuttyChocolate.options,
		Orange.options,
		Pepper.options,
		PipeTobacco.options,
		Pomegranate.options,
		Roasted.options,
		SpicyComplex.options,
		Vanilla.options,
		].flatMap { $0 }
}

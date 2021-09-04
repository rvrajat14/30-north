//
//  CoffeeFinderViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 13/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class CoffeeFinderViewController: UIViewController {

	let stepColor = UIColor.gold
	let stepFont = UIFont(name: AppFontName.regular, size: 14)!

	let questionColor = UIColor.white
	let questionFont = UIFont(name: AppFontName.regular, size: 16)!

	@IBOutlet weak var titleLabel: UILabel!{
		didSet {
			titleLabel.titleStyle(text: "COFFEE FINDER")
		}
	}

	@IBOutlet weak var stepLabel: UILabel!{
		didSet {
			stepLabel.text = "1/5"
			stepLabel.textAlignment = .left
			stepLabel.textColor = self.stepColor
			stepLabel.font = self.stepFont
		}
	}

	@IBOutlet weak var questionLabel: UILabel!{
		didSet {
			questionLabel.text = "How much of a coffee expert are you?"
			questionLabel.textAlignment = .left
			questionLabel.textColor = self.questionColor
			questionLabel.font = self.questionFont
		}
	}

	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			collectionView.delegate = self
			collectionView.dataSource = self
			collectionView.backgroundColor = UIColor.clear

			collectionView.showsVerticalScrollIndicator = false
			collectionView.showsHorizontalScrollIndicator = false

			let flowLayout = UICollectionViewFlowLayout()
			flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
			collectionView.setCollectionViewLayout(flowLayout, animated: true)
		}
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}
}

extension CoffeeFinderViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let screenRect = collectionView.frame//UIScreen.main.bounds
		let margin:CGFloat = 24.0
		let width = ((screenRect.width - margin)/2)
		let size = CGSize(width: width, height: width)
        return size
    }

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 12.0
	}

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20.0
    }
}

extension CoffeeFinderViewController : UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoffeeFinderCell", for: indexPath) as? CoffeeFinderCell

		cell?.textLabel.text = "Coffee"
		cell?.imageView.image = UIImage(named: "1")

		cell!.backgroundColor = .white
		cell?.layer.cornerRadius = 3.0
		cell?.clipsToBounds = true

		return cell!
	}
}

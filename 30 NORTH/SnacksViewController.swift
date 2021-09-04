//
//  SnacksViewController.swift
//  Wizard
//
//  Created by Warren Milward on 19/7/19.
//  Copyright © 2019 Inteweave. All rights reserved.
//

import UIKit

///
/// Simple view controller to act as a template for all screens
/// The template is filled with information from the view presenter
///
/// A real app would probably have a number of templates and maybe some screen-specific view controllers
///
class SnacksViewController: UIViewController {

    // hold a strong reference to the presenter so that the memory is managed by the system
    // as it removes view controllers
    var viewPresenter: SnacksViewPresenter?

  let stepColor = UIColor.gold
  let stepFont = UIFont(name: AppFontName.regular, size: 14)!

  let questionColor = UIColor.white
  let questionFont = UIFont(name: AppFontName.bold, size: 16)!

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

			let cellNib = UINib(nibName: "CoffeeFinderCell", bundle: nil)
			collectionView.register(cellNib, forCellWithReuseIdentifier: "CoffeeFinderCell")

			collectionView.showsVerticalScrollIndicator = false
			collectionView.showsHorizontalScrollIndicator = false

			let flowLayout = UICollectionViewFlowLayout()
			flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
			collectionView.setCollectionViewLayout(flowLayout, animated: true)
		}
	}

    init(screen: CoffeeScreen, eventDelegate: EventDelegate?) {
        super.init(nibName: nil, bundle: nil)
        viewPresenter = SnacksViewPresenter(screen: screen)
        viewPresenter?.eventDelegate = eventDelegate
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.mainViewBackground
        configureView()
    }

	func configureView() {
		questionLabel.text = viewPresenter?.label

		let subscriptionType = viewPresenter?.subscriptionType()
		if subscriptionType != "" {
			switch viewPresenter!.screen {
			case .coffeeExperience:
				stepLabel.text = ""
			case .brewingMethod:
				if subscriptionType == "2" || subscriptionType == "3" {
					stepLabel.text = "1/1"
				} else {
					stepLabel.text = "1/2"
				}
			case .preferredTaste:
				stepLabel.text = ""
			case .beanGrind:
				stepLabel.text = "2/2"
			}
		} else {
			switch viewPresenter!.screen {
			case .coffeeExperience:
				stepLabel.text = "1/4"
			case .brewingMethod:
				stepLabel.text = "2/4"
			/*case .additions:
				stepLabel.text = "3/5"*/
			case .preferredTaste:
				stepLabel.text = "3/4"
			case .beanGrind:
				stepLabel.text = "4/4"
			}
		}

		collectionView.reloadData()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}
}

extension SnacksViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let size = CGSize(width: 100, height: 100)
        return size
    }

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 12.0
	}

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20.0
    }

	/*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		// Centering if there are fever pages
		let itemSize: CGSize? = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize
		let spacing: CGFloat? = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing

		let count: Int = self.collectionView.numberOfItems(inSection: section)
		let totalCellWidth = (itemSize?.width ?? 0.0) * CGFloat(count)
		let totalSpacingWidth = (spacing ?? 0.0) * CGFloat(((count - 1) < 0 ? 0 : count - 1))
		let leftInset: CGFloat = (self.collectionView.bounds.size.width - (totalCellWidth + totalSpacingWidth)) / 2
		if leftInset < 0 {
			let inset: UIEdgeInsets? = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset
			return inset!
		}
		let rightInset: CGFloat = leftInset
		let sectionInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
		return sectionInset
	}*/
}

extension SnacksViewController : UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewPresenter?.options.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoffeeFinderCell", for: indexPath) as? CoffeeFinderCell

		guard let option = viewPresenter?.options[indexPath.item], let image = viewPresenter?.images[indexPath.item] else {
			return cell!
		}

		cell?.textLabel.text = option
		cell?.imageView.image = UIImage(named: image)

		cell?.backgroundColor = .white
		cell?.layer.cornerRadius = 3.0
		cell?.clipsToBounds = true

		return cell!
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		viewPresenter?.selectedIndex(indexPath: indexPath)
	}
}

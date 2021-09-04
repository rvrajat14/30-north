//
//  BrewingIngredientsViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 10/06/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit

class BrewingIngredientsViewController: UIViewController {

	var ingredients:[String]? = nil
	var method:String = ""
	var methodIndex:Int = 0

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "Ingredients")
		}
	}
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.dataSource = self
			tableView.delegate = self
			tableView.separatorStyle = .none

			tableView.estimatedRowHeight = 30
			tableView.backgroundColor = UIColor.clear
		}
	}
	@IBOutlet weak var startButton: UIButton! {
		didSet {
			startButton.titleLabel?.font = UIFont(name: AppFontName.bold, size: 20)
			startButton.layer.cornerRadius = 3.0
			startButton.clipsToBounds = true
			startButton.setTitle("START", for: .normal)
			startButton.setTitleColor(.black, for: .normal)
			startButton.backgroundColor = .white
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		configureView()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}

	func configureView() {
		self.view.backgroundColor = UIColor.mainViewBackground
	}

	@IBAction func startAction(_ sender: UIButton) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)

		let vc = storyboard.instantiateViewController(identifier: "BrewingPagesVC") as? BrewingPagesVC
		vc?.methodIndex = self.methodIndex
		vc?.navigationItem.title = method
		self.navigationController?.pushViewController(vc!, animated: true)
	}
}


extension BrewingIngredientsViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let ingredients = self.ingredients else {
			return 0
		}
		return ingredients.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell") else {
				return UITableViewCell(style: .default, reuseIdentifier: "IngredientsCell")
			}
			return cell
		}()

		guard let ingredients = self.ingredients else {
			return cell
		}

		cell.textLabel?.textColor = UIColor.white
		cell.textLabel?.font = UIFont(name: AppFontName.bold, size: 20)

		cell.textLabel?.text = ingredients[indexPath.row]
		cell.backgroundColor = .clear
		cell.selectionStyle = .none
		return cell
	}
}

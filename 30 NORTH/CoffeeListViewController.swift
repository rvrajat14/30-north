//
//  CoffeeListViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 18/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire


class CoffeeListViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "Coffee Profiles")
		}
	}

	@IBOutlet weak var subtitleLabel: UILabel! {
		didSet {
			subtitleLabel.text = "An up to date rundown of our coffee suppliers"
			subtitleLabel.numberOfLines = 0
			subtitleLabel.textColor = UIColor.white
			//subtitleLabel.font = UIFont.systemFont(ofSize: 14)
            subtitleLabel.font = UIFont(name: "NexaLight", size: 14)

		}
	}

	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.delegate = self
			tableView.dataSource = self
			tableView.separatorStyle = .none
			tableView.backgroundColor = .clear

			tableView.rowHeight = UITableView.automaticDimension
			tableView.estimatedRowHeight = 120
		}
	}

	var cuppings:[Cupping]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        // Do any additional setup after loading the view.
		configureView()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()

		updateBackButton()
		self.showCartButton()
    }

	func updateBackButton() {
	   let backItem = UIBarButtonItem()
	   backItem.title = ""
	   navigationItem.backBarButtonItem = backItem
	}

	//MARK: Private Methods
	private func configureView() {
		loadCuppingsData()
	}

	func loadCuppingsData() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
		_ = Alamofire.request(APIRouters.GetCuppings).responseCollection(completionHandler: { (response: DataResponse<[Cupping]>) in
			DispatchQueue.main.async {
                switch response.result {
                case .success:
					_ = EZLoadingActivity.hide()
                    if let cuppings:[Cupping] = response.result.value {
						self.cuppings = cuppings
						self.tableView.reloadData()
                    } else {
						print("No Coffee profile data to show")
					}
                case .failure(let error):
					_ = EZLoadingActivity.hide()
					print("Error: \(error.localizedDescription)")
				}
            }
		})
    }
}


extension CoffeeListViewController : UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let cuppings = self.cuppings else {
			return 0
		}
		return cuppings.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let coffeeCell = tableView.dequeueReusableCell(withIdentifier: "CoffeeListCell", for: indexPath) as! CoffeeListCell
		guard let cupping = self.cuppings?[indexPath.row] else {
			return coffeeCell
		}
		coffeeCell.countryLabel.attributedText = NSAttributedString(string: cupping.country ?? "")
		coffeeCell.titleLabel.attributedText = NSAttributedString(string: cupping.title ?? "")
		coffeeCell.descriptionLabel.attributedText = NSAttributedString(string: cupping.desc ?? "")
		coffeeCell.learnMore.addTarget(self, action: #selector(detailButtonAction(_:)), for: .touchUpInside)

		if let imagePath = cupping.flag_path {
			let imageURL = configs.imageUrl + imagePath
			coffeeCell.iconImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
			   if(status == STATUS.success) {
				print("Loaded flag image successfully: \(msg)")
			   } else {
				  print("Error in loading image: \(msg)")
			   }
			}
		}
		coffeeCell.backgroundColor = .clear
		return coffeeCell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		self.openCoffeeDetail(indexPath: indexPath)
	}

	@objc func detailButtonAction(_ sender:UIButton) {
		guard let cell = sender.superview?.superview?.superview as? CoffeeListCell, let indexPath = tableView.indexPath(for: cell) else {
			return
		}
		self.openCoffeeDetail(indexPath: indexPath)
	}

	func openCoffeeDetail(indexPath:IndexPath) {
		guard let cupping = self.cuppings?[indexPath.row] else {
			return
		}
		let coffeeDetailVC = self.storyboard?.instantiateViewController(identifier: "CoffeeDetailViewController") as! CoffeeDetailViewController
		coffeeDetailVC.cupping = cupping
		self.navigationController?.pushViewController(coffeeDetailVC, animated: true)
	}
}

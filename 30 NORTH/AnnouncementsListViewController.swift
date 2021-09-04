//
//  CoffeeListViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 18/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire


class AnnouncementsListViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.titleStyle(text: "ANNOUNCEMENTS")
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

    var announcements:[Announcement]? = nil

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
        _ = Alamofire.request(APIRouters.GetAnnouncements).responseCollection(completionHandler: { (response: DataResponse<[Announcement]>) in
            DispatchQueue.main.async {
                switch response.result {
                case .success:
                    _ = EZLoadingActivity.hide()
                    if let announcements:[Announcement] = response.result.value {
						self.announcements = announcements
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


extension AnnouncementsListViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let announcements = self.announcements else {
            return 0
        }
        return announcements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coffeeCell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementListCell", for: indexPath) as! AnnouncementListCell
        guard let announcement = self.announcements?[indexPath.row] else {
            return coffeeCell
        }
        coffeeCell.countryLabel.attributedText = NSAttributedString(string: announcement.title ?? "")
        //coffeeCell.titleLabel.attributedText = NSAttributedString(string: announcement.desc ?? "")
		if let desc = announcement.desc, desc.count > 0 {
			coffeeCell.descriptionLabel.attributedText = NSAttributedString(string: desc)
		} else if let notes = announcement.notes, notes.count > 0 {
			coffeeCell.descriptionLabel.attributedText = NSAttributedString(string: notes)
		}

        coffeeCell.learnMore.addTarget(self, action: #selector(detailButtonAction(_:)), for: .touchUpInside)
		coffeeCell.iconImage.image = UIImage(named: "emptyCup")
        coffeeCell.backgroundColor = .clear
        return coffeeCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.openAnnouncementDetail(indexPath: indexPath)
    }

    @objc func detailButtonAction(_ sender:UIButton) {
        guard let cell = sender.superview?.superview?.superview as? AnnouncementListCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        self.openAnnouncementDetail(indexPath: indexPath)
    }

    func openAnnouncementDetail(indexPath:IndexPath) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let announcementsVC = storyboard.instantiateViewController(withIdentifier: "AnnouncementsViewController") as? AnnouncementsViewController
		//Pass data to Outlet Popup
		announcementsVC?.announcements = self.announcements
		announcementsVC?.initialIndex = indexPath.row
		announcementsVC?.modalPresentationStyle = .fullScreen
		self.present(announcementsVC!, animated: true) {
			print("Presented")
		}
		//Completion handler
		announcementsVC?.didSelectAnnouncement = { (announcement:Announcement) in

			if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.getTabbarController() {
				tabBarController.selectedViewController?.navigationController?.popToRootViewController(animated: true)

				switch announcement.action_screen {
				case "home":
					tabBarController.selectedIndex = 0
				case "order":
					tabBarController.selectedIndex = 1
				case "coffee-guide":
					tabBarController.selectedIndex = 2
				case "brewing-methods":
					tabBarController.selectedIndex = 3
				case "more":
					tabBarController.selectedIndex = 4
				default:
					break
				}
			}
		}
	}
}


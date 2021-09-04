//
//  AnnouncementsViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 28/04/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import AFDateHelper
import CenteredCollectionView

public typealias AnnouncementHandler = (_ data:Announcement) -> Void
class AnnouncementsViewController: UIViewController {

	var didSelectAnnouncement:AnnouncementHandler? = nil
	var announcements:[Announcement]? = nil

	let titleColor = UIColor(red: 186/255, green: 140/255, blue: 43/255, alpha: 1)
	let titleFont = UIFont(name: AppFontName.bold, size: 18)!
	var initialIndex = -1
	var currentIndex = 0
	var flowLayout: CenteredCollectionViewFlowLayout!

	@IBOutlet weak var collectionView: UICollectionView! {
		didSet {
			collectionView.backgroundColor = .clear
			collectionView.clipsToBounds = true

			let layout = UICollectionViewFlowLayout()
			layout.scrollDirection = .horizontal
			collectionView.dataSource = self
			collectionView.delegate = self
		}
	}

	@IBOutlet weak var imageView: UIImageView! {
		didSet {
			imageView.image = nil
			imageView.contentMode = .scaleAspectFit
			imageView.backgroundColor = .clear
		}
	}

	@IBOutlet weak var closeButton: UIButton! {
		didSet {
			closeButton.layer.cornerRadius = closeButton.frame.height/2.0
			closeButton.clipsToBounds = true
			closeButton.setImage(UIImage(named: "closeIcon"), for: .normal)
			closeButton.setTitle("", for: .normal)
			closeButton.imageView?.contentMode = .scaleAspectFit
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground
		// Do any additional setup after loading the view.
		configureView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if initialIndex != -1 {
			self.setupUIandContent(index: initialIndex)
			initialIndex = -1
		} else {
			self.setupUIandContent(index: 0)
		}
	}

	func configureView() {
		self.collectionFlowLayout()
	}

	func collectionFlowLayout() {
		if let flowLayout = self.collectionView.collectionViewLayout as? CenteredCollectionViewFlowLayout {
			self.flowLayout = flowLayout
			flowLayout.itemSize = CGSize(
				width: view.bounds.width,
				height: collectionView.bounds.height
			)
			// Configure the optional inter item spacing (OPTIONAL STEP)
			flowLayout.minimumLineSpacing = 0
			// Get rid of scrolling indicators
			collectionView.showsVerticalScrollIndicator = false
			collectionView.showsHorizontalScrollIndicator = false
			collectionView.decelerationRate = .fast
		}
	}

	@objc func previousAction(_ sender: UIButton) {
		if self.currentIndex == 0 {
			return
		}
		currentIndex -= 1
		self.setupUIandContent(index: currentIndex)
	}

	@objc func nextAction(_ sender: UIButton) {
		guard let announcements = self.announcements else {
			return
		}
		if self.currentIndex == announcements.count - 1 {
			return
		}
		currentIndex += 1
		self.setupUIandContent(index: currentIndex)
	}

	@objc func goAction(_ sender: UIButton) {
		guard let announcements = self.announcements else {
			return
		}
		if let handler = self.didSelectAnnouncement {
			let announcement = announcements[currentIndex]
			self.dismiss(animated: true) {
				handler(announcement)
			}
		}
	}

	@IBAction func closeAction(_ sender: UIButton) {
		self.dismiss(animated: true) {
			print("Dismissed")
		}
	}
}

extension AnnouncementsViewController {
	func setupUIandContent(index: Int) {
		guard let announcements = self.announcements else {
			return
		}
		self.currentIndex = index
		let announcement = announcements[index]
		self.loadImage(announcement: announcement)
		self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
        self.saveAnnouncement(announcement: announcement)
	}

	func loadImage(announcement:Announcement) {
		self.imageView.image = nil
		self.imageView.contentMode = .scaleAspectFill
		if let imagePath = announcement.image_path?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
			
			self.imageView.loadImage(urlString: configs.imageUrl + imagePath ) {  (status, url, image, msg) in
				if(status == STATUS.success) {
					print("image loaded" + msg)
				} else {
					print("Error in loading image" + msg)
				}
			}
		}
	}

	func saveAnnouncement(announcement:Announcement) {
		let defaults = UserDefaults.standard
		defaults.synchronize()
		if var oldAnnouncements = defaults.value(forKey: "AnnouncementID") as? [String] {
			if let aID = announcement.id, !oldAnnouncements.contains(aID) {
				oldAnnouncements.append(aID)
				defaults.set(oldAnnouncements, forKey: "AnnouncementID")
			}
		} else {
			defaults.set([announcement.id], forKey: "AnnouncementID")
		}
	}
}


extension AnnouncementsViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	//MARK: -  UICollectionView
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let announcements = self.announcements else {
			return 0
		}
		return announcements.count
    }

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let guide = view.safeAreaLayoutGuide
		let height = guide.layoutFrame.size.height - 100
		let width = guide.layoutFrame.size.width

        return CGSize(width: width, height: height)
	}
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		//self.setupUIandContent(index:indexPath.item)
		guard let aCell = cell as? AnnouncementCell, let announcements = self.announcements else {
			return
		}
		//Change next previous button status
		aCell.nextButton.isHidden = indexPath.item == announcements.count - 1
		aCell.previousButton.isHidden = indexPath.item == 0
	}

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnouncementCell", for: indexPath) as? AnnouncementCell

		guard let content = self.announcements?[indexPath.item] else {
			return cell!
		}
		cell?.titleLabel.text = content.title
		cell?.descriptionLabel.text = content.desc
		cell?.notesLabel.text = content.notes


		if content.is_white_notes == "1" {
			cell?.notesLabel.textColor = .white
		} else {
			cell?.notesLabel.textColor = .black
		}
		if content.is_white_description == "1" {
			cell?.descriptionLabel.textColor = .white
		} else {
			cell?.descriptionLabel.textColor = .black
		}
		if content.is_white_title == "1" {
			cell?.titleLabel.textColor = .white
		} else {
			cell?.titleLabel.textColor = .black
		}

		cell?.notesLabel.isHidden = content.hide_notes == "1"
		cell?.descriptionLabel.isHidden = content.hide_description == "1"
		cell?.titleLabel.isHidden = content.hide_title == "1"

		cell?.previousButton.addTarget(self, action: #selector(previousAction(_:)), for: .touchUpInside)
		cell?.goButton.addTarget(self, action: #selector(goAction(_:)), for: .touchUpInside)
		cell?.nextButton.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)

		cell!.backgroundColor = .clear
        return cell!
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

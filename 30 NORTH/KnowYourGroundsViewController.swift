//
//  KnowYourGroundsViewController.swift
//  30 NORTH
//
//  Created by Anil Kumar on 19/05/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import SwiftUI


class KnowYourGroundsViewController: UIViewController {
   
    @IBOutlet weak var collectinoView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    let nameArray : [String] = ["Coarse","Medium","Fine","Extra Fine","Turkish"]
    let imgArray : [String] = ["coarse_off","medium_off","fine_off","extra_fine_off","turkish_off"]
    let selectedImgArray : [String] = ["coarse_on","medium_on","fine_on","extra_fine_on","turkish_on"]
      let descriptionArray : [String] = ["Large chunks of beans mixed with smaller finer grain. This grind size is preferred for French Press","This grind size is mostly used in pour-over brewers with a flat bottom like Kalita Wave. Evenly ground beans with very small chunks","A granule-link consistency with very fine chunks of coffee beans. Preferred when used with a cone-shaped dripper like Hario V60, Bonmac and others","A much smoother texture similar to table salt. Perfect for Espresso and Mocha Pot","Very powdery consistency, only burr grinders can achieve this level of texture. This grind size is ideal for Turkish coffee"]
    
    var selectionArray : [String] = ["1","0","0","0","0"]

    override func viewDidLoad() {
       super.viewDidLoad()
       self.view.backgroundColor = UIColor.black
        
        self.collectinoView.delegate = self
        self.collectinoView.dataSource = self
        self.collectinoView.backgroundColor = .clear
        self.layoutCells()
        
        self.titleLabel.text = nameArray[0]
        self.descriptionLabel.text = descriptionArray[0]
    }
    
    func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 5.0
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.itemSize = CGSize(width: 128, height:128)
        self.collectinoView.collectionViewLayout = layout
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

extension KnowYourGroundsViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groundTypesCell", for: indexPath) as! groundTypeCell
        cell.tag = indexPath.row
        cell.tileLabel.text = nameArray[indexPath.row]
        if(self.selectionArray[indexPath.row] == "1"){
            cell.ImgView.image = UIImage.init(named: selectedImgArray[indexPath.row])

        }else{
            cell.ImgView.image = UIImage.init(named: imgArray[indexPath.row])

        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectionArray = ["0","0","0","0","0"]
        self.selectionArray[indexPath.row] = "1"
        self.titleLabel.text = nameArray[indexPath.row]
        self.descriptionLabel.text = descriptionArray[indexPath.row]
        self.collectinoView.reloadData()

    }
}

class FeaturedCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    var isItem = false
    var subCategoryId: String = ""
    var subCategoryName: String = ""
}


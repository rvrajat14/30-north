//
//  RewardsCatalogVC.swift
//  30 NORTH
//
//  Created by SOWJI on 20/03/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire

class RewardsCatalogVC: UIViewController {
    var rewardCatalogs = [Catalog]()
    var rewardsDelegate : RewardPointsDelegate?
    var rewardPoints : UInt64 = 0

	@IBOutlet weak var titleLabel: UILabel! {
		didSet {
			titleLabel.titleStyle(text: "Rewards")
		}
	}

    @IBOutlet weak var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        table.delegate = self
        table.dataSource = self
        table.reloadData()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        self.showCartButton()
		self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
	}

    @IBAction func navigate(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func checkRewardPoints(index: Int){
        
        if !Common.instance.isUserLogin() {

            _ = SweetAlert().showAlert("30 North Rewards", subTitle: "Sign up to get started with 200 free reward points!", style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Sign Up", buttonColor: UIColor.colorFromRGB(0xAEDEF4) , otherButtonTitle: "Cancel", action: { (isOk) in
                if isOk{
                    let UserRegViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as! RegisterViewController
                    self.navigationController?.pushViewController(UserRegViewController, animated: true)
                }
                })
//               _ = SweetAlert().showAlert("30 North Rewards", subTitle: "You don’t have enough points. Drink more coffee!", style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Ok", buttonColor: UIColor.colorFromRGB(0xAEDEF4),action: { (isOk) in
////                self.navigationController?.popViewController(animated: true)
//               })
        
        }else{
            let reward = rewardCatalogs[index]
            let selectedRewardPoints = UInt64(reward.points ?? "0")
            if rewardPoints < selectedRewardPoints!{
               //print("points ", selectedRewardPoints!, rewardPoints, self.rewardCatalogs[index].name!)
                _ = SweetAlert().showAlert("30 North Rewards", subTitle: "You don’t have enough points. Drink more coffee!", style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Ok", buttonColor: UIColor.colorFromRGB(0xAEDEF4) , action: { (isOk) in
                    if isOk{}
                    })
            }else{
                self.doRedeemPointsAPI(index: index)
            }
        }
    }

}
extension RewardsCatalogVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.rewardCatalogs.count < 1{
            EmptyMessage(message: "No rewards to redeem", tableview: tableView)
            return self.rewardCatalogs.count
        }
        EmptyMessage(message: "", tableview: tableView)
        return self.rewardCatalogs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView()

        let cell = tableView.dequeueReusableCell(withIdentifier: "catalogCell", for: indexPath) as! CatalogCell
        cell.selectionStyle = .none
        let catalog = self.rewardCatalogs[indexPath.row]
        let title = catalog.name ?? ""
        cell.TitleLabel.text = title + " (\(catalog.points!)) points"
        cell.descriptionLabel.text = catalog.catDescription ?? ""
        cell.redeemButton.tag = indexPath.row
        cell.redeemButton.addTarget(self, action: #selector(redeemPoints(_:)), for: .touchUpInside)
        cell.catlogImage.backgroundColor = .clear

        cell.catlogImage.loadImage(urlString: configs.imageUrl + (catalog.imagePath ?? "")) {  (status, url, image, msg) in
            if(status == STATUS.success) {
               //print(url + " is loaded successfully.")
                cell.catlogImage.image = image
            }else {
                cell.catlogImage.image = UIImage(named: "defaultImage")
                cell.catlogImage.backgroundColor = .black
               //print("Error in loading image" + msg)
            }
        }

		cell.backgroundColor = .clear
        return cell
    }
	
    @objc func redeemPoints (_ sender : UIButton) {
        
        checkRewardPoints(index: sender.tag)
    }
    
    func doRedeemPointsAPI(index: Int){
        
        if let points = self.rewardCatalogs[index].points{
           //print("points ", points, rewardPoints, self.rewardCatalogs[index].name!)

            _ = SweetAlert().showAlert("30 North Rewards", subTitle: "Do you want to redeem \(points) reward points for \(self.rewardCatalogs[index].name!) ", style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Cancel", buttonColor: UIColor.colorFromRGB(0xAEDEF4), otherButtonTitle: "Ok", action: { (isOk) in
                if !isOk {
                    _ = EZLoadingActivity.show("Loading...", disableUI: true)
                    if let id = UserDefaults.standard.value(forKey: "userID") as? Int{
                        
                        //        let existedPoints = UserDefaults.standard.integer(forKey: "rewardpoints")
                        
                        //let url = APIRouters.pointsURLString + "\(id)&points=\(points)&type=2"
                        let url = APIRouters.redeemPointsURLString + "\(id)&points=\(points)&type=2"
                        //                let url = "http://lvngs.com/api/do_points?user_id=\(id)"
                        Alamofire.request(url).responseJSON {  response  in
                            _ = EZLoadingActivity.hide()
                            
                            if let result = response.result.value {
                               print(result)
                                let data = result as! [String : Any]
                                if let code = data["success"] as? Int {
                                    if code == 1{
                                        
                                        let alertMsg = String(format: "You have successfully redeemed %@ points for %@",points,self.rewardCatalogs[index].name!)
                                        _ = SweetAlert().showAlert(language.rewardsTitle, subTitle: alertMsg, style: AlertStyle.customImag(imageFile: "Logo"), buttonTitle: "Ok", buttonColor: UIColor.colorFromRGB(0xAEDEF4), action: { (isOk) in
                                            if isOk {
                                                self.rewardsDelegate?.rewardpointsUpdated()
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

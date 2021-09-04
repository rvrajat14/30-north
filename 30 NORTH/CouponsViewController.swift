//
//  CouponsViewController.swift
//  30 NORTH
//
//  Created by vinay on 28/05/19.
//  Copyright © 2019 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire
import XLPagerTabStrip

class CouponsViewController: UIViewController {

    var itemInfo: IndicatorInfo = "OFFERS"

    //MARK:- Property
    @IBOutlet weak var couponTableView: UITableView!
    
    //MARK:- Variable Declaration
    
    // var carbonNavigation : CarbonTabSwipeNavigation?
    var couponsArray: [CouponDetail]? = nil
    
   
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.mainViewBackground
		couponTableView.delegate = self
        couponTableView.dataSource = self
        
        getRequestAPICall()
    }

    internal static func instantiate(with  itemInfo: IndicatorInfo) -> CouponsViewController {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CouponsViewController") as! CouponsViewController
        vc.itemInfo = itemInfo
        return vc
    }
    
    //MARK:- Button Action
    @IBAction func onClipboard(_ sender: UIButton) {
        
        if let couponDetails = couponsArray?[sender.tag]{
            let couponCode = couponDetails.couponCode
            
            let coupon = couponCode!.description
            let pasteboard = UIPasteboard.general
            pasteboard.string = "\(coupon)"

            
            let alert = UIAlertController(title: "", message: "Ahh! 😄 Coupon Code \(coupon) Copied", preferredStyle: UIAlertController.Style.alert)
            
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK:- API Call
    func getRequestAPICall()  {
       //print("need to laod from API")
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        let url = APIRouters.baseURLString + "/coupons/get"
        Alamofire.request(url).responseJSON { (response) in
            _ = EZLoadingActivity.hide()

            switch response.result {
            case .success:
                    let jsonData = response.data
                    do{
                        let coupon: Coupons = try JSONDecoder().decode(Coupons.self, from: jsonData!)
                       //print(coupon)
                        
                        if coupon.status == "success"{
                            self.couponsArray = coupon.data
                        }
                        self.couponTableView.reloadData()
                     
                    }catch {
                       //print("Error: \(error)")
                    }
                
            case .failure(let error):
               print(error)
            }

            
        }
  
    }

}

extension CouponsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponsArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponsTableViewCell", for: indexPath) as! CouponsTableViewCell
        
        if let couponDetails = couponsArray?[indexPath.row]{
            cell.couponName.text = couponDetails.couponName
            cell.couponCode.text = couponDetails.couponCode
            cell.copyToClipboardButton.tag = indexPath.row
        }
        return cell
    }
}

extension CouponsViewController : IndicatorInfoProvider
{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

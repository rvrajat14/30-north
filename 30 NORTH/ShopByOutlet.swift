//
//  ShopByOutlet.swift
//  30 NORTH
//
//  Created by AnilKumar on 04/08/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import Foundation

class ShopByOutlet: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var allOutlets : [Outlet]?
    var allItemsFrom30North : [ItemModel]?


   @IBOutlet weak var outletsTableView: UITableView!{
        didSet {
            outletsTableView.backgroundColor = UIColor.clear
            outletsTableView.delegate = self
            outletsTableView.dataSource = self
            outletsTableView.register(UINib(nibName: "ShopByOutletCell", bundle: nil), forCellReuseIdentifier: "ShopByOutletCell")
        }
    }
    
    //MARK: View Did Load & Life Cycle
             override func viewDidLoad() {
                 super.viewDidLoad()
                 // Do any additional setup after loading the view.
                self.view.backgroundColor = UIColor.mainViewBackground
                self.outletsTableView.reloadData()
             }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.titleView = setNavbarImage()
        self.showCartButton()
    }
    
    
             override func viewWillAppear(_ animated: Bool) {
                    super.viewWillAppear(animated)
                    //we do not need navigation controller on home screen
                }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allOutlets!.count
          }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
           return 200.0
       }
       
       
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ShopByOutletCell") as! ShopByOutletCell
            let outlet : Outlet = self.allOutlets![indexPath.row]
            
            
            if let _ = outlet.open_from, let _ = outlet.open_to {
                if(outlet.is_open == 0) {
                    // Closed
                } else {
                    let dateFromat = DateFormatter()
                    dateFromat.dateFormat = "HH:mm"
                    let dateFrom : Date = dateFromat.date(from: (outlet.open_from)!)! // In your case its string1
                    print(dateFrom)
                    let dateTo : Date = dateFromat.date(from: (outlet.open_to)!)! // In your case its string1
                    print(dateTo)
                    let currentDateString : String = dateFromat.string(from: Date())
                    let currentDate : Date = dateFromat.date(from: (currentDateString))!
                    print(currentDate)
                    
                    if(currentDate.isBetween(dateFrom, and: dateTo) == true){
                        //openUntil.text = "Open until \(toTimeArray[1])"
                          let ab : TimeInterval = dateTo.timeIntervalSince(currentDate)
                                             if(ab < 1800 && ab > 0){
                                                let str = outlet.name! + " (Closing Soon)"
                                                let font = UIFont(name: AppFontName.bold, size: 18)
                                                let italicsFont = UIFont.italicSystemFont(ofSize: 18)
                                                let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : font!])
                                                attributedString.addAttribute(NSAttributedString.Key.font, value: italicsFont, range: NSMakeRange(str.count-15, 15))
                                                cell.outletName.attributedText = attributedString

                                             }else{
                                                    let str = outlet.name!
                                                    let font = UIFont(name: AppFontName.bold, size: 18)
                                                    let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : font!])
                                                    cell.outletName.attributedText = attributedString
                                                
                        }
                    }
                    else{
                        let str = outlet.name!
                        let font = UIFont(name: AppFontName.bold, size: 18)
                        let attributedString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : font!])
                        cell.outletName.attributedText = attributedString
                        
                    }
                }
            }
            
            
            
            //cell.outletName.text = outlet.name
           //cell.outletImage.image = UIImage(named: optionImages[indexPath.row])
            cell.outletImage.kf.setImage(with: URL(string: configs.outletImageUrl + outlet.id! + ".png"), placeholder: UIImage(named: "itemImagePlaceholder"), options: .none, progressBlock: .none)
           cell.backgroundColor = .clear
            cell.selectionStyle = .none
                      return cell

          }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let outlet : Outlet = self.allOutlets![indexPath.row]
        print("Selected outlet id is \(outlet.id!)")
        //let itemsForOutlet = self.allItemsFrom30North!.filter({$0.shops.shopId == outlet.id })
        
        let itemsForOutlet = self.allItemsFrom30North!.filter({ (item) -> Bool in
            let AllShops = item.shops
            let isShopThere = AllShops.filter({$0.shopId == outlet.id})
            if(isShopThere.count > 0){
                return true
            }else{
                return false
            }
        })
        
        print("Total items for Outlet \(itemsForOutlet.count)")
        
        if(itemsForOutlet.count > 0){
        let orderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderTabViewController") as! OrderTabViewController
        orderVC.selectedOutlet = outlet
        orderVC.allItemsForSelectedOutlet = itemsForOutlet
            orderVC.isShowingOutletMenuItems = true
        self.navigationController?.pushViewController(orderVC, animated: true)
        }else{
            _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noItemsForOutlet, style: AlertStyle.customImag(imageFile: "Logo"))

        }
    }
}

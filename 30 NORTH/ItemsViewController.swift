//
//  ItemsViewController.swift
//  30 NORTH
//
//  Created by Apple on 4/7/20.
//  Copyright © 2020 Pineappeal Limited. All rights reserved.
//

import UIKit
import Alamofire

class ItemsViewController: UIViewController {

    @IBOutlet weak var itemsTableView: UITableView!
    
    var selectedItemCurrencySymbol = ""
    var selectedItemCurrencyShortform = ""
    var selectedItemIndex = 0
    
    var selectedItemsArray: [[String: Any]]!
    var refreshControl = UIRefreshControl()
    
    var categoryArr = [Categories]()
    var subCategoryArray = [SubCategories]()
    var itemsArray = [ItemModel]()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        itemsTableView.addSubview(refreshControl)

        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        if let _ = settingsDetailModel{
            selectedItemCurrencySymbol = settingsDetailModel!.currency_symbol!
            selectedItemCurrencyShortform = settingsDetailModel!.currency_short_form!
        }
        loadShopData(isRefresh: false)
    }

    @objc func refresh(sender:AnyObject) {
       //print("pull to refressh yeah")
        loadShopData(isRefresh: true)
    }
    //MARK: API Call
    func loadShopData(isRefresh: Bool) {
            refreshControl.endRefreshing()

        if !isRefresh{
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
        }
            _ = Alamofire.request(APIRouters.GetShopByID(1)).responseObject {
            (response: DataResponse<Shop>) in
                
                DispatchQueue.main.async {


                switch response.result {
                case .success:

                            if let shop: Shop = response.result.value {
                               //print(shop)
                                
                                self.categoryArr.removeAll()
                                self.itemsArray.removeAll()
                                shopModel = ShopModel(shop: shop)

                                var itemsArr = [ItemModel]()
                                for cat in shop.categories{
                                    self.subCategoryArray.removeAll()
                                    
                                    for subCat in cat.subCategories{
                                        itemsArr.removeAll()
                                        for item in subCat.item {
                                            let oneItem = ItemModel(item: item)
                                            itemsArr.append(oneItem)
                                            self.itemsArray.append(oneItem)
                                        }
                                        
                                        let tempSubCat = SubCategories(id: subCat.id!, catId: subCat.catId!, name: subCat.name!,description: (subCat.desc != nil ? subCat.desc! : ""), imageURL: subCat.coverImageFile!, items: itemsArr)
                                        self.subCategoryArray.append(tempSubCat)
                                    }
                                    
                                    let tempCat = Categories(id: cat.id!, name: cat.name!, desc: cat.desc ?? "", imageURL: cat.coverImageFile!, subCategory: self.subCategoryArray)
                                    self.categoryArr.append(tempCat)
                                }
                                self.filterItems()
                               //print("items list : ",self.itemsArray)
                                _ = EZLoadingActivity.hide()
                                
                            }else{
                                _ = EZLoadingActivity.hide()
                            }
                case .failure(let error):
                   //print(error)
                    _ = EZLoadingActivity.hide()
                }

                }
            }
            
        }
    
    func filterItems(){
        
        var itemsArr = [ItemModel]()
        
        for selectedItem in selectedItemsArray{
            for item in itemsArray{
                let itemId = selectedItem["item_id"] as! Int
                if Int(item.itemId) == itemId{
                    itemsArr.append(item)
                }
            }
        }
        itemsArray = itemsArr
        self.itemsTableView.reloadData()
    }
}

 
extension ItemsViewController : UITableViewDelegate, UITableViewDataSource{
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.itemsArray.count < 1{
            EmptyMessage(message: "No Items Available", tableview: tableView)
            return self.itemsArray.count
        }
        EmptyMessage(message: "", tableview: tableView)
        return self.itemsArray.count
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 205
    }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! SubcategoryItemCell
            cell.selectionStyle = .none
            tableView.tableFooterView = UIView()
            let item = self.itemsArray[indexPath.row]
            cell.item = item //items![(indexPath as NSIndexPath).item]
            let imageURL = configs.imageUrl + item.itemImage
//            cell.subitemImage?.loadImage(urlString: imageURL) {  (status, url, image, msg) in
//                if(status == STATUS.success) {
//                    //print(url + " is loaded successfully.")
////                    self.items![indexPath.item].itemImageBlob = image
//                }else {
//                    //print("Error in loading image" + msg)
//                }
//            }
            cell.subitemImage.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder_image"), options: .none, progressBlock: .none)

            cell.bodyView.isHidden = true
            cell.acidityView.isHidden = true
            cell.aromaView.isHidden = true
            cell.tasteView.isHidden = true
            cell.profileView.isHidden = true
            
            let body = item.body
            if body.count > 0{
                cell.bodyView.isHidden = false
                cell.bodyLabel.text = item.body
            }
            
            let acidity = item.acidity
            if acidity.count > 0{
                cell.acidityView.isHidden = false
                cell.acidityLabel.text = item.acidity
            }
                
            let aroma = item.aroma
            if aroma.count > 0{
                cell.aromaView.isHidden = false
                cell.aromaLabel.text = item.aroma
            }
         
            let taste = item.taste
            if taste.count > 0{
                cell.tasteView.isHidden = false
                cell.tasteLabel.text = item.taste
            }
                    
            let profile = item.profile
            if profile.count > 0{
                cell.profileView.isHidden = false
                cell.profileLabel.text = item.profile
            }
            
            let priceNote = item.price_note
            let price = item.itemPrice
            if Double(price)! > 0{
                cell.subitemPrice.text = price + " \(self.selectedItemCurrencySymbol) \(priceNote)"
                cell.subitemPrice.isHidden = false
            }else{
                cell.subitemPrice.text = "0 \(self.selectedItemCurrencySymbol) \(priceNote)"
                cell.subitemPrice.isHidden = true
            }
            
            cell.subitemImage.alpha = 1.0
            cell.subitemName.alpha = 1.0
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedItemIndex = indexPath.row
            itemDetail = itemsArray[selectedItemIndex]
            
            let itemDetailVC = self.storyboard?.instantiateViewController(identifier: "ItemDetail") as! ItemDetailViewController
            self.navigationController?.pushViewController(itemDetailVC, animated: true)
//            let cell = tableView.cellForRow(at: indexPath)
//            self.performSegue(withIdentifier: "ItemDetail", sender: cell)
        }
    
}

//
//  ReservationHistoryTableViewController.swift
//  Restaurateur
//
//  Created by PPH-MacMini on 27/11/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

class ReservationHistoryTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var loginUserId: Int = 0
    var resvs = [ReservationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.mainViewBackground

        loadLoginUserId()
        loadReservation()
        
//        if self.revealViewController() != nil {
//            menuButton.target = self.revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resvs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell") as! ReservationCell
        let resv = resvs[(indexPath as NSIndexPath).row]
        
        cell.configure(resv.id, date: resv.resvDate, time: resv.resvTime, status : resv.status, name: resv.userName, email: resv.userEmail, phone: resv.userPhone, additionalNote: resv.note)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        // Prepare the basic data
        // If you changed the UI in storyboard, you need to change the value in here as well
        let leftMargin : CGFloat = 16
        let rightMargin : CGFloat = 16
        let bottomMargin : CGFloat = 30
        let fontSize : CGFloat = 14
        let reserInfoTopMargin : CGFloat = 8
        let reserInfoHeight : CGFloat = 126
        let reserInfoBottomMargin : CGFloat = 20
        let NoteHeightOneLine : CGFloat = 21
        let ContactPersonInfoHeight = 128 - NoteHeightOneLine // Note Label Height will be calculate below and will add
        
        // Estimating the size of note
        let approximateWidthOfBioTextView = tableView.frame.width - leftMargin - rightMargin - 16
        let size = CGSize(width: approximateWidthOfBioTextView, height : 1000)
        let attributesWithFontAndSize = [NSAttributedString.Key.font: UIFont.init(name: "NexaLight", size: fontSize)!]
        /* Attribute only with fontsize
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10)] */
       //print("Frame width : \(tableView.frame.width)")
        let resv = resvs[(indexPath as NSIndexPath).row]
       //print("Note : \(resv.note)")
        let noteData : String = language.note + resv.note
        
        let estimateNoteFrame = NSString(string: noteData).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributesWithFontAndSize, context: nil)
        let estimateNoteHeight : CGFloat = estimateNoteFrame.height
        
        // print all values to check
       //print("reserInfoTopMargin : \(reserInfoTopMargin)")
       //print("reserInfoHeight : \(reserInfoHeight)")
       //print("reserInfoBottomMargin : \(reserInfoBottomMargin)")
       //print("ContactPersonInfoHeight : \(ContactPersonInfoHeight)")
       //print("estimateNoteHeight : \(estimateNoteHeight)")
        
        // sum all to get row height
        let rowHeight : CGFloat = reserInfoTopMargin +
                            reserInfoHeight +
                            reserInfoBottomMargin +
                            ContactPersonInfoHeight +
                            estimateNoteHeight +
                            bottomMargin
        
        return rowHeight
    }
    
    
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.reservationHistory
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSAttributedString.Key.foregroundColor:UIColor.white]        
    }
    
    func loadReservation() {
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        Alamofire.request(APIRouters.ReservationHistory(loginUserId)).responseCollection {
            (response: DataResponse<[Reservation]>) in
            if response.result.isSuccess {
                
                _ = EZLoadingActivity.hide()
                
                if let resvs: [Reservation] = response.result.value {
                   
                    for resv in resvs {
                        
                        let oneResv = ReservationModel(resvData: resv)
                        
                        self.resvs.append(oneResv)
                    }
                    
                    self.tableView.reloadData()
                    
                    
                } else {
                   //print(response)
                }
            } else {
             
               //print(response.result)
            }
            
            
        }
    }
    
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: plistPath)) {
            if let bundlePath = Bundle.main.path(forResource: "LoginUserInfo", ofType: "plist") {
                
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: plistPath)
                } catch{
                    
                }
                
                
            } else {
                //print("LoginUserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
            
        } else {
            //print("LoginUserInfo.plist already exits at path.")
        }
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        
        if let dict = myDict {
            
            loginUserId           = Common.instance.getLoginUserId(dict: dict)
        } else {
           //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
}
